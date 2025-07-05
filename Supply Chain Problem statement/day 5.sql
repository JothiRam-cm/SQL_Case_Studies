## extra 

use supply_chain ;

# uni-table analyze

select * from customer;
select * from product;
select * from orders; 
select * from orderitem;
select * from supplier;

# 2.Find the country-wise count of customers. 
select 
country, count(id) as no_of_customer
from customer 
group by country
order by no_of_customer desc limit 1;

# inference 
   # USA has the high customer
   # Ireland , Norway, Poland has 1 customer

# city wise 
select 
city, count(id) as no_of_customer
from customer 
group by city
order by no_of_customer desc limit 1;

# inference 
# no cities with more than 10 customer and max no of customer is in londan that is 6 

# first letter of first name to lower and first letter last name lower
select lower(substr(firstname,1,1)) flfn,lower(substr(lastname,1,1)) flln 
from customer;

select concat(lower(substr(firstname,1,1)),substr(firstname,2)) flfn,concat(lower(substr(lastname,1,1)),substr(firstname,2)) flln 
from customer;

# customer with high orders - order table 

select customerid , count(id) no_orders
from orders
group by customerid
order by no_orders limit 1;

# Inferencs 
  # customer with id 71 has high orders with 31 orders 
  # customer with id 13 has the lowest orders  with 1 order

# which year has least number of orders palced

select  year(orderdate) , count(id) no_orders
from orders
group by year(orderdate)
order by no_orders desc limit 1;

# inference 
  # year 2012 has the least orders with 152
  # year 2013 has the least orders with 408

#  top 5 cust with more total revenue

select
customerid,
sum(totalamount) as revenue
from orders
group by customerid
order by revenue  limit 5;

/* 
 1.custome with id 13 has least revenue 100.80 
 2. custome with id 63 has hig revenue 117483.39
   
   ########## top 5 with high revenue############
				custid	revenue
                63		117483.39
				71		115673.39
				20		113236.68
				37		57317.39
				65		52245.90
	############################################
    
    ########## top 5 with low revenue ############
				custid	revenue
                13	    100.80
				43		357.00
				42		522.50
				53		649.00
				29		836.70
	############################################
*/

select 
customerid,count(id) frequent_orders
from orders
group by customerid
order by frequent_orders  limit 10;

# inference 
 # customers with these id's (71 20 63 37 24 5 65 35 9 44) orders frequently
 # customers with these id's (13,43,33,78,82,53,26,16,8,42) orders occationaly

select  month(orderdate) mounth , count(id) no_orders, sum(totalamount) revenue
from orders
group by month(orderdate)
order by revenue desc, no_orders ;

# inferemce 
  # mont 4 has high order with 105 orders and with low revenue 190329.95


# find which quartaer of the month has high revenue 

select quarter(orderdate) as qr, sum(totalamount) as revenue
from orders where year(orderdate) = 2013
group by qr order by revenue desc limit 1;

# orderitem table
# top 3 mosst frequently oreder products 

SELECT 
    productid, COUNT(orderid) AS no_of_order
FROM
    orderitem
GROUP BY productid
ORDER BY no_of_order
LIMIT 5;

# inference 
 # the product with these id's (59,31,60,24,56) are ordered frequently (in demand)
 # the product with these id's (59,31,60,24,56) are ordered frequently (in demand)

# which order have been place with more no of products
select 
OrderId,
count(OrderId) as cnt
from orderitem
group by OrderId
order by cnt desc limit 1;

# inference 
  # order with orderid 830 has high products with 25
  # order with orderid id 19 has low products with 1
  
# understanding product table 

# unique prodects of each supplier

SELECT 
    supplierid,count(id) cnt
FROM
    product
GROUP BY SupplierId
order by cnt desc;

#########################################################################################################################################
# 3.Display the products that are not discontinued. 

SELECT 
    *
FROM
    product
WHERE
    IsDiscontinued = 0;

# 70 products are not discontinued
############################################################################################
# 4.Display the list of companies along with the product name that they are supplying. 

SELECT 
    s.CompanyName, p.productname
FROM
    supplier s
        JOIN
    product p ON s.id = p.supplierid; 
    
###########################################################################################
# 5.Display customer information about who stays in 'Mexico'

SELECT 
    *
FROM
    customer
WHERE
    country = 'Mexico';
#############################################################################################   
#6.Display the costliest item that is ordered by the customer

select productid,unitprice
from orderitem order by UnitPrice desc limit 1;

