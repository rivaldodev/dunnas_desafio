-- Converte coluna tipo (enum recarga_tipo) para VARCHAR para compatibilidade JPA e remove o enum
ALTER TABLE recarga_saldo ALTER COLUMN tipo TYPE VARCHAR(30) USING tipo::text;
ALTER TABLE recarga_saldo ADD CONSTRAINT recarga_saldo_tipo_chk CHECK (tipo IN ('PIX','CARTAO_CREDITO','CARTAO_DEBITO','TRANSFERENCIA'));
DROP TYPE IF EXISTS recarga_tipo;
