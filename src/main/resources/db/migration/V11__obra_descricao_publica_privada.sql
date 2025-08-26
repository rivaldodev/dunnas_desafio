-- Adiciona campos de descrição pública e privada à obra
ALTER TABLE obra ADD COLUMN desc_publica VARCHAR(500);
ALTER TABLE obra ADD COLUMN desc_privada VARCHAR(2000);
