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

create user if not exists 'company.gerente'@'localhost' identified by '12345678';
create user if not exists 'company.empregado'@'localhost' identified by '12345678';
select user from mysql.user;

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

select * from vw_projetosTotalEmpregados;

-- Lista de projetos, departamentos e gerentes 
create view vw_ProjetosDepartamentosGerentes as
	select p.Pname as Projeto, d.Dname as Departamento, concat(e.Fname, ' ',e.Lname) as Gerente from project p
		inner join departament d on d.Dnumber = p.Dnumb
        inner join employee e on d.Dnumber = e.Dnumber where e.Super_ssn = 1 order by 1;

select * from vw_ProjetosDepartamentosGerentes;

-- Quais empregados possuem dependentes e se são gerentes 
create view vw_dependentesGerentes as
	select concat(e.Fname, ' ',e.Lname) as Empregado, 
    case
		when e.Super_ssn = 1 then 'Gerente'
        else 'Empregado'
    end as Cargo,
    case
		when count(de.Dependent_Name) > 1 then 'Sim'
        else 'Não'
    end as Dependentes
    from employee e
		inner join dependent de on e.ssn = de.Essn group by 1, 2 order by 1;
        
select * from vw_dependentesGerentes;

-- Garantindo privilégios para as views
show tables;
/*
vw_departamentosgerentes
vw_dependentesgerentes
vw_nempregadospordepartamentolocalidade
vw_projetosdepartamentosgerentes
vw_projetostotalempregados
*/

grant select on db_company.vw_departamentosgerentes to 'company.gerente'@'localhost';
grant select on db_company.vw_dependentesgerentes to 'company.gerente'@'localhost';
grant select on db_company.vw_nempregadospordepartamentolocalidade to 'company.gerente'@'localhost';
grant select on db_company.vw_projetosdepartamentosgerentes to 'company.gerente'@'localhost';
grant select on db_company.vw_projetosdepartamentosgerentes to 'company.gerente'@'localhost';

grant select on db_company.vw_nempregadospordepartamentolocalidade to 'company.empregado'@'localhost';

-- Parte 2 – Criando gatilhos para cenário de e-commerce 
use db_company;

-- Triggers de remoção: before delete 
create table auditEmployee(
id_auditEmployee int,
newFname varchar(20),
oldFname varchar(20),
newtMinit varchar(20),
oldtMinit varchar(20),
newLname varchar(20),
oldLname varchar(20),
newSsn int,
oldSsn int,
newBdate date,
oldBdate date,
newAdress varchar(255),
oldAdress varchar(255),
newSex enum('M', 'F'),
oldSex enum('M', 'F'),
newSalary decimal(10,2),
oldSalary decimal(10,2),
newSuper_ssn int,
oldSuper_ssn int,
newDno int,
oldDno int,
newDnumber int,
oldDnumber int,
primary key(id_auditEmployee)
);

DELIMITER $$

CREATE TRIGGER trg_audit_employee_before_delete
BEFORE DELETE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO auditEmployee (
        id_auditEmployee,
        newFname, oldFname,
        newtMinit, oldtMinit,
        newLname, oldLname,
        newSsn, oldSsn,
        newBdate, oldBdate,
        newAdress, oldAdress,
        newSex, oldSex,
        newSalary, oldSalary,
        newSuper_ssn, oldSuper_ssn,
        newDno, oldDno,
        newDnumber, oldDnumber
    )
    VALUES (
        NULL,
        NULL, OLD.Fname,
        NULL, OLD.Minit,
        NULL, OLD.Lname,
        NULL, OLD.Ssn,
        NULL, OLD.Bdate,
        NULL, OLD.Adress,
        NULL, OLD.Sex,
        NULL, OLD.Salary,
        NULL, OLD.Super_ssn,
        NULL, OLD.Dno,
        NULL, OLD.Dnumber
    );
END$$

DELIMITER ;


-- Triggers de atualização: before update 
DELIMITER $$

CREATE TRIGGER trg_audit_employee_before_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO auditEmployee (
        id_auditEmployee,
        newFname, oldFname,
        newtMinit, oldtMinit,
        newLname, oldLname,
        newSsn, oldSsn,
        newBdate, oldBdate,
        newAdress, oldAdress,
        newSex, oldSex,
        newSalary, oldSalary,
        newSuper_ssn, oldSuper_ssn,
        newDno, oldDno,
        newDnumber, oldDnumber
    )
    VALUES (
        NULL,
        NEW.Fname, OLD.Fname,
        NEW.Minit, OLD.Minit,
        NEW.Lname, OLD.Lname,
        NEW.Ssn, OLD.Ssn,
        NEW.Bdate, OLD.Bdate,
        NEW.Adress, OLD.Adress,
        NEW.Sex, OLD.Sex,
        NEW.Salary, OLD.Salary,
        NEW.Super_ssn, OLD.Super_ssn,
        NEW.Dno, OLD.Dno,
        NEW.Dnumber, OLD.Dnumber
    );
END$$

DELIMITER ;
 
-- Usuários podem excluir suas contas por algum motivo. Dessa forma, para não perder as informações sobre estes usuários, crie um gatilho before remove 
-- OBS: Não há tabela de usuários no banco do exercício do desafio proposto.

-- Inserção de novos colaboradores e atualização do salário base. 
DELIMITER $$

CREATE TRIGGER trg_employee_before_insert
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    -- Salário base definido pela empresa
    IF NEW.Salary < 3000.00 THEN
        SET NEW.Salary = New.Salary + 1000.00;
    END IF;
END$$

DELIMITER ;