##############################################################################################
-- 7.	Display supplier ID who owns the highest number of products.
select SupplierId, count(id) as cnt
from product 
group by SupplierId
order by cnt desc limit 2;

#################################################################################################
-- 8.	Display month-wise and year-wise counts of the orders placed.
select
year(orderdate) as yr,month(orderdate) mnth,count(id) as cnt
from orders 
group by year(orderdate), month(orderdate);

####################################################################################################
-- 9.	Which country has the maximum number of suppliers?
select country,count(id) cnt
from supplier
group by country order by cnt desc limit 1;

#######################################################################################################
-- 10.	Which customers did not place any orders?
select
c.*,o.id
from customer c left join orders o on c.id=o.customerid
where o.id is null; 

#########################################################################################################

              # Section B: Level 2 Questions:
 -- ________________________________________________________________
# 1.Arrange the Product ID and Name based on the high demand by the customer.

# by count of orders
select ProductId ,count(OrderId) as cnt 
from orderitem
group by productid
order by cnt desc limit 1;
  # 59 

# by quantity
select ProductId ,sum(quantity) as qnt 
from orderitem
group by productid
order by qnt desc limit 1;
  # 60 
####################################################################################################
# 2.display the total number of orders delivered every year

select year(orderdate),count(id) as total_orders
from orders
group by year(orderdate);

######################################################################################################
# 3.Calculate year-wise total revenue. 
SELECT 
    YEAR(orderdate) as yr, SUM(totalamount) AS total_revenue
FROM
    orders
GROUP BY YEAR(orderdate);
/*
		year    total_revenue
		----------------------
		2012	226298.50
		2013	658388.75
		2014	469771.34

*/
######################################################################################################
# 4.Display the customer details whose order amount is maximum including his past orders. 
select c.*, sum(totalamount) as order_amount
from customer c join orders o on c.id = o.CustomerId
group by o.CustomerId 
order by order_amount desc limit 1;

########################################################################################################
# 5.Display the total amount ordered by each customer from high to low.
select customerid,sum(totalamount) as total_amount
from orders 
group by CustomerId
order by total_amount desc;

############################################################################################################
   # Additional Level 2 Questions:
-- ______________________________________
# The sales and marketing department of this company wants to find out how frequently customers do business with them. (Answer Q 6 for the same) 

# 6.	Approach - List the current and previous order dates for each customer.
select CustomerId, date(OrderDate)
from orders
group by customerid, date(OrderDate);
###############################################################################################################
# 7.	 Find out the top 3 suppliers in terms of revenue generated by their products. 
select s.*,productid,sum(oi.unitprice*oi.Quantity) as revenue
from orderitem oi join product p on p.id=oi.ProductId join supplier s on s.Id = p.SupplierId
group by productid
order by revenue desc limit 3;

##################################################################################################################################
# 8.	Display the latest order date (should not be the same as the first order date) of all the customers with customer details. 
SELECT 
    c.*
FROM
    customer c
        JOIN
    orders o
GROUP BY c.id
HAVING COUNT(o.id) > 1;

########################################################################################################################################
# 9.	Display the product name and supplier name for each order
SELECT 
    oi.OrderId, p.ProductName, s.ContactName
FROM
    orderitem oi
        JOIN
    product p ON oi.productid = p.id
        JOIN
    supplier s ON s.id = p.supplierid;
 
 ###############################################################################################################################
 
 
 ###############################################################################################################################
 
 # Section D: Level 4 Questions:
# 1.	The company sells the products at different discount rates. Refer actual product price in the product 
#       table and the selling price in the order item table. Write a query to find out the total amount saved 
#       in each order then display the orders from highest to lowest amount saved. 
use supply_chain;
SELECT 
    oi.OrderId,
    SUM((p.UnitPrice * oi.quantity) - (oi.UnitPrice * oi.quantity)) AS amt_saved
FROM
    product p
        JOIN
    orderitem oi ON oi.productid=p.id 
GROUP BY oi.orderid
ORDER BY amt_saved DESC;
######################################################################################################################################################################
# 2.	Mr. Kavin wants to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
       # a.	List a few products that he should choose based on demand.

			select ProductId ,count(OrderId) as cnt 
			from orderitem
			group by productid 
			order by cnt desc limit 10;

       # b.	Who will be the competitors for him for the products suggested in the above questions? 
        
SELECT 
    p.id, p.productname, s.companyname, s.contactname
FROM
    product p
        JOIN
    (SELECT 
        ProductId, COUNT(OrderId) AS cnt
    FROM
        orderitem
    GROUP BY productid
    ORDER BY cnt DESC
    LIMIT 7) AS temp ON temp.ProductId = p.id
        JOIN
    supplier s ON p.supplierid = s.id;


