# Case study - Sales and Delivery

# Deep analysis 


select * from cust_dimen;

# check cust_id is eligible to be a primary key

select count(distinct cust_id) as cnt from cust_dimen;

select * from cust_dimen where cust_id is null;

-- Total customers in each province and find which province has more 
-- No of customers ( without limit ) 

-- Output - 337 , ONTARIO

with cte as (
select *, dense_rank() over(order by cnt desc) as rnk 
from (
select province, count(cust_id) as cnt 
from cust_dimen 
group by province) as temp)

select province, cnt from cte where rnk =1;

-- Get the customer name as below format

-- Output - mUHAMMED MACINTYRe

select
concat( 
lower(substr(customer_name,1,1)),
substr(customer_name,2,length(customer_name)-2),
lower(substr(customer_name,-1,1))
) as format_name
from cust_dimen;

# customer name with substr 'ar' in it

select customer_name from cust_dimen 
where customer_name like '%ar%';

# On order_dimen

-- Convert order_date into proper date format

select order_date,
str_to_date(order_date,'%d-%m-%Y') as proper_date
from orders_dimen;

update orders_dimen
set order_date = str_to_date(order_date,'%d-%m-%Y');

alter table orders_dimen modify order_date date;

-- Month with more no of orders ( without limit )

# ord_id is primary key

select * from (
select *, dense_rank() over(order by cnt desc) as rnk from
(select month(order_date) as mnth,
count(ord_id) as cnt 
from orders_dimen
group by mnth) as t1 ) as t2
where rnk =1;


# On shipping_dimen 
# Convert ship_date into proper date format 

select ship_date,
str_to_date(ship_date,'%d-%m-%Y') as proper_date
from shipping_dimen;

update shipping_dimen
set ship_date = str_to_date(ship_date,'%d-%m-%Y');

alter table shipping_dimen modify ship_date date;

# On market fact

-- Find the top 3 customers who placaed more no of orders(without limit)

select * from (
select *, dense_rank() over(order by cnt desc) as rnk 
from (
select cust_id, count(distinct ord_id) as cnt 
from market_fact
group by cust_id) as t ) as t1
where rnk <=3;

-- date diff between order date and ship date

select order_date, ship_date,datediff(ship_date, order_date) 
from orders_dimen o
join shipping_dimen s on  
o.order_id = s.order_id;

-- Customer details where maximum time taken for delivery
select * from (
select *, dense_rank() over(order by diff desc) as rnk
from (
select cust_id, order_date, ship_date,
datediff(ship_date, order_date) as diff
from orders_dimen o
join shipping_dimen s on  
o.order_id = s.order_id
join market_fact m
on o.ord_id = m.ord_id) as t) as tt
where rnk =1;

-- total sales made by each product

select distinct prod_id, 
round(sum(sales) over(partition by prod_id) ,2) as total_sales
from market_fact;

--  total profit made form each product 

select distinct prod_id, 
round(sum(profit) over(partition by prod_id) ,2) as total_profit
from market_fact;

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
having mnth_active > 0 ;

# which ship mode is highly used (without limit)

select * from (
select *, dense_rank() over(order by cnt desc) as rnk
from (
select Ship_Mode, count(distinct m.ship_id) as cnt
from market_fact m
join shipping_dimen s
on m.ship_id = s.ship_id
group by ship_mode) as t) as tt
where rnk =1;


-- total quantity ordered under Technology product category

select product_category, sum(order_quantity) as total_quantity
from market_fact m
join prod_dimen p
on m.prod_id=p.prod_id
where product_category = 'TECHNOLOGY';

# Top 3 orders with more shipping cost( without limit)

select * from (
select ord_id, sum(shipping_cost) as total_cost,
dense_rank() over (order by sum(shipping_cost) desc) as rnk
from market_fact
group by ord_id)
as t where rnk <=3;

# orders with negative profit 

select ord_id, sum(profit) as total_profit
from market_fact
group by ord_id
having total_profit < 0;













