INSERT INTO role (id,nome) VALUES (1,'ROLE_ADMIN');
INSERT INTO usuario (id,nome,email,senha,tipo,criado_em,ativo) VALUES (1,'Admin','admin@local','$2a$10$8P9Ca8nHgdGXNqBJ38qdu.NcB0uKmqmLP1tTGTbtV85Ewy0NlH1X.','LOCADOR',CURRENT_TIMESTAMP,TRUE);
INSERT INTO usuario_role (usuario_id,role_id) VALUES (1,1);
