-- Migra o campo tipo de user_tipo (enum) para VARCHAR(20) com constraint CHECK
ALTER TABLE usuario ALTER COLUMN tipo TYPE VARCHAR(20) USING tipo::text;
ALTER TABLE usuario ADD CONSTRAINT usuario_tipo_chk CHECK (tipo IN ('LOCADOR','CLIENTE'));
DROP TYPE IF EXISTS user_tipo;
