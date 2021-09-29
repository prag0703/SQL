--------------------------------
-- CASE STUDY #1: DANNY'S DINER--
--------------------------------

CREATE SCHEMA dannys_diner;

USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

SELECT *
FROM dannys_diner.members;

SELECT *
FROM dannys_diner.menu;

SELECT * 
FROM dannys_diner.sales;

------------------------
-- CASE STUDY QUESTIONS--
------------------------

-- 1. What is the total amount each customer spent at the restaurant?

SELECT
	s.customer_id,
    SUM(m.price) AS TotalSpending
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id, TotalSpending;

-- 2. How many days has each customer visited the restaurant?
SELECT
	customer_id,
    COUNT(DISTINCT(order_date)) AS Count_of_visit -- it should be unique visit
FROM sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
WITH FIRST_PURCHASE AS
(SELECT
	s.customer_id,
    s.order_date,
    m.product_name,
    DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS Rankeach
FROM sales s
INNER JOIN menu m ON m.product_id = s.product_id
GROUP BY s.customer_id, s.order_date,  m.product_name
ORDER BY s.customer_id
)
SELECT
	customer_id,
    product_name
FROM FIRST_PURCHASE 
WHERE Rankeach = 1
GROUP BY customer_id, product_name
ORDER BY customer_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT
	m.product_name,
    COUNT(s.product_id) AS Mostpurchased
FROM menu m
JOIN sales s
	ON s.product_id = m.product_id
GROUP BY m.product_id, m.product_name
ORDER BY Mostpurchased DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

WITH MOST_POPULAR AS
(SELECT
	s.customer_id,
    s.order_date,
    m.product_name,
    m.product_id,
    DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.customer_id) DESC) AS Rankeach
FROM sales s
INNER JOIN menu m ON m.product_id = s.product_id
GROUP BY s.customer_id, s.order_date,  m.product_name, m.product_id
ORDER BY s.customer_id
)
SELECT
	customer_id,
    product_name,
    COUNT(product_id)
FROM MOST_POPULAR 
WHERE Rankeach = 1
GROUP BY customer_id, product_name
ORDER BY customer_id;

-- 6. Which item was purchased first by the customer after they became a member?

WITH FIRST_ORDER AS
(
SELECT
	s.customer_id,
    s.order_date,
    me.join_date,
    s.product_id,
    DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) rank_item
FROM sales s
INNER JOIN members me
	ON s.customer_id = me.customer_id
WHERE s.order_date >= me.join_date
)
SELECT 
	f.customer_id,
    f.order_date,
    m.product_name
FROM FIRST_ORDER f
INNER JOIN menu m
	ON f.product_id = m.product_id
WHERE rank_item = 1
GROUP BY f.customer_id, f.order_date, m.product_name
ORDER BY f.customer_id;
