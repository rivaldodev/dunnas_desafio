-- Regras adicionais para aderir estritamente à prova.md
-- 1. Ao criar locacao: registrar automaticamente pagamento de SINAL = 50% do valor_total.
-- 2. Ao finalizar (status -> FINALIZADA): registrar automaticamente pagamento RESTANTE (valor_total - sinal) se ainda não pago.
-- 3. Ajustar validações para exigir exatamente 50% no sinal e restante igual à diferença.
-- 4. Migrar locações existentes sem sinal para gerar o pagamento correspondente.

-- Recria função de validação de pagamentos para reforçar valores exatos
CREATE OR REPLACE FUNCTION fn_movimentacao_before_insert() RETURNS TRIGGER AS $$
DECLARE
    v_locacao RECORD;
    v_sinal NUMERIC(12,2);
    v_restante NUMERIC(12,2);
    v_meta_sinal NUMERIC(12,2);
BEGIN
    SELECT * INTO v_locacao FROM locacao WHERE id = NEW.locacao_id FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Locacao % nao existe', NEW.locacao_id USING ERRCODE='23503';
    END IF;

    v_meta_sinal := round(v_locacao.valor_total * 0.5, 2);

    SELECT COALESCE(SUM(CASE WHEN tipo = 'SINAL' THEN valor END),0) AS sinal,
           COALESCE(SUM(CASE WHEN tipo = 'RESTANTE' THEN valor END),0) AS restante
      INTO v_sinal, v_restante
      FROM movimentacao_financeira
     WHERE locacao_id = NEW.locacao_id;

    IF NEW.tipo = 'SINAL' THEN
        IF v_sinal > 0 THEN
            RAISE EXCEPTION 'Pagamento de sinal ja registrado para locacao %', NEW.locacao_id USING ERRCODE='23514';
        END IF;
        IF NEW.valor <> v_meta_sinal THEN
            RAISE EXCEPTION 'Valor do sinal deve ser exatamente % para locacao %', v_meta_sinal, NEW.locacao_id USING ERRCODE='23514';
        END IF;
    ELSIF NEW.tipo = 'RESTANTE' THEN
        IF v_sinal = 0 THEN
            RAISE EXCEPTION 'Nao é permitido restante antes do sinal locacao %', NEW.locacao_id USING ERRCODE='23514';
        END IF;
        IF v_restante > 0 THEN
            RAISE EXCEPTION 'Pagamento restante ja registrado locacao %', NEW.locacao_id USING ERRCODE='23514';
        END IF;
        IF NEW.valor <> (v_locacao.valor_total - v_sinal) THEN
            RAISE EXCEPTION 'Valor restante deve ser % para locacao %', (v_locacao.valor_total - v_sinal), NEW.locacao_id USING ERRCODE='23514';
        END IF;
    END IF;
    RETURN NEW;
END;$$ LANGUAGE plpgsql;

-- Função after insert para gerar sinal automático
CREATE OR REPLACE FUNCTION fn_locacao_after_insert_auto_sinal() RETURNS TRIGGER AS $$
DECLARE
    v_valor NUMERIC(12,2);
BEGIN
    v_valor := round(NEW.valor_total * 0.5, 2);
    INSERT INTO movimentacao_financeira (usuario_id, locacao_id, tipo, valor)
    VALUES (NEW.cliente_id, NEW.id, 'SINAL', v_valor);
    UPDATE locacao SET sinal_pago = TRUE WHERE id = NEW.id;
    RETURN NEW;
END;$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_locacao_after_insert_auto_sinal
AFTER INSERT ON locacao
FOR EACH ROW EXECUTE FUNCTION fn_locacao_after_insert_auto_sinal();

-- Recria função de finalização para inserir restante automaticamente
CREATE OR REPLACE FUNCTION fn_locacao_after_update_finalize() RETURNS TRIGGER AS $$
DECLARE
    v_sinal NUMERIC(12,2);
    v_restante NUMERIC(12,2);
    v_valor_restante NUMERIC(12,2);
BEGIN
    IF NEW.status = 'FINALIZADA' AND OLD.status <> 'FINALIZADA' THEN
        IF NEW.devolvida_em IS NULL THEN
            UPDATE locacao SET devolvida_em = now() WHERE id = NEW.id;
        END IF;
        -- Inserir restante se ainda não pago
        SELECT COALESCE(SUM(CASE WHEN tipo='SINAL' THEN valor END),0),
               COALESCE(SUM(CASE WHEN tipo='RESTANTE' THEN valor END),0)
          INTO v_sinal, v_restante
          FROM movimentacao_financeira WHERE locacao_id = NEW.id;
        IF v_restante = 0 THEN
            v_valor_restante := NEW.valor_total - v_sinal;
            INSERT INTO movimentacao_financeira (usuario_id, locacao_id, tipo, valor)
            VALUES (NEW.cliente_id, NEW.id, 'RESTANTE', v_valor_restante);
            UPDATE locacao SET restante_pago = TRUE WHERE id = NEW.id;
        END IF;
        -- devolver estoque
        UPDATE catalogo_locador SET estoque = estoque + 1
         WHERE locador_id = NEW.locador_id AND obra_id = NEW.obra_id;
    END IF;
    RETURN NEW;
END;$$ LANGUAGE plpgsql;

-- Atualizar locações antigas sem sinal (antes desta versão)
DO $$
DECLARE r RECORD; v_metade NUMERIC(12,2); BEGIN
  FOR r IN SELECT * FROM locacao WHERE sinal_pago = FALSE LOOP
    v_metade := round(r.valor_total * 0.5,2);
    BEGIN
      INSERT INTO movimentacao_financeira (usuario_id, locacao_id, tipo, valor)
      VALUES (r.cliente_id, r.id, 'SINAL', v_metade);
      UPDATE locacao SET sinal_pago = TRUE WHERE id = r.id;
    EXCEPTION WHEN others THEN
      RAISE NOTICE 'Falha gerar sinal auto locacao %: %', r.id, SQLERRM;
    END;
  END LOOP;
END $$;
