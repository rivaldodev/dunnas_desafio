-- Ajuste real: substituir enum PostgreSQL por VARCHAR + CHECK para facilitar bind JPA
-- Mantém regras das triggers (funções de V4 continuam válidas com texto)
-- Passos: drop triggers dependentes, alterar tipo, recriar triggers, remover tipo antigo

DROP TRIGGER IF EXISTS trg_locacao_before_update_validate ON locacao;
DROP TRIGGER IF EXISTS trg_locacao_after_update_finalize ON locacao;

-- Alterar tipo (casting explícito para text)
ALTER TABLE locacao ALTER COLUMN status DROP DEFAULT;
ALTER TABLE locacao ALTER COLUMN status TYPE VARCHAR(15) USING status::text;
ALTER TABLE locacao ALTER COLUMN status SET DEFAULT 'ATIVA';

-- Constraint garantindo valores válidos
ALTER TABLE locacao ADD CONSTRAINT ck_locacao_status CHECK (status IN ('ATIVA','FINALIZADA'));

-- Recriar triggers apontando para as mesmas funções definidas em V4
CREATE TRIGGER trg_locacao_before_update_validate
BEFORE UPDATE OF status ON locacao
FOR EACH ROW EXECUTE FUNCTION fn_locacao_before_update_validate();

CREATE TRIGGER trg_locacao_after_update_finalize
AFTER UPDATE OF status ON locacao
FOR EACH ROW EXECUTE FUNCTION fn_locacao_after_update_finalize();

-- Remover tipo enum antigo se existir
DO $$
BEGIN
	IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'locacao_status') THEN
		DROP TYPE locacao_status;
	END IF;
END $$;
