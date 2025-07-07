# 🍕 Pizza Sales Analysis (SQL Mini Project)

This project presents a detailed analysis of pizza sales using structured query language (SQL). The dataset simulates sales transactions from a fictional pizza chain. The analysis aims to uncover key insights about sales performance, customer behavior, and product trends to support data-driven decision-making.

---

## 📌 Project Objectives

- **Analyze** pizza order data using SQL  
- **Identify** high-performing pizza types and categories  
- **Evaluate** customer ordering patterns  
- **Calculate** revenue-based metrics  
- **Practice** SQL skills: joins, aggregations, subqueries, window functions  

---

## 🗃️ Dataset Description

The database contains the following tables:

| **Table Name**     | **Description**                                           |
|--------------------|-----------------------------------------------------------|
| `orders`           | Order ID and timestamp of each order                      |
| `order_details`    | Items (pizza ID, quantity) in each order                  |
| `pizzas`           | Pizza ID, size, price                                     |
| `pizza_types`      | Pizza name, category (e.g., Classic, Chicken), ingredients|

---

## 🧠 Key SQL Concepts Used

- **JOIN** operations between multiple tables  
- Aggregate functions: **`SUM`, `COUNT`, `AVG`, `FLOOR`**  
- Grouping and ordering: **`GROUP BY`, `ORDER BY`**  
- Filtering: **`WHERE`, `LIMIT`**  
- Subqueries and derived tables  
- Window functions: **`RANK()`, `ROW_NUMBER()`, `SUM() OVER`**  
- Date and time functions: **`HOUR()`, `DATE()`**


## 🔍 Analysis Highlights

### **1. Top 3 Pizzas by Revenue in Each Category**

```sql
SELECT 
  category, name, Revenue
FROM (
  SELECT 
    pt.category,
    pt.name,
    FLOOR(SUM(od.quantity * p.price)) AS Revenue,
    RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rnk
  FROM order_details od
  JOIN pizzas p ON od.pizza_id = p.pizza_id
  JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
  GROUP BY pt.category, pt.name
) AS ranked_pizzas
WHERE rnk <= 3
ORDER BY category, rnk;

## **2. Cumulative Revenue Over Time**
SELECT 
  o.date,
  FLOOR(SUM(od.quantity * p.price)) AS Revenue,
  FLOOR(SUM(SUM(od.quantity * p.price)) OVER (ORDER BY o.date)) AS Cumulative_Revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date;

##**3. Percentage Contribution of Each Pizza Type to Total Revenue**
SELECT 
  pt.name,
  ROUND(SUM(od.quantity * p.price) * 100.0 / 
        (SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2
         JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id), 2) AS Revenue_Percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY Revenue_Percentage DESC;

**📁 Project Structure**

pizza-sales-analysis/
├── README.md                      # Project description and instructions
├── pizza_sales_data.sql           # SQL script to create and populate the database
├── pizza_sales_queries.sql        # All SQL queries used for analysis

**🚀 Possible Extensions**

Add data visualizations in Python (Matplotlib / Seaborn)
Create interactive dashboards using Tableau or Power BI
Build a web dashboard using Flask or Streamlit
Perform sales forecasting with machine learning

**🙌 Acknowledgments**

This dataset is fictional and used solely for learning and demonstration purposes. The project is inspired by real-world business analytics problems commonly faced in retail and food industries.

**📬 Contact**

For suggestions, improvements, or questions, feel free to create an issue or open a pull request.

Happy querying! 🍕📊
