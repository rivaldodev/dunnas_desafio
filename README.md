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

## Mudanças de interface (27/08/2025)

Organizei a interface para deixar as telas mais consistentes e centralizar onde novas obras são criadas.

O que foi feito
- Centralizei o cadastro de obras na tela de gerenciamento: `/catalogo/obras/gerenciar` (JSP: `WEB-INF/jsp/obras_gerenciar.jsp`). O formulário POST continua nessa rota.
- Removi o botão e o modal duplicados do catálogo do locador (`/locador/catalogo` — `WEB-INF/jsp/catalogo_locador.jsp`) para evitar dois pontos de criação.
- Padronizei as tabelas para usar o CSS global (`src/main/resources/static/css/style.css`): retirei estilos inline e simplifiquei a marcação das tabelas (thead/tbody) em várias JSPs.

Principais arquivos alterados
- `WEB-INF/jsp/obras_gerenciar.jsp`
- `WEB-INF/jsp/catalogo_locador.jsp`
- `WEB-INF/jsp/locacoes_historico_locador.jsp`
- `WEB-INF/jsp/obras.jsp`
- `WEB-INF/jsp/locacoes_disponiveis.jsp`
- `WEB-INF/jsp/locacoes_minhas.jsp`
- `WEB-INF/jsp/extrato.jsp`

Impacto
- Não mudei rotas de API — a alteração é de UX/markup: a tela de criação fica centralizada.
- Para que o header mostre corretamente as opções por perfil, `ObraController.gerenciar(...)` agora envia `tipo`, `saldo` e `username` ao model.

## Diagrama relacional do banco de dados (Código Mermaid e Gráfico)
```mermaid
---
config:
  layout: elk
  theme: redux-dark-color
  look: classic
title: Diagrama relacional do banco de dados
---
erDiagram
	direction LR
	usuario {
		BIGSERIAL id PK ""  
		VARCHAR nome  "VARCHAR(120) NOT NULL"  
		VARCHAR email  "VARCHAR(160) UNIQUE NOT NULL"  
		VARCHAR senha  "VARCHAR(120) NOT NULL"  
		VARCHAR tipo  "VARCHAR(20) LOCADOR ou CLIENTE"  
		NUMERIC saldo  "NUMERIC(12,2) DEFAULT 0"  
		TIMESTAMPTZ criado_em  "DEFAULT now()"  
		BOOLEAN ativo  "DEFAULT TRUE"  
	}
	role {
		BIGSERIAL id PK ""  
		VARCHAR nome  "VARCHAR(40) UNIQUE NOT NULL"  
	}
	usuario_role {
		BIGINT usuario_id FK "REFERENCES usuario(id) ON DELETE CASCADE"  
		BIGINT role_id FK "REFERENCES role(id) ON DELETE CASCADE"  
	}
	obra {
		BIGSERIAL id PK ""  
		VARCHAR isbn  "VARCHAR(20) UNIQUE NOT NULL"  
		VARCHAR titulo  "VARCHAR(200) NOT NULL"  
		VARCHAR autor  "VARCHAR(160)"  
		NUMERIC preco  "NUMERIC(12,2) CHECK > 0"  
		VARCHAR desc_publica  "VARCHAR(500)"  
		VARCHAR desc_privada  "VARCHAR(2000)"  
		BOOLEAN publico  "DEFAULT TRUE"  
		TIMESTAMPTZ criado_em  "DEFAULT now()"  
	}
	catalogo_locador {
		BIGSERIAL id PK ""  
		BIGINT locador_id FK "REFERENCES usuario(id) ON DELETE CASCADE"  
		BIGINT obra_id FK "REFERENCES obra(id) ON DELETE CASCADE"  
		INTEGER estoque  "CHECK >= 0"  
		TIMESTAMPTZ criado_em  "DEFAULT now()"  
	}
	locacao {
		BIGSERIAL id PK ""  
		BIGINT cliente_id FK "REFERENCES usuario(id)"  
		BIGINT locador_id FK "REFERENCES usuario(id)"  
		BIGINT obra_id FK "REFERENCES obra(id)"  
		NUMERIC valor_total  "NUMERIC(12,2) CHECK > 0"  
		BOOLEAN sinal_pago  "DEFAULT FALSE"  
		BOOLEAN restante_pago  "DEFAULT FALSE"  
		VARCHAR status  "VARCHAR(15) DEFAULT 'ATIVA' (ATIVA|FINALIZADA)"  
		TIMESTAMPTZ iniciada_em  "DEFAULT now()"  
		TIMESTAMPTZ devolvida_em  ""  
	}
	movimentacao_financeira {
		BIGSERIAL id PK ""  
		BIGINT usuario_id FK "REFERENCES usuario(id)"  
		BIGINT locacao_id FK "REFERENCES locacao(id) ON DELETE CASCADE"  
		VARCHAR tipo  "SINAL ou RESTANTE"  
		NUMERIC valor  "NUMERIC(12,2) CHECK > 0"  
		TIMESTAMPTZ criada_em  "DEFAULT now()"  
	}
	recarga_saldo {
		BIGSERIAL id PK ""  
		BIGINT usuario_id FK "REFERENCES usuario(id) ON DELETE CASCADE"  
		VARCHAR tipo  "PIX, CARTAO_CREDITO, CARTAO_DEBITO, TRANSFERENCIA"  
		NUMERIC valor  "NUMERIC(12,2) CHECK > 0"  
		TIMESTAMPTZ criada_em  "DEFAULT now()"  
	}

	usuario||--|{usuario_role:"possui"
	role||--|{usuario_role:"é atribuído a"
	usuario||--o{catalogo_locador:"é locador de"
	obra||--o{catalogo_locador:"está em"
	usuario||--o{locacao:"é cliente de"
	usuario||--o{locacao:"é locador de"
	obra||--o{locacao:"é alugada em"
	locacao||--|{movimentacao_financeira:"gera"
	usuario||--o{movimentacao_financeira:"realiza"
	usuario||--o{recarga_saldo:"faz recarga"
```

