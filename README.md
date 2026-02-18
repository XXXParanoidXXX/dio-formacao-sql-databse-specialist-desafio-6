
⸻

📊 Projeto: Views, Usuários, Grants e Triggers no MySQL (db_company)

📌 Descrição

Este projeto tem como objetivo demonstrar o uso prático de views, controle de acesso com usuários e privilégios (GRANT) e triggers no MySQL, utilizando o banco de dados db_company.
O foco está na segurança da informação, organização de consultas e auditoria de dados sensíveis.

⸻

🧩 Parte 1 – Views e Controle de Acesso

Foram criadas views para atender a diferentes necessidades de consulta, abstraindo tabelas sensíveis e facilitando o controle de permissões:

Views implementadas
	•	Número de empregados por departamento e localidade
	•	Lista de departamentos e seus gerentes
	•	Projetos com maior número de empregados
	•	Lista de projetos, departamentos e gerentes
	•	Empregados com dependentes e indicação se são gerentes

Usuários e permissões
	•	company.gerente: acesso completo às views gerenciais
	•	company.empregado: acesso restrito a informações agregadas

As permissões foram concedidas diretamente às views, reforçando boas práticas de segurança e encapsulamento dos dados.

⸻

🧩 Parte 2 – Triggers e Auditoria

Foram implementadas triggers para garantir rastreabilidade e regras de negócio no banco de dados.

Triggers criadas
	•	BEFORE DELETE
	•	Registra os dados antigos do colaborador na tabela auditEmployee antes da exclusão.
	•	BEFORE UPDATE
	•	Armazena valores antigos e novos em atualizações, permitindo auditoria completa.
	•	BEFORE INSERT
	•	Aplica regra de negócio para salário base, ajustando automaticamente valores abaixo do mínimo definido.

Auditoria
	•	Tabela auditEmployee armazena histórico de alterações e exclusões da tabela employee.

⸻

🛠️ Tecnologias Utilizadas
	•	MySQL
	•	SQL (DDL, DML, DCL)
	•	Triggers
	•	Views
	•	Controle de usuários e privilégios

⸻

🎯 Objetivo Acadêmico

Projeto desenvolvido como desafio prático para consolidar conhecimentos em:
	•	Segurança em banco de dados
	•	Auditoria de dados
	•	Controle de acesso
	•	Programação em SQL no MySQL

⸻

📂 Estrutura do Projeto
	•	Criação de usuários
	•	Definição de views
	•	Aplicação de privilégios (GRANT)
	•	Criação de triggers
	•	Implementação de auditoria
