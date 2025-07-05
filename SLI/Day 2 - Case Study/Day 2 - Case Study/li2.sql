 create database sales_delivery;
 
 use sales_delivery;
 
 show tables;
 
 /*
	Tables_in_sales_delivery
		shipping_dimen
		prod_dimen
		orders_dimen
		market_fact
		cust_dimen
 */
 
 select count(cust_id) from cust_dimen ;
 select distinct cust_id from cust_dimen where cust_id is not null;
 
 select last_value(cust_id)over() last_val from cust_dimen limit 1;
 
 select province,no_cust from 
 (select * , max(no_cust)over() max_province 
 from (select distinct province,count(cust_id)over(partition by province) as no_cust from cust_dimen) t1 )t2 
 where no_cust = max_province;
 
 select * from cust_dimen;
 
 SELECT 
    CONCAT_WS('',
            LOWER(SUBSTR(Customer_Name, 1, 1)),
            SUBSTR(Customer_Name,
                2,
                LENGTH(Customer_Name) - 2),
            LOWER(SUBSTR(Customer_Name,
                        LENGTH(Customer_Name),
                        1))) as cust_name
FROM
    cust_dimen;


SELECT 
    Customer_Name
FROM
    cust_dimen
WHERE
    Customer_Name LIKE '%ar%';


select * from orders_dimen;

set SQL_SAFE_UPDATES =0; 
update orders_dimen set Order_Date = str_to_date(Order_Date,'%d-%m-%Y');
alter table orders_dimen modify Order_Date date;

desc orders_dimen;
select Order_Date from orders_dimen limit 5; 

with t2 as(
select *,dense_rank()over(order by cnt desc) as rnk from (select month(Order_Date) mn , count(ord_id) cnt from orders_dimen  group by mn) t1
) 
select * from t2 where rnk =1
; 

select count(ord_id) from orders_dimen;

select Ship_Date from shipping_dimen;
update shipping_dimen set Ship_Date = str_to_date(Ship_Date,'%d-%m-%Y');
alter table shipping_dimen modify Ship_Date date;


select * from market_fact;

select * from (select *, dense_rank()over(order by cnt desc) rnk from (select Cust_id , count(distinct Ord_id) as cnt from market_fact 
group by Cust_id)t1)t2 where rnk between 1 and 3; 

-- REGULAR AIR	5607

select * from 
(select *, dense_rank()over(order by cnt desc) rnk from 
(select ship_mode,count(ship_id) as cnt from shipping_dimen group by ship_mode order by cnt desc )t)t1 where rnk =1;

-- find the total quantity of the products under technology category
select * from prod_dimen; 

select distinct m.prod_id,sum(Order_Quantity)over(partition by prod_id) as total_qunt,sum(Order_Quantity)over(partition by Product_Category) as total from prod_dimen p join market_fact m on p.Prod_id=m.Prod_id 
where  Product_Category = 'TECHNOLOGY';


select * from market_fact;

select * from (select * , dense_rank()over(order by total_ship_cost desc) rnk 
from (select distinct Ord_id,sum(Shipping_Cost) over (partition by Ord_id) as total_ship_cost 
from market_fact )t1 )t2 
where rnk between 1 and 3;


show tables;

 /*
 Tables_in_sales_delivery
	cust_dimen
	days_taken
	dif_date
	market_fact
	orders_dimen
	prod_dimen
	shipping_dimen
 */

select 
distinct ord_id,
sum(profit) su
from market_fact 
group by ord_id
having su <0 ;