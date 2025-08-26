-- Suporte a recarga de saldo com diferentes meios de pagamento
-- Mantém lógica de negócio no banco: validação de tipos e crédito de saldo

CREATE TYPE recarga_tipo AS ENUM ('PIX','CARTAO_CREDITO','CARTAO_DEBITO','TRANSFERENCIA');

CREATE TABLE recarga_saldo (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    tipo recarga_tipo NOT NULL,
    valor NUMERIC(12,2) NOT NULL CHECK (valor > 0),
    criada_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Função para validar e creditar saldo via trigger
CREATE OR REPLACE FUNCTION fn_recarga_after_insert() RETURNS TRIGGER AS $$
BEGIN
    UPDATE usuario SET saldo = saldo + NEW.valor WHERE id = NEW.usuario_id;
    RETURN NEW;
END;$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_recarga_after_insert
AFTER INSERT ON recarga_saldo
FOR EACH ROW EXECUTE FUNCTION fn_recarga_after_insert();
