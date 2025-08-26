-- Regras de negócio para locação e pagamentos (>50% lógica no banco)
-- 1. Ao criar locação: validar estoque e decrementar.
-- 2. Ao finalizar locação (status -> FINALIZADA): exigir pagamentos completos, registrar devolução e devolver estoque.
-- 3. Pagamentos: exigir ordem SINAL depois RESTANTE; valores consistentes.
-- 4. Flags sinal_pago/restante_pago na tabela locacao atualizadas automaticamente.

-- Função: valida e decrementa estoque antes de inserir locação
CREATE OR REPLACE FUNCTION fn_locacao_before_insert() RETURNS TRIGGER AS $$
DECLARE
    v_afetados INTEGER;
BEGIN
    -- Verifica existência de registro no catálogo e estoque disponível
    UPDATE catalogo_locador
       SET estoque = estoque - 1
     WHERE locador_id = NEW.locador_id
       AND obra_id = NEW.obra_id
       AND estoque > 0;
    GET DIAGNOSTICS v_afetados = ROW_COUNT;
    IF v_afetados = 0 THEN
        RAISE EXCEPTION 'Estoque indisponivel para locador % obra %', NEW.locador_id, NEW.obra_id
            USING ERRCODE = '23514'; -- check_violation
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_locacao_before_insert
BEFORE INSERT ON locacao
FOR EACH ROW EXECUTE FUNCTION fn_locacao_before_insert();

-- Função: valida tentativa de finalização (status -> FINALIZADA) antes do update
CREATE OR REPLACE FUNCTION fn_locacao_before_update_validate() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'FINALIZADA' AND OLD.status <> 'FINALIZADA' THEN
        IF NOT (OLD.sinal_pago AND OLD.restante_pago) THEN
            RAISE EXCEPTION 'Nao é permitido finalizar locacao sem pagamentos completos'
                USING ERRCODE = '23514';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_locacao_before_update_validate
BEFORE UPDATE OF status ON locacao
FOR EACH ROW EXECUTE FUNCTION fn_locacao_before_update_validate();

-- Função: após finalização devolver estoque e registrar devolvida_em
CREATE OR REPLACE FUNCTION fn_locacao_after_update_finalize() RETURNS TRIGGER AS $$
DECLARE
    v_afetados INTEGER;
BEGIN
    IF NEW.status = 'FINALIZADA' AND OLD.status <> 'FINALIZADA' THEN
        IF NEW.devolvida_em IS NULL THEN
            UPDATE locacao SET devolvida_em = now() WHERE id = NEW.id;
        END IF;
        UPDATE catalogo_locador
           SET estoque = estoque + 1
         WHERE locador_id = NEW.locador_id
           AND obra_id = NEW.obra_id;
        GET DIAGNOSTICS v_afetados = ROW_COUNT;
        IF v_afetados = 0 THEN
            RAISE WARNING 'Catalogo nao encontrado ao devolver estoque (locacao %)', NEW.id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_locacao_after_update_finalize
AFTER UPDATE OF status ON locacao
FOR EACH ROW EXECUTE FUNCTION fn_locacao_after_update_finalize();

-- Função: valida regras de pagamentos antes de inserir movimentacao
CREATE OR REPLACE FUNCTION fn_movimentacao_before_insert() RETURNS TRIGGER AS $$
DECLARE
    v_locacao RECORD;
    v_sinal NUMERIC(12,2);
    v_restante NUMERIC(12,2);
BEGIN
    SELECT * INTO v_locacao FROM locacao WHERE id = NEW.locacao_id FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Locacao % nao existe', NEW.locacao_id USING ERRCODE='23503';
    END IF;

    SELECT COALESCE(SUM(CASE WHEN tipo = 'SINAL' THEN valor END),0) AS sinal,
           COALESCE(SUM(CASE WHEN tipo = 'RESTANTE' THEN valor END),0) AS restante
      INTO v_sinal, v_restante
      FROM movimentacao_financeira
     WHERE locacao_id = NEW.locacao_id;

    IF NEW.tipo = 'SINAL' THEN
        IF v_sinal > 0 THEN
            RAISE EXCEPTION 'Pagamento de sinal ja registrado para locacao %', NEW.locacao_id USING ERRCODE='23514';
        END IF;
        IF NEW.valor <= 0 OR NEW.valor >= v_locacao.valor_total THEN
            RAISE EXCEPTION 'Valor de sinal invalido (deve ser >0 e < total) locacao %', NEW.locacao_id USING ERRCODE='23514';
        END IF;
    ELSIF NEW.tipo = 'RESTANTE' THEN
        IF v_sinal = 0 THEN
            RAISE EXCEPTION 'Registrar restante somente apos sinal locacao %', NEW.locacao_id USING ERRCODE='23514';
        END IF;
        IF v_restante > 0 THEN
            RAISE EXCEPTION 'Pagamento restante ja registrado locacao %', NEW.locacao_id USING ERRCODE='23514';
        END IF;
        IF NEW.valor <> (v_locacao.valor_total - v_sinal) THEN
            RAISE EXCEPTION 'Valor restante deve ser % para locacao %', (v_locacao.valor_total - v_sinal), NEW.locacao_id USING ERRCODE='23514';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_movimentacao_before_insert
BEFORE INSERT ON movimentacao_financeira
FOR EACH ROW EXECUTE FUNCTION fn_movimentacao_before_insert();

-- Função: atualiza flags de pagamento na locacao após inserir movimentacao
CREATE OR REPLACE FUNCTION fn_movimentacao_after_insert_update_flags() RETURNS TRIGGER AS $$
DECLARE
    v_sinal_pago BOOLEAN;
    v_restante_pago BOOLEAN;
BEGIN
    IF NEW.tipo = 'SINAL' THEN
        UPDATE locacao SET sinal_pago = TRUE WHERE id = NEW.locacao_id;
    ELSIF NEW.tipo = 'RESTANTE' THEN
        UPDATE locacao SET restante_pago = TRUE WHERE id = NEW.locacao_id;
    END IF;

    SELECT sinal_pago, restante_pago INTO v_sinal_pago, v_restante_pago FROM locacao WHERE id = NEW.locacao_id;
    IF v_sinal_pago AND v_restante_pago THEN
        -- Nada adicional agora; poderíamos futuramente automatizar finalização.
        NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_movimentacao_after_insert_update_flags
AFTER INSERT ON movimentacao_financeira
FOR EACH ROW EXECUTE FUNCTION fn_movimentacao_after_insert_update_flags();
