create schema practice
show databases
use practice
create table employee (
emp_id int primary key,
first_name varchar(40),
last_name varchar(40),
birth_day Date,
sex varchar(1),
salary int,
super_id int,
branch_id int)

create table branch(
branch_id int primary key,
branch_name varchar(40),
mgr_id int,
mgr_start_date Date,
foreign key(mgr_id)references employee(emp_id)on delete set null) 

alter table employee 
add foreign key(branch_id)
references branch(branch_id)
on delete set null
 
alter table employee
add foreign key(super_id)
references employee(emp_id)
on delete set null;

create table client(
client_id int primary key,
client_name varchar(40),
branch_id int,
foreign key(branch_id) references branch(branch_id)on delete set null);

create table works_with (
emp_id int,
client_id int,
total_sales int,
primary key(emp_id,client_id),
foreign key(emp_id)references employee(emp_id)on delete cascade,
foreign key(client_id)references client(client_id)on delete cascade);
 
 create table branch_supplier(
 branch_id int,
 supplier_name varchar(40),
 supplier_type varchar(40),
 primary key(branch_id,supplier_name),
 foreign key(branch_id)references branch(branch_id) on delete cascade);

#corporate
insert into employee values(100,'David','wallace','1967-11-17','M',25000,null,null);

insert into branch values (1,'corporate',100,'2006-02-09');
update employee
set branch_id=1
where emp_id=100;
insert into employee values(101,'jan','levision','1961-05-11','f',110000,100,1);

#scraton
insert into employee values(102,'Michael','Scott','1964-03-15','M',75000,100,null);

insert into branch values(2,'Scarton',102,'1992-04-06');

update employee set branch_id=2 where emp_id=102;

insert into employee values(103,'Angela','Martin','1971-06-25','F',63000,102,2);
insert into employee values(104,'Kelly','Kappor','1980-02-05','F',55000,102,2);
insert into employee values(105,'Stanely','Hudson','1958-02-19','M',69000,102,2);

#Stamford
Insert into employee values(106,'Josh','Porter','1969-09-05','M',78000,100,Null);

insert into branch values(3,'Stampord','106','1982-02-13');
update employee set branch_id=3 where emp_id=106;

insert into employee values(107,'Andy','Bernard','1973-07-22','M',65000,106,3);
insert into employee values(108,'Jim','Halpert','1978-10-01','M',71000,106,3);

#Branch supplier
insert into branch_supplier values(2,'Hammer Mill','paper');
insert into branch_supplier values(2,'Uni ball','writing Utensils');
insert into branch_supplier values(3,'Patriot paper','paper');
insert into branch_supplier values(2,'J.T. Forms & labels','Custom forms');
insert into branch_supplier values(3,'Uni-ball','Writing Utensils');
insert into branch_supplier values(3,'Hammer Mill','paper');
insert into branch_supplier values(3,'Stamford labels','Custom forms');

#client 
insert into client values(400,'Dunmore highschool',2);
insert into client values(401,'Lackawana country',2);
insert into client values(402,'Fedex',3);
insert into client values(403,'John Daily Law,llc',3);
insert into client values(404,'Scrantom whitepages',2);
insert into client values(405,'Times newspaper',3);
insert into client values(406,'Fedex',2);

#works with
insert works_with values(105,400,55000);
insert works_with values(102,401,267000);
insert works_with values(108,402,22500);
insert works_with values(107,403,5000);
insert works_with values(108,403,12000);
insert works_with values(105,404,33000);
insert works_with values(107,405,26000);
insert works_with values(102,406,15000);
insert works_with values(105,406,13000);

#Basics queries
-- Find all employees
select *from employee

-- find all clients
select *from client

-- find all employees ordered by salary
select *from employee order by salary
select *from employee order by salary desc

-- find all employees order by sex then name
select *from employee order by sex,first_name and last_name

-- find the first 5 employees in the table
select *from employee limit 5;

-- find the first and last name of all employees
select first_name,employee.last_name from employee;

-- find the forename and surnames names of all employees
select first_name as forename,last_name as surnames from employee;

-- find out all different genders
select distinct sex from employee;

-- find all male employees
select *from employee where sex='M';

-- find all employees at branch 2
select *from employee where branch_id=2;

-- find all employees who are female & born after 1969 or who make over 80000
select *from employee where (sex='F' and birth_day>='1970-01-01') or salary>80000;

-- find all employees born between 1970 and 1975
select *from employee where birth_day between '1970-01-01' and '1975-01-01';

-- find all employees named Jim,Michael,Johnny or David
select *from employee where first_name in('Jim','Michael','Johny','David');

#Functions
-- find the number of employees
select count(super_id) from employee;
 
-- find the average of all employee's salaries
select avg(salary) from employee;

-- find the sum of all employee's salaries
select sum(salary) from employee;

-- find out how many male and female are there
select count(sex),sex from employee group by sex;

-- find out the total sales of each salesman
select sum(total_sales),client_id from works_with group by client_id;

-- find the total amount of money spent by each client
select sum(total_sales),client_id from works_with group by client_id;

#wild cards
-- find any client's who are an llc
select *from client where client_name like '%LLC';

-- find any branch suppliers who are in the label business
select *from branch_supplier where supplier_name like '%labels';

-- find any employee born on the 10th day of the month
select *from employee where birth_day like '____10%';

-- find any clients who are schools 
select *from client where client_name like '%Highschool%';	

#union
-- find a list of employee and branch names
select employee.first_name as employee_branch_names from employee 
union
 select branch.branch_name from branch;

-- find a list of all clients & branch supplier's names
select client.client_name as non_employee_entities,client.branch_id as branch_id from client 
union
select branch_supplier.supplier_name,branch_supplier.branch_id from branch_supplier;

#joins
-- add the extra branch
insert into branch values(4,'Buffalo',null,null);

select employee.emp_id,employee.first_name,branch.branch_name from employee
join branch -- left join,right join
on employee.emp_id=branch.mgr_id;

-- find names of all employees who have sold over 50,000
select employee.first_name,employee.last_name from employee
where employee.emp_id in (select works_with.emp_id from works_with 
where works_with.total_sales>50000);

-- find all clients who are handles by the branch that michael scott manages
-- assume you know michael's id
select client.client_id,client.client_name from client
where client.branch_id =(select branch.branch_id from branch where branch.mgr_id=102);

-- find all clients who are handles by the branch that micheal scott manages
-- assume you dont't know michael's id
select client.client_id,client.client_name from client 
where client.branch_id=(select branch.branch_id from branch where branch.mgr_id
=(select employee.emp_id from employee where employee.first_name='Michael' and employee.last_name='Scott' limit 1));
