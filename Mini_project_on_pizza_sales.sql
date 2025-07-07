##   Selecting the 'pizza_db' database for the mini project
USE pizza_db;

# Getting an idea about all the tables in the database
SELECT * FROM order_details;
/* It has 4 columns namely-'order_details','order_id','pizza_id','quantity'*/
 SELECT * FROM orders;
 /* It has 3 coulmns-'order_id','date','time'*/
 SELECT * FROM pizza_types;
/* It has 4 columns-'pizza_type','name','category','ingredients'*/
SELECT * FROM pizzas;
/* It has 4 columns-'pizza_id','pizza_type','size','price'*/


# Questions->

/* Question 1-
Retrieve the total number of orders placed.
*/
# We can use the tables 'order_details' or 'orders' as both have 'order_id' column
SELECT COUNT(distinct(order_id)) as count_orders
FROM order_details;
# The total no.of orders placed is 21350


/* Question 2->
Calculate the total revenue generated from pizza sales.
*/
# We can calculate from the 'pizzas' table
SELECT ROUND(SUM(od.quantity*p.price))as total_revenue
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id=p.pizza_id;

# The Total_revenue of pizza_sales is 817860

/* Question 3->
Identify the highest-priced pizza.
*/
# We can get the data from joining the 'pizzas' and table
SELECT pt.name,p.price
FROM pizza_types AS pt
JOIN pizzas AS p
ON pt.pizza_type_id=p.pizza_type_id
ORDER BY price DESC
LIMIT 1;
# The highest priced pizza is 'The Greek Pizza'

/* Question 4->
Identify the most common pizza size ordered.
*/

SELECT p.size,COUNT(size) AS count_size
FROM pizzas AS p
JOIN order_details AS od
ON p.pizza_id=od.pizza_id
GROUP BY SIZE
ORDER BY count_size desc;
# Most common pizzza size is L

/* Question 5->
List the top 5 most ordered pizza types along with their quantities.
*/

SELECT P.pizza_type_id,SUM(quantity) AS total_quantity
FROM order_details AS od
JOIN pizzas AS P
ON od.pizza_id=P.pizza_id
GROUP BY pizza_type_id
ORDER BY total_quantity DESC
LIMIT 5;
# The 5  most ordered pizza_types are classic_dlx,bbq_ckn,hawalian,pepperoni,thai_ckn

/* Question 6->
Join the necessary tables to find the total quantity of each pizza category ordered.
*/

SELECT pt.category,SUM(od.quantity) AS Total_quantity
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id=p.pizza_id
JOIN pizza_types AS pt
ON p.pizza_type_id=pt.pizza_type_id
GROUP BY category
ORDER BY Total_quantity DESC;

/* Question 7->
Determine the distribution of orders by hour of the day.
*/

SELECT hour(time),COUNT(order_id) AS total_no_of_orders
FROM orders AS o
GROUP BY hour(time)
ORDER BY hour(time);

/* Question 8->
Join relevant tables to find the category-wise distribution of pizzas.
*/

SELECT pt.category,SUM(od.quantity) AS Quantity
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id=p.pizza_id
JOIN pizza_types AS pt
ON p.pizza_type_id=pt.pizza_type_id
GROUP BY category
ORDER BY Quantity DESC;

/* Question 9->
Group the orders by date and calculate the average number of pizzas ordered per day.
*/

# Grouping the orders by date
SELECT o.date, COUNT(o.order_id) AS No_of_orders
FROM orders AS o
GROUP BY o.date;

# Average number of pizzas ordered per day
SELECT FLOOR(AVG(QUANTITY)) AS Average_num_of_pizzas_ordered_per_day
FROM(
SELECT o.date,SUM(od.quantity) AS QUANTITY
FROM order_details AS od
JOIN orders AS o
ON od.order_id=o.order_id
GROUP BY o.date
) AS a;

/* Question-10->
Determine the top 3 most ordered pizza types based on revenue.
*/

SELECT pt.name,FLOOR(SUM(od.quantity*p.price) )AS REVENUE_GENERATED
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id=p.pizza_id
JOIN pizza_types AS pt
ON p.pizza_type_id=pt.pizza_type_id
GROUP BY pt.name
ORDER BY REVENUE_GENERATED DESC
LIMIT 3;

/* Question 11->
Calculate the percentage contribution of each pizza type to total revenue.
*/
SELECT 
pt.name,
ROUND(SUM(od.quantity*p.price)) AS Revenue,
ROUND(
(SUM(od.quantity*p.price)*100)/
(SELECT SUM(od1.quantity*p1.price) AS Total_Revenue
FROM order_details AS od1
JOIN pizzas AS p1
ON od1.pizza_id=p1.pizza_id),2) AS Revenue_distribution
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id=p.pizza_id
JOIN pizza_types AS pt
ON p.pizza_type_id=pt.pizza_type_id
GROUP BY pt.name
ORDER BY Revenue_distribution DESC;

/* Question 12->
Analyze the cumulative revenue generated over time.
*/

SELECT 
o.date,
FLOOR(sum(od.quantity*p.price)) AS revenue,
FLOOR(SUM(SUM(od.quantity*p.price) )OVER (ORDER BY o.date)) AS Cumulative_Revenue
FROM order_details as od
JOIN orders AS o ON od.order_id=o.order_id
JOIN pizzas as p ON p.pizza_id=od.pizza_id
GROUP BY o.date
ORDER BY o.date;

/* Question 13->
Determine the top 3 most ordered pizza types based on revenue for each pizza category.
*/
SELECT 
  category,
  name,
  Revenue
FROM (
  SELECT 
    pt.category,
    pt.name,
    FLOOR(SUM(od.quantity * p.price)) AS Revenue,
    RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rnk
  FROM order_details AS od
  JOIN pizzas AS p ON od.pizza_id = p.pizza_id
  JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
  GROUP BY pt.category, pt.name
) AS ranked_pizzas
WHERE rnk <= 3
ORDER BY category,rnk;

# End of the Q&A








































 
 












 