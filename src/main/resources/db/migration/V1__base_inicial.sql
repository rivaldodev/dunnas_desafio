CREATE TYPE user_tipo AS ENUM ('LOCADOR','CLIENTE');

CREATE TABLE role (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE usuario (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL UNIQUE,
    senha VARCHAR(120) NOT NULL,
    tipo user_tipo NOT NULL,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE usuario_role (
    usuario_id BIGINT NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    role_id BIGINT NOT NULL REFERENCES role(id) ON DELETE CASCADE,
    PRIMARY KEY (usuario_id, role_id)
);

INSERT INTO role (nome) VALUES ('ROLE_ADMIN'), ('ROLE_LOCADOR'), ('ROLE_CLIENTE');

-- Senha '123456' Bcrypt
INSERT INTO usuario (nome, email, senha, tipo) VALUES
 ('Admin','admin@local','$2a$10$8P9Ca8nHgdGXNqBJ38qdu.NcB0uKmqmLP1tTGTbtV85Ewy0NlH1X.','LOCADOR'),
 ('Cliente Demo','cliente@local','$2a$10$8P9Ca8nHgdGXNqBJ38qdu.NcB0uKmqmLP1tTGTbtV85Ewy0NlH1X.','CLIENTE');

INSERT INTO usuario_role (usuario_id, role_id)
SELECT u.id, r.id FROM usuario u JOIN role r ON (
 (u.email='admin@local' AND r.nome='ROLE_ADMIN') OR
 (u.email='admin@local' AND r.nome='ROLE_LOCADOR') OR
 (u.email='cliente@local' AND r.nome='ROLE_CLIENTE')
);
