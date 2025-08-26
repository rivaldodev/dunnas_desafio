-- Adiciona coluna de saldo ao usuario e debita automaticamente nos pagamentos
-- Mantém >50% da lógica no banco

ALTER TABLE usuario ADD COLUMN IF NOT EXISTS saldo NUMERIC(12,2) NOT NULL DEFAULT 0;

-- Credita saldo inicial para usuários de demonstração (idempotente)
-- Concede saldo demo a todos clientes sem saldo ainda (inclusive rivs@rivs.com.br)
UPDATE usuario SET saldo = 500.00 WHERE tipo = 'CLIENTE' AND saldo = 0;

-- Recria função de validação/débito para movimentações incluindo verificação de saldo
CREATE OR REPLACE FUNCTION fn_movimentacao_before_insert() RETURNS TRIGGER AS $$
DECLARE
    v_locacao RECORD;
    v_sinal NUMERIC(12,2);
    v_restante NUMERIC(12,2);
    v_meta_sinal NUMERIC(12,2);
    v_saldo NUMERIC(12,2);
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

    -- Verificação de valores exatos
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

    -- Débito de saldo do cliente (assume usuario_id = cliente pagante)
    SELECT saldo INTO v_saldo FROM usuario WHERE id = NEW.usuario_id FOR UPDATE;
    IF v_saldo IS NULL THEN
        RAISE EXCEPTION 'Usuario % inexistente', NEW.usuario_id USING ERRCODE='23503';
    END IF;
    IF v_saldo < NEW.valor THEN
        RAISE EXCEPTION 'Saldo insuficiente (disp: %, necessario: %) usuario %', v_saldo, NEW.valor, NEW.usuario_id USING ERRCODE='23514';
    END IF;
    UPDATE usuario SET saldo = saldo - NEW.valor WHERE id = NEW.usuario_id;

    RETURN NEW;
END;$$ LANGUAGE plpgsql;

-- Não é necessário recriar triggers pois nome da função permanece.
