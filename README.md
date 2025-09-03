# 📚 Sistema de Gerenciamento de Biblioteca Universitária

Este repositório documenta o **projeto completo de modelagem e implementação de um banco de dados** para o gerenciamento de uma biblioteca universitária.
O trabalho cobre todo o ciclo de vida de um projeto de banco de dados: desde a **modelagem conceitual** até a **implementação física** e a execução de **consultas SQL**.

O objetivo principal foi criar um **esquema robusto, normalizado e escalável**, capaz de gerenciar com eficiência operações como:

* 📖 controle de acervo (livros e periódicos)
* 👥 cadastro de usuários (alunos e professores)
* 📌 reservas e renovações
* 🔄 empréstimos e devoluções

---

## 📂 Estrutura do Repositório

* **📘 Definições para Modelagem do DER e sripts**

  * `Definições para a Modelagem.pdf`: definição e regras para modelagem do esquema Entidade-Relacionamento (DER).
  * `Definições para o Script.pdf`: definição e regras para modelagem do Scripts.

* **🗄️ DER e Scripts SQL**

  * `Biblioteca - Modelo Descritivo Completo.pdf`: definição do esquema Entidade-Relacionamento (DER).
  * `Biblioteca - Script DDL.sql`: script com os comandos `CREATE TABLE` para construção do banco.
  * `Biblioteca - Script Consultas.sql`: consultas SQL prontas para extração de dados relevantes.

---

## 🏗️ Modelo Entidade-Relacionamento (DER)

O diagrama Entidade-Relacionamento define a estrutura do banco, destacando entidades, atributos e relacionamentos.

*[`Biblioteca - Modelo Descritivo Completo.pdf`](Biblioteca%20-%20Modelo%20Descritivo%20Completo.pdf)*

### Principais Entidades

* **UnidadeAtendimento** → unidades físicas da biblioteca.
* **FuncionarioBiblioteca** → generalização de *Atendentes* e *Bibliotecários*.
* **UsuarioBiblioteca** → generalização de *Alunos* e *Professores*.
* **Titulo** → livros e periódicos do acervo.
* **CopiaTitulo** → cópias físicas de cada título.
* **Transacao** → generalização para *Empréstimo, Devolução, Reserva e Renovação*.

---

## ⚙️ Estrutura do Banco de Dados

O banco foi implementado em **SQL padrão**, garantindo portabilidade entre diferentes SGBDs.

### Destaques da Implementação

* ✅ **Normalização** até a 3ª Forma Normal para evitar redundância.
* 🔑 **Integridade Referencial** com `PRIMARY KEY` e `FOREIGN KEY`.
* ⚠️ **Constraints** (`CHECK`, `NOT NULL`, `UNIQUE`) para consistência dos dados.

Para a estrutura completa, consulte o arquivo [`Biblioteca - Script DDL.sql`](Biblioteca%20-%20Script%20DDL.sql).

---

## 🔍 Exemplos de Consultas SQL

### Consulta 1 — Relação de Títulos do Acervo

Lista ISBN, nome, editora e tipo de todos os títulos, ordenados por tipo e nome.

```sql
SELECT isbn, nome_titulo, editora, tipo_titulo
FROM Tab_Titulos
ORDER BY tipo_titulo, nome_titulo;
```

*(Mais exemplos podem ser encontrados em [`Biblioteca - Script Consultas.sql`](Biblioteca%20-%20Script%20Consultas.sql))*

---

## 🚀 Como Executar

1. Crie o banco em um SGBD de sua escolha (PostgreSQL, MySQL, SQL Server, Oracle).
2. Execute o script [`Biblioteca - Script DDL.sql`](Biblioteca%20-%20Script%20DDL.sql) para gerar as tabelas.
3. (Opcional) Popule o banco com dados de teste.
4. Rode as consultas disponíveis em [`Biblioteca - Script Consultas.sql`](Biblioteca%20-%20Script%20Consultas.sql).

---

## 📌 Status do Projeto

✔️ Concluído: modelagem, DDL e consultas SQL.

---

## 👨‍💻 Autor

Projeto desenvolvido por **Pedro Cardoso**
📎 [LinkedIn](https://www.linkedin.com/in/printf-pedro-c/)

