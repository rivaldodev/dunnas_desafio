# dunnas_desafio
Sistema de Gerenciamento de Aluguel de Livros – Desafio Técnico

## Sumário
- [Visão Geral](#visão-geral)
- [Stack](#stack)
- [Setup Rápido](#setup-rápido)
- [Credenciais Iniciais](#credenciais-iniciais)
- [Fluxo de Negócio](#fluxo-de-negócio)
- [Distribuição da Lógica (Banco x Aplicação)](#distribuição-da-lógica-banco-x-aplicação)
- [Migrações Flyway](#migrações-flyway)
- [Campos Públicos vs Privados da Obra](#campos-públicos-vs-privados-da-obra)
- [Regras Financeiras Automatizadas](#regras-financeiras-automatizadas)
- [Endpoints Principais](#endpoints-principais)
- [Diagramas / Modelo](#diagramas--modelo)
- [Próximos Passos / Melhorias](#próximos-passos--melhorias)

## Visão Geral
Dois perfis: LOCADOR e CLIENTE. Obras são globais (por ISBN). Locadores adicionam obras ao próprio catálogo com estoque. Cliente inicia locação, paga automaticamente 50% (sinal), obtém acesso à descrição privada e ao finalizar (devolução) paga os 50% restantes; estoque é restituído. Saldo do cliente é debitado/creditado via triggers. Recargas alimentam saldo.

## Stack
- Java 17 / Spring Boot 3.3.x
- JSP (JSTL) / Tomcat embutido
- PostgreSQL 16 + Flyway
- Maven Wrapper

## Setup Rápido
Pré-requisitos: Java 17+, Docker (opcional para banco) ou PostgreSQL local.

1. Exportar variáveis (PowerShell):
```
$env:DB_URL="jdbc:postgresql://localhost:5544/dunnas_rental";
$env:DB_USER="default"; $env:DB_PASSWORD="default"
```
2. Subir banco (exemplo docker):
```
docker run --name dunnas-pg -e POSTGRES_USER=default -e POSTGRES_PASSWORD=default -e POSTGRES_DB=dunnas_rental -p 5544:5432 -d postgres:16
```
3. Migrar e rodar:
```
./mvnw -DskipTests flyway:migrate
./mvnw -DskipTests spring-boot:run
```

## Credenciais Iniciais
Usuários seed criados nas migrações iniciais (ajuste conforme necessário):
- Locador: (ver dados inseridos na V1/V2) – senha já codificada em BCrypt.
- Cliente: idem.

## Fluxo de Negócio
1. Locador cadastra obra (global). Outro locador pode adicioná-la ao seu catálogo.
2. Cliente vê lista pública (dados básicos + descrição pública).
3. Cliente inicia locação => trigger gera movimentação do SINAL (50%) debitando saldo e marcando sinal_pago.
4. Cliente obtém acesso à descrição privada enquanto a locação estiver ATIVA.
5. Finalização: trigger cria RESTANTE (50%) se necessário, debita saldo, devolve estoque, marca locação FINALIZADA e revoga acesso privado.
6. Recarga saldo: insere linha recarga_saldo; trigger credita saldo e gera extrato consistente.

## Distribuição da Lógica (Banco x Aplicação)
Banco (PL/pgSQL / constraints / triggers):
- Validação de 50% (sinal/restante) e criação automática das movimentações.
- Débito automático do saldo ao inserir movimentação financeira (sinal/restante).
- Crédito automático em recarga (after insert) e atualização de saldo.
- Controle de estoque: decremento ao iniciar locação; restituição ao finalizar.
- Garantia de consistência de status e flags sinal_pago / restante_pago.

Aplicação (Spring MVC / Controllers / Views):
- Autenticação e autorização (Spring Security).
- Exibição condicional de descrição privada.
- Cache volátil de permissão (invalidate on finalize) para reduzir queries repetitivas.
- Validações de formulário (Bean Validation) complementares.
- Navegação JSP e mensagens para UX.

> Aproximadamente >50% da lógica crítica (financeiro, estoque, integridade das locações) está no banco.

## Migrações Flyway
- V1..V5: Base, ajustes usuários/roles, esquema locação/catalogo, regras iniciais.
- V6..V10: Automação pagamentos 50%, saldo, recarga, conversão enum->varchar, ajustes finalize.
- V11: Campos de descrição pública e privada de obra.
Reparo de checksum foi efetuado via flyway:repair quando houve ajuste em script aplicado (documentado no histórico de commits).

## Campos Públicos vs Privados da Obra
Migração V11 introduziu:
- desc_publica (descricaoPublica)
- desc_privada (descricaoPrivada)

Visibilidade:
- Listagem `/catalogo/obras`: mostra somente descricaoPublica e marcador de material privado.
- Página `/obras/{id}/privada`: acessível para LOCADOR ou CLIENTE com locação ATIVA daquela obra.
- Após finalização da locação, o cache é revogado e o cliente perde acesso à descrição privada.

Implementação:
- Controller verifica locação ATIVA (query) e usa `PrivateDescriptionPermissionCache` (ConcurrentHashMap) para reuso durante o período ativo; revoga em finalize.

## Regras Financeiras Automatizadas
- Trigger AFTER INSERT locação: gera SINAL (50%) se não existir, debita saldo e marca sinal_pago.
- Trigger AFTER UPDATE locação (finalização): gera RESTANTE (50%) se pendente, debita saldo, devolve estoque.
- Trigger BEFORE INSERT movimentacao_financeira: valida saldo suficiente e lógica de 50% para sinal/restante.
- Trigger AFTER INSERT recarga_saldo: credita saldo.

## Endpoints Principais
- GET `/catalogo/obras` – listagem global com descrição pública.
- GET `/catalogo/obras/gerenciar` – gestão (LOCADOR).
- POST `/catalogo/obras/gerenciar` – cadastra obra.
- GET `/locacoes/disponiveis` – catálogo locável filtrado por estoque.
- POST `/locacoes` – inicia locação.
- GET `/locacoes/minhas` – locações ativas do cliente.
- POST `/locacoes/finalizar` – finaliza locação.
- GET `/locacoes/extrato` – extrato (movimentações + recargas).
- POST `/locacoes/recarga` – recarga de saldo.
- GET `/obras/{id}/privada` – descrição privada.

## Diagramas / Modelo
Simplificado (principais campos):
```
usuario(id, email, senha, tipo, saldo)
obra(id, isbn, titulo, autor, preco, desc_publica, desc_privada)
catalogo_locador(id, locador_id, obra_id, estoque)
locacao(id, cliente_id, locador_id, obra_id, valor_total, sinal_pago, restante_pago, status)
movimentacao_financeira(id, usuario_id, locacao_id, tipo, valor)
recarga_saldo(id, usuario_id, valor, tipo)
```

## Próximos Passos / Melhorias
- Testes automatizados para regras de acesso privado e triggers (Testcontainers).
- Paginação / busca avançada de obras.
- Otimizar N+1 com fetch joins onde necessário.
- Limite de tentativas de recarga e auditoria adicional.

---
Documentação gerada conforme requisitos: explicação de arquitetura, regras no banco vs aplicação, setup e fluxos principais.
