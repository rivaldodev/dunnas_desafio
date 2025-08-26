INSERT INTO role (id,nome) VALUES (1,'ROLE_LOCADOR');
INSERT INTO role (id,nome) VALUES (2,'ROLE_CLIENTE');

INSERT INTO usuario (id,nome,email,senha,tipo,criado_em,ativo) VALUES
 (1,'Rivaldo Freitas','rivaldo.freitas.106@gmail.com','$2a$10$inUGSYUV7I8CMF38DFc7B.rM1tRMjo29LDC0Ul8xRmXG.uCoaHJxK','LOCADOR',CURRENT_TIMESTAMP,TRUE),
 (2,'Rivs Cliente','rivs@rivs.com.br','$2a$10$DkZ/nfOuKKCti3Hjan8DtO2DAJvHMKVVE.3DiGw0z1EiK8ZU4lQzC','CLIENTE',CURRENT_TIMESTAMP,TRUE);

INSERT INTO usuario_role (usuario_id,role_id) VALUES (1,1),(2,2);
