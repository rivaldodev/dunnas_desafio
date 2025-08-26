CREATE TABLE obra (
    id BIGSERIAL PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(160),
    preco NUMERIC(12,2) NOT NULL CHECK (preco > 0),
    publico BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE catalogo_locador (
    id BIGSERIAL PRIMARY KEY,
    locador_id BIGINT NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    obra_id BIGINT NOT NULL REFERENCES obra(id) ON DELETE CASCADE,
    estoque INTEGER NOT NULL CHECK (estoque >= 0),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (locador_id, obra_id)
);

CREATE TYPE locacao_status AS ENUM ('ATIVA','FINALIZADA');
CREATE TYPE movimentacao_tipo AS ENUM ('SINAL','RESTANTE');

CREATE TABLE locacao (
    id BIGSERIAL PRIMARY KEY,
    cliente_id BIGINT NOT NULL REFERENCES usuario(id),
    locador_id BIGINT NOT NULL REFERENCES usuario(id),
    obra_id BIGINT NOT NULL REFERENCES obra(id),
    valor_total NUMERIC(12,2) NOT NULL CHECK (valor_total > 0),
    sinal_pago BOOLEAN NOT NULL DEFAULT FALSE,
    restante_pago BOOLEAN NOT NULL DEFAULT FALSE,
    iniciada_em TIMESTAMPTZ NOT NULL DEFAULT now(),
    devolvida_em TIMESTAMPTZ,
    status locacao_status NOT NULL DEFAULT 'ATIVA'
);

CREATE TABLE movimentacao_financeira (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuario(id),
    locacao_id BIGINT NOT NULL REFERENCES locacao(id) ON DELETE CASCADE,
    tipo movimentacao_tipo NOT NULL,
    valor NUMERIC(12,2) NOT NULL CHECK (valor > 0),
    criada_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_catalogo_locador_obra ON catalogo_locador(obra_id);
CREATE INDEX idx_locacao_cliente ON locacao(cliente_id);
CREATE INDEX idx_movimentacao_usuario ON movimentacao_financeira(usuario_id);
