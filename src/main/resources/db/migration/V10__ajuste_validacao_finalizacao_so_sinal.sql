-- Ajusta validação de finalização: agora apenas exige sinal pago.
-- O restante será inserido automaticamente pelo trigger AFTER UPDATE.
CREATE OR REPLACE FUNCTION fn_locacao_before_update_validate() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'FINALIZADA' AND OLD.status <> 'FINALIZADA' THEN
        IF NOT OLD.sinal_pago THEN
            RAISE EXCEPTION 'Nao é permitido finalizar locacao sem pagamento do sinal'
                USING ERRCODE = '23514';
        END IF;
        -- restante_pago pode ser falso aqui; será tratado no AFTER UPDATE
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger já existe; redefinição da função é suficiente.