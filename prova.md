# DESAFIO N° 0003/2025 SELEÇÃO FULLSTACK JAVA

```
Sistema de Gerenciamento de Aluguel de Livros
```
Você deverá desenvolver um **Sistema de Gerenciamento de Aluguel de Livros** que contempla dois
tipos de usuários: **Locadores** e **Clientes**.
Os **livros (obras) são globais** : quando uma obra é cadastrada (por ISBN) por qualquer locador, ela
passa a ficar disponível para que todos os locadores possam adicioná-la ao seu próprio catálogo com
um controle de estoque (quantidade de exemplares disponíveis para locação).
O cliente pode visualizar informações públicas dos livros. Ao locar um livro de um locador (desde que
haja estoque), ele paga imediatamente um **sinal correspondente a 50% do valor da obra** e passa a
ter acesso às informações completas do livro (que antes não estavam disponíveis para ele).
Na devolução do livro, o cliente paga os **50% restantes** do valor, o estoque daquele locador é
restituído e a locação é finalizada.
O sistema deve permitir cadastro, autenticação, gerenciamento de catálogo, locações, devoluções,
movimentação de saldos e histórico de transações.

**Requisitos:**

```
Stack:
● Backend: Java Spring Boot
● View: Java Server Pages (JSP)
● Banco de dados: PostgreSQL
```
```
Versionamento de banco de dados:
● Utilize o Flyway para versionar todas as alterações no banco, incluindo criação de tabelas,
procedures, functions e demais objetos.
● O versionamento deve estar completo e permitir que qualquer pessoa possa subir o banco do
zero.
```
```
Lógica de negócio:
● Para este desafio, Pelo menos 50% da lógica de negócio deve estar implementada
diretamente no banco de dados , como transações, validações e cálculos.
```

**Autenticação:**

```
● Implementar autenticação de usuários (clientes e locadores) com controle de acesso baseado
em papéis.
```
**Documentação:**

```
● Explique o processo de desenvolvimento, decisões de arquitetura e as principais
funcionalidades.
● Inclua o diagrama relacional do banco de dados.
● Descrever claramente quais regras residem no banco e quais na aplicação.
● Incluir instruções de setup (build, execução, credenciais iniciais, migrações).
● Acrescente qualquer informação que julgar pertinente para compreensão do projeto.
```
**Pontos de avaliação:**

```
● Entendimento da lógica de negócio
● Distribuição adequada da lógica entre aplicação e banco
● Organização e clareza do código e dos scripts de banco
● Uso correto e eficiente do Flyway para versionamento
● Implementação dos conceitos de MVC
● Uso das funcionalidades do banco de dados e as funcionalidades que foram implementadas
nele
● Interface web intuitiva e funcional
```
**Entregáveis:**

```
● Repositório Git com o projeto completo, incluindo scripts Flyway e documentação
● Orientações para rodar o sistema e subir o banco
```
**Data de entrega: 29 /
Contato para dúvidas: guilhermericardo@dunnastecnologia.com.br**

Bom desafio! ☺

