DELETE FROM usuario_role ur USING role r WHERE ur.role_id = r.id AND r.nome = 'ROLE_ADMIN';
DELETE FROM role WHERE nome = 'ROLE_ADMIN';
UPDATE usuario SET email='rivaldo.freitas.106@gmail.com', senha='$2a$10$inUGSYUV7I8CMF38DFc7B.rM1tRMjo29LDC0Ul8xRmXG.uCoaHJxK', nome='Rivaldo Freitas' WHERE email='admin@local';
UPDATE usuario SET email='rivs@rivs.com.br', senha='$2a$10$DkZ/nfOuKKCti3Hjan8DtO2DAJvHMKVVE.3DiGw0z1EiK8ZU4lQzC', nome='Rivs Cliente' WHERE email='cliente@local';
DELETE FROM usuario_role WHERE usuario_id IN (SELECT id FROM usuario WHERE email IN ('rivaldo.freitas.106@gmail.com','rivs@rivs.com.br'));
INSERT INTO usuario_role (usuario_id, role_id)
SELECT u.id, r.id FROM usuario u CROSS JOIN role r 
WHERE (u.email='rivaldo.freitas.106@gmail.com' AND r.nome='ROLE_LOCADOR')
   OR (u.email='rivs@rivs.com.br' AND r.nome='ROLE_CLIENTE');