# Gráfico

[![](https://mermaid.ink/img/pako:eNq9V9tu4kgQ_ZVWv0yQICJAbpZ2JceYGWsckzFmtIosocbukFYaN9u22ZkQPmYf52G_Ij-21ba5mxBmVvsS0t2nquxTp6raMxyIkGIN12o1PwpE9MBGmh8hxMl3kSYaovxJLZNHOqYakjRMv9VCIp9qgeBCZkghnjQUcBLHLPCjhCUckG1GRpKMCZhwEjAREY5CgYYEgqCQopCEIvajLCyVBdqP_CRkkgYJGCDbVes0TolkAs3Uwk9urI8907V0G7EQ3X1GPvYxQvnZV901PukuisSYwh4u1idnjXoFOV0POX3b3oXTMWF8A38B-L5jfembb5jFNHokR4RJ2ESswxXa7hp6u-sikSLDtkzHM1d2Tv8WXtRAMeFhZlhsQJxqo4LaZkfv2x6qryw869bsefrtnXePAsmA4QEdK8sFNhJ_nVRW-Jtu1zZ1B5GETcU6znP7yweZqz9ScPorGWjtJ3S-luTBVhzL8dDiCIJ1VDDX7Jiu6Rhmb3F0wsIK6jrAiG16JjL0HpC6RmThSPku86L233aRPaIYSnIMBSweRtvpPqgpKJ6Ub6nkTVGRNBFyW7u7GppATZVoyPhkGp_R7-saWjgOaRwMJumQs2BD5Of1df-baMmmJCRbT18vEVzud6_kjlVylp-AJISLkRhwEQBevidXhTIKi1-XmNJImRe1f8gF2JsfTehGcSL-TLPqKdLz28_XeMaMer2AiCMICTijUUIPEPKTPB7N2q6cp5BpOUgEZPxdol7oLmYwhgYTMtqQXke3e-YuWEImiGLhAH45DxICfWyjFs9XbfqD7llf9Q_oJPt96ViOblv3eluvlOeWRSyA7JK3O_i6RUingk_Z0mRDA2MxZWPIqRLC4AFoiALK3tfQjurDpZpQMUvMiqNDhbE9P3uKOjUxXfXqpSMz08e7lLFTTuRgOUErJXJEBvlc_q8JPIaJO-uPKqBcT-8ODNdsW153uW6bN9nSc3Wnlwey9P-XqdVcf3mp1V5m60Ne8_FExHHKgKjiflEKev0BtxPJhunrP0A2ydFrXsVsu-_nRoshENLcRPWSvXgo9Ne_4RpY4r3QaO60aItLp_uR-8NvwAhPR2piLkIXhzkTe0oWLEdUljGx30BSwtlzmc2GmAH5QJ5RsafQuIpHkoVYeyA8plU8phIuy7DGMz-73WTfBT7W4F_1VaBs5mA0IdG9EGOsJTIFMynS0ePSSToJSUKLK_9yV9IopNIQaZRg7eryPHOCtRn-hrWzevO00Wxdtq6bzfNm87J-WcXfsda6Pj2_aLSur1rNxtlV46I1r-LnLGz9NPNAQwbXo9v8Cyf70Jn_C9qIGjw?type=png)](https://mermaid.live/edit#pako:eNq9V9tu4kgQ_ZVWv0yQICJAbpZ2JceYGWsckzFmtIosocbukFYaN9u22ZkQPmYf52G_Ij-21ba5mxBmVvsS0t2nquxTp6raMxyIkGIN12o1PwpE9MBGmh8hxMl3kSYaovxJLZNHOqYakjRMv9VCIp9qgeBCZkghnjQUcBLHLPCjhCUckG1GRpKMCZhwEjAREY5CgYYEgqCQopCEIvajLCyVBdqP_CRkkgYJGCDbVes0TolkAs3Uwk9urI8907V0G7EQ3X1GPvYxQvnZV901PukuisSYwh4u1idnjXoFOV0POX3b3oXTMWF8A38B-L5jfembb5jFNHokR4RJ2ESswxXa7hp6u-sikSLDtkzHM1d2Tv8WXtRAMeFhZlhsQJxqo4LaZkfv2x6qryw869bsefrtnXePAsmA4QEdK8sFNhJ_nVRW-Jtu1zZ1B5GETcU6znP7yweZqz9ScPorGWjtJ3S-luTBVhzL8dDiCIJ1VDDX7Jiu6Rhmb3F0wsIK6jrAiG16JjL0HpC6RmThSPku86L233aRPaIYSnIMBSweRtvpPqgpKJ6Ub6nkTVGRNBFyW7u7GppATZVoyPhkGp_R7-saWjgOaRwMJumQs2BD5Of1df-baMmmJCRbT18vEVzud6_kjlVylp-AJISLkRhwEQBevidXhTIKi1-XmNJImRe1f8gF2JsfTehGcSL-TLPqKdLz28_XeMaMer2AiCMICTijUUIPEPKTPB7N2q6cp5BpOUgEZPxdol7oLmYwhgYTMtqQXke3e-YuWEImiGLhAH45DxICfWyjFs9XbfqD7llf9Q_oJPt96ViOblv3eluvlOeWRSyA7JK3O_i6RUingk_Z0mRDA2MxZWPIqRLC4AFoiALK3tfQjurDpZpQMUvMiqNDhbE9P3uKOjUxXfXqpSMz08e7lLFTTuRgOUErJXJEBvlc_q8JPIaJO-uPKqBcT-8ODNdsW153uW6bN9nSc3Wnlwey9P-XqdVcf3mp1V5m60Ne8_FExHHKgKjiflEKev0BtxPJhunrP0A2ydFrXsVsu-_nRoshENLcRPWSvXgo9Ne_4RpY4r3QaO60aItLp_uR-8NvwAhPR2piLkIXhzkTe0oWLEdUljGx30BSwtlzmc2GmAH5QJ5RsafQuIpHkoVYeyA8plU8phIuy7DGMz-73WTfBT7W4F_1VaBs5mA0IdG9EGOsJTIFMynS0ePSSToJSUKLK_9yV9IopNIQaZRg7eryPHOCtRn-hrWzevO00Wxdtq6bzfNm87J-WcXfsda6Pj2_aLSur1rNxtlV46I1r-LnLGz9NPNAQwbXo9v8Cyf70Jn_C9qIGjw)
