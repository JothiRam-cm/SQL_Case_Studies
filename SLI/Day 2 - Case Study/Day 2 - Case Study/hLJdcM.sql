create table table_1
(supplier_id int ,
Amount float);

insert into table_1 values
(1,200),(2,100),(3,300),(4,100),(5,300);

select * from table_1;

# Percentage of contribution
select  supplier_id,amount,(amount/(select sum(amount) from table_1))*100 
as percent_contibution from table_1;

create table table_2
(supplier_id int ,
Amount float);

insert into table_2 values
(1,200),(1,100),(3,300),(3,100),(5,300);

select * from table_2;

# Highest amount for each supplier
select supplier_id, max(amount) as amxi from table_2 group by supplier_id;

select * from(
select supplier_id,amount, max(amount) 
over(partition by supplier_id) as maximum from table_2) as t
where amount = maximum;


with cte as (
select supplier_id,amount, max(amount) 
over(partition by supplier_id) as maximum from table_2) 

select * from cte where amount = maximum;

with cte1 as (
select supplier_id,amount, rank() 
over(partition by supplier_id order by amount desc) as rnk from table_2)

select * from cte1 where rnk=1;

# Employee details who gets salary > manager's salary

use hr;

select * from employees;

# using joins

select emp.employee_id, emp.salary as emplo
from employees emp 
join employees mag 
on emp.manager_id = mag.employee_id
where emp.salary > mag.salary;

select employee_id, salary from 
employees as emp
where salary > ( select salary 
from employees as mag where emp.manager_id = mag.employee_id);

create table table_3
(order_id int ,
customer_id int,
product_id int,
order_date date);

insert into table_3 values
(1,101,201,'2025-06-01'),
(1,101,203,'2025-06-05'),
(1,101,201,'2025-06-10'),
(1,102,203,'2025-06-02'),
(1,102,203,'2025-06-07');

select * from table_3;

# Customer who orders same product consecutively twice
with temp as (
select customer_id, product_id as current_order ,
lag(product_id) over ( partition by customer_id)  as previous_order
from table_3)

select * from temp where current_order = previous_order;

create table table_4
(emp_id int ,
start_date date,
end_date date);

insert into table_4 values
(1,'2025-01-01','2025-06-30'),
(2,'2025-03-01','2025-08-31'),
(3,'2025-09-01','2025-12-31');

select * from table_4;

select * from (
select emp_id, lag(emp_id) over (order by start_date) as previous_emp,
start_date, lag(end_date) over(order by start_date) as previous_end_date 
from table_4) as t
where start_date<= previous_end_date;

create table table_5
(order_id int ,
product_id int,
sales_date date,
quantity int);

insert into table_5 values
(1,101,'2025-02-01',300),
(2,101,'2025-02-05',400),
(3,101,'2025-02-10',500),
(4,102,'2025-02-03',600),
(5,102,'2025-02-05',450);

select * from table_5;

# date when the total quantitu]y exceed 1000 units 
select * from 
(select *, 
sum(quantity) over(partition by product_id order by sales_date) as cum_total
from table_5) as t
where cum_total>1000;

create table table_6
(order_id int ,
customer_id int,
order_date date);

insert into table_6 values
(1,101,'2025-01-01'),
(2,101,'2025-01-03'),
(3,101,'2025-01-20'),
(4,102,'2025-02-10'),
(5,102,'2025-02-13'),
(6,102,'2025-02-17'),
(7,103,'2025-03-01'),
(8,103,'2025-03-12');

select * from table_6;

select *,datediff(next_order, order_date) as diff from (
select *, 
lead(order_date) over(partition by customer_id order by order_date) as next_order
from table_6) as t
where datediff(next_order, order_date)<=5;

use hr;

# Second highest paid employees in each department using windows function

select * from(
select employee_id,department_id,
dense_rank() over(partition by department_id order by salary desc) as rnk 
from employees) as temp
where rnk=2;

# detail of the department who avg salary of employees is greater than 10000


select e.department_id, d.department_name, avg(salary) as avg_sal 
from employees e join departments d 
on e.department_id = d.department_id  
group by e.department_id
having avg_sal > 10000;

