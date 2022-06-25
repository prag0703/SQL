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

-- 7. Which item was purchased just before the customer became a member?

SELECT 
    s.customer_id,
    s.order_date,
    GROUP_CONCAT(me.product_name)
FROM Sales s
LEFT JOIN members m ON m.customer_id = s.customer_id
JOIN menu me ON me.product_id = s.product_id
WHERE s.order_date < m.join_date 
GROUP BY 1,2
ORDER BY 1 asc;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT 
    s.customer_id,
    s.order_date,
    GROUP_CONCAT(me.product_name) AS list_of_items,
    COUNT(s.product_id) as total_items,
    SUM(me.price) AS amount
FROM Sales s
LEFT JOIN members m ON m.customer_id = s.customer_id
JOIN menu me ON me.product_id = s.product_id
WHERE s.order_date < m.join_date 
GROUP BY 1,2
ORDER BY 1 asc;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
-- how many points would each customer have?
SELECT
	s.customer_id,
	SUM(CASE
		WHEN me.product_name = 'sushi' THEN 2*(me.price)  
		ELSE me.price
	     END) AS points
FROM sales s
LEFT JOIN menu me ON me.product_id = s.product_id 
GROUP BY 1;
 
 -- 10. In the first week after a customer joins the program (including their join date) they earn 2x points 
 -- on all items, not just sushi - how many points do customer A and B have at the end of January?
 
WITH join_week AS
(
SELECT 
    s.customer_id,
    s.order_date,
    me.product_name,
    me.price,
    join_date,
    DATE_ADD(join_date, INTERVAL 5 DAY) as week_after_join
FROM sales s 
LEFT JOIN members m ON m.customer_id = s.customer_id
JOIN menu me ON me.product_id = s.product_id
)
SELECT 
    customer_id,
    GROUP_CONCAT(product_name) AS ordered_items,
    SUM(CASE 
	   WHEN order_date <= join_date and order_date >= week_after_join THEN 2*(price)
	   ELSE price
	END) AS points 
FROM join_week
WHERE order_date < '2021-01-31'
GROUP BY 1


-- Bonus Question
-- Join All The Things
-- Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)
-- customer_id	| order_date	| product_name |	price	| member
-- A	2021-01-01	curry	15	N

SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    CASE 
        WHEN s.order_date < me.join_date THEN 'N'
        WHEN s.order_Date >= me.join_date THEN 'Y'
        ELSE 'N'
     END AS "member"
FROM Sales s
LEFT JOIN Members me ON me.customer_id = s.customer_id
LEFT JOIN menu m ON m.product_id = s.product_id;


-- Extension: Rank All The Things
-- Danny also requires further information about the ranking of customer products, 
-- but he purposely does not need the ranking for non-member purchases so he expects 
-- null ranking values for the records when customers are not yet part of the loyalty program.

WITH basic_data_table AS
(
SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    CASE 
	WHEN s.order_date < me.join_date THEN 'N'
        WHEN s.order_Date >= me.join_date THEN 'Y'
        ELSE 'N'
     END AS "member"
FROM Sales s
LEFT JOIN Members me ON me.customer_id = s.customer_id
LEFT JOIN menu m ON m.product_id = s.product_id
)
SELECT 
	*,
    	CASE 
	     WHEN member = 'Y' THEN RANK() OVER(partition by customer_id, member ORDER BY order_date) 
	     WHEN member = 'N' THEN NULL
	END AS ranking
FROM basic_data_table
ORDER BY customer_id, order_Date ASC ;

-- ----------------------------------------------------------------------------------------------
-- Solution with explanation: 
-- https://medium.com/analytics-vidhya/8-week-sql-challenge-case-study-week-1-dannys-diner-2ba026c897ab#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjJiMDllNzQ0ZDU4Yzk5NTVkNGYyNDBiNmE5MmY3YjM3ZmVhZDJmZjgiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE2NTYxNzI3NTksImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjExNzMxOTcxMTc1MDEwODg2OTM4MSIsImVtYWlsIjoicHJhZ2F0aWRvYmFyaXlhMTBAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF6cCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsIm5hbWUiOiJQcmFnYXRpIEtvbGFkaXlhIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BT2gxNEdnTWFJbUdjOGR0dk1vRE5FWFIwblJIdVBuUmFzRVFOS2RsLTFRU096az1zOTYtYyIsImdpdmVuX25hbWUiOiJQcmFnYXRpIiwiZmFtaWx5X25hbWUiOiJLb2xhZGl5YSIsImlhdCI6MTY1NjE3MzA1OSwiZXhwIjoxNjU2MTc2NjU5LCJqdGkiOiJlMzhjYjU5MWZjMmZkN2NlOGNkMmM5YzNlY2NhMTJlZmFkMTQ4ZDdiIn0.Gr5NpKxw2D3gsn4REwrOuA3vSJg1TlreA79KdF405zNd1MHHQ9MK9gY0MK8bxdf4XlrY89KklDNw1xo2Ut-MQZO9mzmsXFEPpD_x5Oe0NZlCTtciAk6UuQXlk1vseXfWNaOda4OrxwOtIoNKnUErfD-w6ssaCixbxlrrt61lNavznKWlwyBTeftLweeCWP2k7QMeM5c081c9rUgTJiVLPD7j06yWiAEEQXxQa3yq-i_Tl96DUTCjIQtK622mrYu3SnF2bSow6y0GbjqCCeOaZhJds7otsrsjFRJBKiKtUvIlb-XJAjYfxnUUruVMBcOpkptZbVlHvGaUSxovtkJk9g