########################################################################################################################################################################
#3.	Create a combined list to display customers' and suppliers' details considering the following criteria 
	# a.	Both customer and supplier belong to the same country 
	select s.companyname, concat_ws(' ',c.firstname,c.lastname) cust_name ,s.country
    from supplier s join customer c on s.country = c.country;
    
    -- select
--     c.id,country, 
--     from customer c join orders o on o.customerid = c.id join orderitem oi on oi.orderid = o.id join product p on p.id = oi.productid join supplier s on p.supplierid = s.id
--     group by c.country
--     having c.country=s.country;

    # b.	Customers who do not have a supplier in their country
    select s.companyname, concat_ws(' ',c.firstname,c.lastname) cust_name ,s.country
    from supplier s right join customer c on s.country = c.country;
    
	# c.	A supplier who does not have customers in their country 

select s.companyname, concat_ws(' ',c.firstname,c.lastname) cust_name ,s.country
    from supplier s left join customer c on s.country = c.country;

# final 
	SELECT 
    s.companyname,
    CONCAT_WS(' ', c.firstname, c.lastname) cust_name,
    s.country
FROM
    supplier s
        JOIN
    customer c ON s.country = c.country 
UNION SELECT 
    s.companyname,
    CONCAT_WS(' ', c.firstname, c.lastname) cust_name,
    s.country
FROM
    supplier s
        RIGHT JOIN
    customer c ON s.country = c.country 
UNION 
SELECT 
    s.companyname,
    CONCAT_WS(' ', c.firstname, c.lastname) cust_name,
    s.country
FROM
    supplier s
        LEFT JOIN
    customer c ON s.country = c.country;
    
########################################################################################################################################################################
#4.	Find out for which products, the UK is dependent on other countries for the supply. List the countries which are supplying these products in the same list.

select 
p.id, oi.OrderId ,p.productname,s.country
from customer c join orders o on c.id = o.customerid join orderitem oi on oi.orderid=o.id join product p on p.id = oi.productid join supplier s on p.supplierid = s.id
where c.Country = 'uk' and s.country!='uk'; 

########################################################################################################################################################################

																	# Section C: Level 3 Questions:
																	-- -------------------------------

select * from orderitem;
#1.	Fetch the customer details who ordered more than 10 products in a single order.
select c.*,count(distinct oi.productid) no_product
from orderitem as oi join orders o on o.id = oi.orderid join customer c on c.id = o.customerid
group by oi.orderid
having no_product > 10;

# inference
	#  customer with id 65	name Paula Wilson	resides in Albuquerque	USA	 have more than 10 products in single order with 25 products
    
########################################################################################################################################################################
#2.	Display all the product details with the ordered quantity size as 1.
 
select oi.orderid,p.* ,oi.quantity
from orderitem as oi join orders o on o.id = oi.orderid join customer c on c.id = o.customerid join product p on oi.productid = p.id
where oi.quantity =1
group by oi.orderid,p.id;

########################################################################################################################################################################
#3.	Display the companies that supply products whose cost is above 100.
select s.companyname
from product p join  supplier s  on p.supplierid = s.id
where p.unitprice > 100;
########################################################################################################################################################################
#4.	Create a combined list to display customers and supplier lists as per the below format.

SELECT 
    CONCAT_WS(' ', c.firstname, c.lastname) AS customer,
    s.contactname,s.city,s.country,s.phone
FROM 
    customer c
JOIN 
    orders o ON c.id = o.customerid
JOIN 
    orderitem oi ON o.id = oi.orderid
JOIN 
    product p ON oi.productid = p.id
JOIN 
    supplier s ON p.supplierid = s.id;



SELECT 
    'Customer' AS Type,
    CONCAT_WS(' ', firstname, lastname) AS ContactName,
    City,
    Country,
    Phone
FROM 
    Customer

UNION

SELECT 
    'Supplier' AS Type,
    ContactName,
    City,
    Country,
    Phone
FROM 
    Supplier;

########################################################################################################################################################################
#5.	Display the customer list who belongs to the same city and country arranged country-wise
select * 
from customer c join customer c1 on c.country = c1.country;

SELECT DISTINCT c1.*
FROM customer c1
JOIN customer c2 
  ON c1.city = c2.city 
  AND c1.country = c2.country
  AND c1.id <> c2.id
ORDER BY c1.country, c1.city;
########################################################################################################################################################################
