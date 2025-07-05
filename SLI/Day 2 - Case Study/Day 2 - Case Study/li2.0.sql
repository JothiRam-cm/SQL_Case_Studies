-- Question 1: Find the top 3 customers who have the maximum number of orders

select * from (select *, dense_rank()over(order by cnt desc) rnk from (select Cust_id , count(distinct Ord_id) as cnt from market_fact 
group by Cust_id)t1)t2 where rnk between 1 and 3; 

-- Question 2: Create a new column DaysTakenForDelivery that contains the date difference between Order_Date and Ship_Date.
alter table orders_dimen modify Order_Date date;

create table dif_date  
(
Ship_Date date,
Order_Date date,
diff_date int
);

drop table dif_date;

insert into dif_date (Ship_Date) 
select Ship_Date from shipping_dimen;

insert into dif_date (Order_Date) 
select Order_Date from orders_dimen;


update dif_date set diff_date = datediff(Ship_Date,Order_Date);

select * from dif_date;

create table days_taken as 
(select o.Order_Date, s.Ship_Date,datediff(s.Ship_Date,o.Order_Date) as days_taken from orders_dimen o join  shipping_dimen s 
on o.order_id = s.order_id);

alter table orders_dimen add column DaysTakenForDelivery int;
alter table shipping_dimen add column DaysTakenForDelivery int;

insert into shipping_dimen (DaysTakenForDelivery)
select days_taken from days_taken ;

insert into orders_dimen (DaysTakenForDelivery)
select days_taken from days_taken;

select DaysTakenForDelivery from shipping_dimen where DaysTakenForDelivery is not null;
select DaysTakenForDelivery from shipping_dimen;

select * from orders_dimen where DaysTakenForDelivery is not null;

alter table orders_dimen drop column DaysTakenForDelivery;

alter table shipping_dimen drop column DaysTakenForDelivery;


/*

Question 3: Find the customer whose order took the maximum time to get delivered.

Question 4: Retrieve total sales made by each product from the data (use Windows function)

Question 5: Retrieve the total profit made from each product from the data (use Windows function)

Question 6: Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

*/

-- 3.Find the customer whose order took the maximum time to get delivered.

select * from (select *,dense_rank()over(order by days_taken desc) as rnk from (select cust_id,o.Order_Date, s.Ship_Date,datediff(s.Ship_Date,o.Order_Date) as days_taken from orders_dimen o join  shipping_dimen s 
on o.order_id = s.order_id join market_fact m on m.ord_id=o.ord_id)t)t2 where rnk =1;


desc market_fact;
-- 4.Retrieve total sales made by each product from the data (use Windows function)
select distinct Prod_id , sum(Order_Quantity)over(partition by prod_id) as total_sales from market_fact;

-- 5.Retrieve the total profit made from each product from the data (use Windows function) 
select distinct Prod_id , sum(Profit)over(partition by prod_id) as total_sales from market_fact;

-- 6. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

select cust_id from (select cust_id  from (select distinct cust_id, month(order_date) mnth  from orders_dimen o join market_fact m on o.ord_id = m.ord_id 
where year(o.order_date) = 2011)t1 where mnth =1)t2 
where cust_id =any 
(select distinct cust_id   from orders_dimen o join market_fact m on o.ord_id = m.ord_id 
where year(o.order_date) = 2011 and month(order_date)<>1 ); 

-- customer who placed orders in Jan 2011 and came 
-- back atleast once in any month of year 2011


select cust_id, 
count(distinct month(order_date)) as mnth_active
from  market_fact m
join orders_dimen o
on m.ord_id = o.ord_id
where cust_id in 
(
select distinct cust_id
from market_fact m
join orders_dimen o
on m.ord_id = o.ord_id
where month(order_date) = 1 and year(ordeR_date) = 2011)
and year(ordeR_date) = 2011 and month(order_date) >1
group by cust_id 
having mnth_active = 11;


