-- Views, users, grants e triggers no bd_company

/*
Parte 1 – Personalizando acessos com views 

Neste desafio você irá criar visões para os seguintes cenários 

Número de empregados por departamento e localidade 

Lista de departamentos e seus gerentes 

Projetos com maior número de empregados (ex: por ordenação desc) 

Lista de projetos, departamentos e gerentes 

Quais empregados possuem dependentes e se são gerentes 

 

Além disso, serão definidas as permissões de acesso as views de acordo com o tipo de conta de usuários. Lembre-se que as views ficam armazaneadas no banco de dados como uma “tabela”. Assim podemos definir permissão de acesso a este item do banco de dados.  

 

Você poderá criar um usuário gerente que terá acesso as informações de employee e departamento. Contudo, employee não terá acesso as informações relacionadas aos departamentos ou gerentes. 

Um exemplo retirado da aula para criação de usuário e definição de permissão pode ser encontrado abaixo. 

CODE 1:

Obs: O tema de permissão de usuários foi apresentada no curso Explorando Cláusulas de DDL e Esquemas de Banco de Dados no MySQL. 

  

Parte 2 – Criando gatilhos para cenário de e-commerce 

Objetivo: 

Sabemos que a criação de triggers está associadas a ações que podem ser tomadas em momento anterior ou posterior a inserção, ou atualização dos dados. Além disso, em casos de remoção podemos utilizar as triggers. Sendo assim, crie as seguintes triggers para o cenário de e-commerce. 

 

Exemplo de trigger para base.

CODE 2:

Entregável: 

Triggers de remoção: before delete 

Triggers de atualização: before update 

 

Remoção:  

Usuários podem excluir suas contas por algum motivo. Dessa forma, para não perder as informações sobre estes usuários, crie um gatilho before remove 

CODE 3:

Atualização:  

Inserção de novos colaboradores e atualização do salário base. 

CODE 4:

E agora... Finalizou seu desafio ? 

Adicione o link do github com o projeto e submeta para avaliação. 
*/

-- Parte 1 – Personalizando acessos com views 
use db_company;
show tables;

create user 'company.gerente'@localhost identified by '12345678';
create user 'company.empregado'@localhost identified by '12345678';

-- Número de empregados por departamento e localidade 
create view vw_nEmpregadosPorDepartamentoLocalidade as
	select d.Dname, dl.Dlocation, count(e.Ssn) from departament d
		inner join dept_locations dl on d.Dnumber = dl.Dnumber
        inner join employee e on d.Dnumber = e.Dnumber
        group by d.Dname, 2;
        
select * from vw_nEmpregadosPorDepartamentoLocalidade;

-- Lista de departamentos e seus gerentes 
create view vw_departamentosGerentes as
	select d.Dname as Departamento, concat(e.Fname, ' ',e.Lname) as Nome from departament d 
		inner join employee e on d.Dnumber = e.Dnumber 
        where e.Super_ssn = 1 order by d.Dname desc;

select * from vw_departamentosGerentes;

-- Projetos com maior número de empregados (ex: por ordenação desc) 
create view vw_projetosTotalEmpregados as
	select p.Pname as Projeto_Nome, count(e.Ssn) as Total_Empregados from project p, works_on wo, employee e
		where p.Pnumber = wo.Pno and e.ssn = wo.Essn
        group by 1;

-- Lista de projetos, departamentos e gerentes 


-- Quais empregados possuem dependentes e se são gerentes 