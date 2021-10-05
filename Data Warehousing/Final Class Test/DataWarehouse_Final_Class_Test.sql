-- ----------------------------------------------------- Data Warehouse SQL ------------------------------------------------------------------

-- Question 1 - Extract list of the Professors who earn  top three salaries in each of the departments.

WITH Professor_info AS
(
	SELECT 1 AS Staff_ID, 'John'  AS Staff_Name, 1 AS Department_ID, 72000 AS Salary, 2018 AS Year
	UNION
	SELECT 2 AS Staff_ID, 'Fidel' AS Staff_Name, 1 AS Department_ID, 90000 AS Salary, 2018 AS Year
	UNION
	SELECT 3 AS Staff_ID, 'Priya' AS Staff_Name, 2 AS Department_ID, 85000 AS Salary, 2018 AS Year
	UNION
	SELECT 4 AS Staff_ID, 'Alex'  AS Staff_Name, 2 AS Department_ID, 77000 AS Salary, 2017 AS Year
	UNION
	SELECT 5 AS Staff_ID, 'Ryan'  AS Staff_Name, 1 AS Department_ID, 62000 AS Salary, 2017 AS Year
	UNION
	SELECT 6 AS Staff_ID, 'Wyatt' AS Staff_Name, 1 AS Department_ID, 81000 AS Salary, 2018 AS Year
    UNION
	SELECT 7 AS Staff_ID, 'Simon' AS Staff_Name, 2 AS Department_ID, 87000 AS Salary, 2018 AS Year
    UNION
	SELECT 8 AS Staff_ID, 'Caleb' AS Staff_Name, 1 AS Department_ID, 67000 AS Salary, 2017 AS Year
    
), Department_info AS
(
	SELECT 1 AS Department_ID, 'Analytics' 	AS Department_Name
	UNION
	SELECT 2 AS Department_ID, 'Management' AS Department_Name
), salary AS
(
SELECT 
	p.Staff_ID,
	d.Department_Name, 
	p.Staff_Name , 
	p.Salary, 
	DENSE_RANK() OVER(PARTITION BY d.Department_Name ORDER BY p.salary DESC) AS SalaryRank
FROM Professor_info AS p
JOIN Department_info AS d 
	ON d.Department_ID = p.Department_ID
)
SELECT 
	Staff_ID,
	Department_Name,
	Staff_Name,
	Salary
FROM salary
WHERE SalaryRank <= 3;


-- Question 2 - Displaying next quarter sales and difference between present and next quarter sales

WITH sales_report AS
(
SELECT 1 AS quarter, 2020 AS year, 15000 AS sales
UNION
SELECT 2 AS quarter, 2020 AS year, 55000 AS sales
UNION
SELECT 3 AS quarter, 2020 AS year, 85000 AS sales
UNION
SELECT 1 AS quarter, 2019 AS year, 5000 AS sales
UNION
SELECT 2 AS quarter, 2019 AS year, 45000 AS sales
UNION
SELECT 3 AS quarter, 2019 AS year, 120000 AS sales
UNION
SELECT 4 AS quarter, 2019 AS year, 25000 AS sales
UNION
SELECT 1 AS quarter, 2018 AS year, 55000 AS sales
UNION
SELECT 2 AS quarter, 2018 AS year, 90000 AS sales
UNION
SELECT 3 AS quarter, 2018 AS year, 80000 AS sales
UNION
SELECT 4 AS quarter, 2018 AS year, 59000 AS sales
) SELECT
	year AS Year,
	quarter AS Quarter, 
	sales AS Sales, 
    LEAD(sales,1,0) OVER (ORDER BY year, quarter) as Next_Quarter_Sales,  
   	sales - LEAD(sales,1,0) OVER (ORDER BY year, quarter) as Difference_Of_Sales  ,
    CONCAT(ROUND(((sales - LEAD(sales,1,0) OVER (ORDER BY year, quarter))/sales )*100,2),'%') AS Percentage_change
FROM sales_report 
WHERE year IN (2018,2019);

-- Question 3: Get the running total of each payment made by customer by each date

WITH Payment AS
(
	SELECT 1 AS PayID, 1 AS RID, 0.9 AS tax, 27.5	AS pay_amount, '12/12/18' AS pay_date, 10 AS tip
	UNION
 	SELECT 2 AS PayID, 2 AS RID, 0.3 AS tax, 13.5	AS pay_amount, '12/12/18' AS pay_date, 5  AS tip
 	UNION
 	SELECT 3 AS PayID, 3 AS RID, 0.2 AS tax, 7		AS pay_amount, '12/12/18' AS pay_date, 0  AS tip
 	UNION
 	SELECT 4 AS PayID, 4 AS RID, 0.7 AS tax, 12		AS pay_amount, '13/12/18' AS pay_date, 5  AS tip
 	UNION
 	SELECT 5 AS PayID, 5 AS RID, 0.3 AS tax, 16		AS pay_amount, '13/12/18' AS pay_date, 2  AS tip
 	UNION
 	SELECT 6 AS PayID, 6 AS RID, 0.4 AS tax, 7.5	AS pay_amount, '13/12/18' AS pay_date, 3  AS tip
 	UNION
 	SELECT 7 AS PayID, 7 AS RID, 0.6 AS tax, 7.5	AS pay_amount, '14/12/18' AS pay_date, 3  AS tip
 	UNION
 	SELECT 8 AS PayID, 8 AS RID, 0.3 AS tax, 26		AS pay_amount, '14/12/18' AS pay_date, 16 AS tip
 	UNION
 	SELECT 9 AS PayID, 9 AS RID, 0.2 AS tax, 5.5	AS pay_amount, '14/12/18' AS pay_date, 0  AS tip
)
 SELECT
	p.PayId,
    p.pay_date,
    (SELECT 
		SUM(pay_amount) AS pay 
	FROM Payment 
    WHERE payId <=p.PayId AND pay_date <=p.pay_date
    ) AS runningtotal
FROM Payment p
GROUP BY p.PayId, p.pay_date;
	
-- Question 4 - Mike is a primary school student. He measures his height every month in 2019.   
-- He wants to know the height that appears at least 3 months consecutively.

WITH height AS
(	
	SELECT '19-01' AS 'Yr_Month', '121' AS Height
	UNION
	SELECT '19-02' AS 'Yr_Month', '121.2' AS Height
	UNION
	SELECT '19-03' AS 'Yr_Month', '121.2' AS Height
	UNION
	SELECT '19-04' AS 'Yr_Month', '121.2' AS Height
	UNION
	SELECT '19-05' AS 'Yr_Month', '121.5' AS Height
	UNION
	SELECT '19-06' AS 'Yr_Month', '121.5' AS Height
    UNION
    SELECT '19-07' AS 'Yr_Month', '121.7' AS Height
    UNION
    SELECT '19-08' AS 'Yr_Month', '121.7' AS Height
    UNION
    SELECT '19-09' AS 'Yr_Month', '121.8' AS Height
    UNION
    SELECT '19-10' AS 'Yr_Month', '122' AS Height
    UNION
    SELECT '19-11' AS 'Yr_Month', '122.1' AS Height
    UNION
    SELECT '19-12' AS 'Yr_Month', '122.2' AS Height
), ranking AS
(
SELECT
	Yr_Month,
    Height AS Currentheight,
    LEAD(Height, 1, 0) OVER(ORDER BY Yr_Month) AS Nextheight,
    LEAD(Height, 2, 0) OVER (ORDER BY Yr_Month) AS Next2height
FROM height
)
SELECT 
	Currentheight
FROM ranking
WHERE Currentheight = Nextheight AND Currentheight = Next2height;

-- Question 5 - How much bonus can each employee get after tax?  
-- The tax rate is based on the following criteria:  
-- 0% if the max bonus of any employee in this department is less than $300, 
-- 10% if the max bonus of any employee in this department is in the range [$300,$800] inclusive, 
-- 20% if the max bonus of any employee in this department is more than $800.

WITH employee AS
(
	SELECT 1 AS employee_id, 'Tom' AS employee_name,'HR' AS department, 500 AS bonus
	UNION
	SELECT 2 AS employee_id, 'Lucy' AS employee_name,'Finance' AS department, 200 AS bonus
	UNION
	SELECT 3 AS employee_id, 'Mary' AS employee_name,'HR' AS department, 400 AS bonus
	UNION
	SELECT 4 AS employee_id, 'Peter' AS employee_name,'Finance' AS department, 100 AS bonus
	UNION
	SELECT 5 AS employee_id, 'Jess' AS employee_name, 'Finance' AS department,  200 AS bonus
	UNION
	SELECT 6 AS employee_id, 'Emliy' AS employee_name, 'Data' AS department, 1000 AS bonus
)SELECT
	employee_id,
    employee_name,
    department,
    bonus,
	bonus -
    (CASE 
    WHEN bonus < 300 THEN bonus
    WHEN bonus BETWEEN 300 AND 800 THEN bonus*0.1
    WHEN bonus > 800 THEN bonus*0.2
    END ) AS Bonus_After_Tax
FROM employee;

-- Question 6 - Find customer who have ordered lettuce (id =3)

WITH order_items AS(
   SELECT 1  AS order_id, 4 AS product_id, 4 AS quantity, 4.28 AS unit_price
   UNION
   SELECT 2  AS order_id, 1 AS product_id, 2 AS quantity, 6.01 AS unit_price
   UNION
   SELECT 2 AS order_id, 4 AS product_id, 4 AS quantity, 7.28 AS unit_price
   UNION
   SELECT 2  AS order_id, 3 AS product_id, 2 AS quantity, 8.59 AS unit_price
   UNION
   SELECT 3 AS order_id, 3 AS product_id, 10 AS quantity, 6.94 AS unit_price
   UNION
   SELECT 4  AS order_id, 2 AS product_id, 6 AS quantity, 3.45 AS unit_price
   UNION
   SELECT 4 AS order_id, 7 AS product_id, 7 AS quantity, 7.46 AS unit_price
   UNION
   SELECT 5  AS order_id, 5 AS product_id, 3 AS quantity, 3.28 AS unit_price
   UNION
   SELECT 6  AS order_id, 6 AS product_id, 4 AS quantity, 3.28 AS unit_price
   UNION
   SELECT 6 AS order_id, 4 AS product_id, 4 AS quantity, 6.01 AS unit_price
   UNION
   SELECT 6  AS order_id, 3 AS product_id, 2 AS quantity, 6.01 AS unit_price
),customers AS
(
   SELECT 1  AS customer_id, 'Babara' AS first_name, 'MacCaffrey' AS last_name, '781-932-9754' AS phone, 2273 AS points
   UNION
   SELECT 2  AS customer_id, 'Ines' AS first_name, 'Brushfield' AS last_name, '804-427-9456' AS phone, 156 AS points
   UNION
   SELECT 3  AS customer_id, 'Freddi' AS first_name, 'Boagey' AS last_name, '719-724-7869' AS phone, 947 AS points
   UNION
   SELECT 4  AS customer_id, 'Ambur' AS first_name, 'Roseburgh' AS last_name, '407-231-8017' AS phone, 2967 AS points
), orders AS 
(
  SELECT 1  AS order_id, 1 AS customer_id, '2019-01-30' AS order_date
  UNION
  SELECT 2  AS order_id, 2 AS customer_id, '2018-08-02' AS order_date
  UNION
  SELECT 3  AS order_id, 3 AS customer_id, '2017-12-01' AS order_date
  UNION
  SELECT 4 AS order_id, 4 AS customer_id, '2017-01-22' AS order_date
  UNION
  SELECT 5  AS order_id, 1 AS customer_id, '2017-08-25' AS order_date
  UNION
  SELECT 6  AS order_id, 1 AS customer_id, '2017-08-25' AS order_date
  UNION
  SELECT 7  AS order_id, 2 AS customer_id, '2018-09-22' AS order_date
  UNION
  SELECT 8 AS order_id, 3 AS customer_id, '2018-06-08' AS order_date
  UNION
  SELECT 9  AS order_id, 4 AS customer_id, 'Roseburgh' AS order_date
), products AS 
(
  SELECT 1  AS product_id, 'Foam Dinner Plate' AS name, 80 AS quantity_in_stock
  UNION
  SELECT 2  AS product_id, 'Pork - Bacon,back Peameal' AS name, 21 AS quantity_in_stock
  UNION
  SELECT 3  AS product_id, 'Lettuce - Romaine, Heart' AS name, 66 AS quantity_in_stock
  UNION
  SELECT 4  AS product_id, 'Brocolinni - Gaylan, Chinese' AS name, 45 AS quantity_in_stock
  UNION
  SELECT 5  AS product_id, 'Sauce - Ranch Dressing' AS name, 22 AS quantity_in_stock
  UNION
  SELECT 6  AS product_id, 'Petit Baguette' AS name, 12 AS quantity_in_stock
  UNION
  SELECT 7  AS product_id, 'Sweet Pea Sprouts' AS name, 43 AS quantity_in_stock
)
SELECT
	CONCAT(c.first_name,' ',c.last_name) AS 'Customer Name'
FROM customers c
INNER JOIN orders o
	ON c.customer_id = o.customer_id
INNER JOIN order_items oi
	ON oi.order_id = o.order_id
INNER JOIN products p
	ON p.product_id = oi.product_id
WHERE p.product_id = 3;

-- Question 7 - Find out manager with at least 3 direct reports in the department of Analytics.  
-- Show a result with manager ID and the name of that manager. 
-- Problem data - Employee table: The Employee table holds all employees including their managers. 
-- Every employee has an Id, and there is also a column for the manager ID. 

WITH Employee AS(
	SELECT 100 AS ID, 'Mia' AS Employee_Name, 'Analytics' AS Department, NULL AS Manager_Id 
	UNION
	SELECT 101 AS ID, 'Andy' AS Employee_Name, 'Analytics' AS Department, 100 AS Manager_Id
	UNION
	SELECT 102 AS ID, 'David' AS Employee_Name, 'Analytics' AS Department, 100 AS Manager_Id
	UNION
	SELECT 103 AS ID, 'Emily' AS Employee_Name, 'Analytics' AS Department, 100 AS Manager_Id
	UNION
	SELECT 104 AS ID, 'Amy' AS Employee_Name, 'Engineering' AS Department, 100 AS Manager_Id
)
SELECT 
	m.ID AS Manager_id,
	m.Employee_Name AS manager_name
FROM Employee e, Employee m
WHERE e.Manager_Id = M.ID AND e.Department = m.Department
GROUP BY m.ID,  m.Employee_Name;

-- Question 8 - Reformat the table. Each row of the original table 
-- has an event's revenue and the month. The new format will have 12 revenue columns for each month.
WITH department AS
(
	SELECT 'Jan' AS themonth, 1 AS revenue1, 1 AS revenue2, 1 AS revenue3, 1 AS revenue4, 1 AS revenue5, 1 AS revenue6, 1 AS revenue7, 1 AS revenue8, 1 AS revenue9, 1 AS revenue10, 1 AS revenue11, 1 AS revenue12
	UNION 
	SELECT 'Feb' AS themonth, 1 AS revenue1, 1 AS revenue2, 1 AS revenue3, 1 AS revenue4, 1 AS revenue5, 1 AS revenue6, 1 AS revenue7, 1 AS revenue8, 1 AS revenue9, 1 AS revenue10, 1 AS revenue11, 1 AS revenue12
	UNION 
	SELECT 'Mar' AS themonth, 1 AS revenue1, 1 AS revenue2, 1 AS revenue3, 1 AS revenue4, 1 AS revenue5, 1 AS revenue6, 1 AS revenue7, 1 AS revenue8, 1 AS revenue9, 1 AS revenue10, 1 AS revenue11, 1 AS revenue12
	UNION 
	SELECT 'Jan' AS themonth, 1 AS revenue1, 1 AS revenue2, 1 AS revenue3, 1 AS revenue4, 1 AS revenue5, 1 AS revenue6, 1 AS revenue7, 1 AS revenue8, 1 AS revenue9, 1 AS revenue10, 1 AS revenue11, 1 AS revenue12
)
SELECT
	*
FROM department;

-- Question 9 - Write an SQL query to find the most frequently ordered product(s) for each customer.  
-- The result table should have the customer_id, customer_name, product_id and product_name for each customer  
-- who ordered at least one order. Return the result table in any order. 

WITH Customers AS 
(
SELECT 1 AS Customer_Id, 'Amy' AS Customer_Name
UNION 
SELECT 2 AS Customer_Id, 'Bob' AS Customer_Name
UNION
SELECT 3 AS Customer_Id, 'Cher' AS Customer_Name
UNION 
SELECT 4 AS Customer_Id, 'Debby' AS Customer_Name
UNION
SELECT 5 AS Customer_Id, 'Ethan' AS Customer_Name
), 
Orders AS
(
SELECT 1 AS Order_Id, 1 AS Customer_Id, 1 AS Product_Id
UNION
SELECT 2 AS Order_Id, 2 AS Customer_Id, 2 AS Product_Id
UNION
SELECT 3 AS Order_Id, 3 AS Customer_Id, 3 AS Product_Id
UNION
SELECT 4 AS Order_Id, 4 AS Customer_Id, 1 AS Product_Id
UNION
SELECT 5 AS Order_Id, 1 AS Customer_Id, 2 AS Product_Id
UNION
SELECT 6 AS Order_Id, 2 AS Customer_Id, 1 AS Product_Id
UNION
SELECT 7 AS Order_Id, 3 AS Customer_Id, 3 AS Product_Id
UNION
SELECT 8 AS Order_Id, 1 AS Customer_Id, 2 AS Product_Id
UNION
SELECT 9 AS Order_Id, 2 AS Customer_Id, 3 AS Product_Id
UNION
SELECT 10 AS Order_Id, 1 AS Customer_Id, 2 AS Product_Id
),
Products AS
(
SELECT 1 AS Product_Id, 'Apple' AS Product_Name
UNION
SELECT 2 AS Product_Id, 'Airpod' AS Product_Name
UNION
SELECT 3 AS Product_Id, 'iPad' AS Product_Name
UNION
SELECT 4 AS Product_Id, 'Macbook' AS Product_Name
)
SELECT
	c.Customer_Id,
	COUNT(DISTINCT o.order_id) AS mostfrequentorder
FROM Orders o
JOIN Customers c
	ON o.Customer_Id = c.Customer_Id
GROUP BY c.Customer_Id;


-- Question 10 - What is the average birth weight of baby girlS and baby boyS of each county?
WITH NewBornWeight AS
(
	SELECT 1 AS id, 'USA' AS Country, 'Female' AS Gender, 7 AS BirthWeight_lb
	UNION
	SELECT 2 AS id, 'USA' AS Country, 'Female' AS Gender, 7.2 AS BirthWeight_lb
	UNION
	SELECT 3 AS id, 'CHINA' AS Country, 'Female' AS Gender, 7.4 AS BirthWeight_lb
	UNION
	SELECT 4 AS id, 'CHINA' AS Country, 'Female' AS Gender, 6.8 AS BirthWeight_lb
	UNION
	SELECT 5 AS id, 'USA' AS Country, 'Male' AS Gender, 7.6 AS BirthWeight_lb
	UNION
	SELECT 6 AS id, 'USA' AS Country, 'Male' AS Gender,  7.9 AS BirthWeight_lb
	UNION
	SELECT 7 AS id, 'CHINA' AS Country, 'Male' AS Gender,  7.3 AS BirthWeight_lb
	UNION
	SELECT 8 AS id, 'CHINA' AS Country, 'Male' AS Gender,  7.8 AS BirthWeight_lb
)
SELECT 
	Country,
    Gender,
	ROUND(AVG(BirthWeight_lb), 2)
FROM NewBornWeight
GROUP BY Country, Gender
ORDER BY Country ASC;

-- Question 11 - What is the second highest salary?
WITH Employee AS
(
	SELECT 1 AS ID, 777 AS salary
    UNION
	SELECT 2 AS ID, 888 AS salary
    UNION
	SELECT 3 AS ID, 999 AS salary
) 
SELECT
	MAX(salary) AS 'Second Highest Salary'
FROM Employee
WHERE salary < (SELECT
					MAX(salary)
				FROM Employee);
                
-- Question 12 - Find the frequency of each weather and average temperature
WITH Weather_Record AS 
(   
	SELECT 75 AS Temperature, 'Sunny' AS Weather
	UNION
	SELECT 78 AS Temperature, 'Sunny' AS Weather
	UNION
	SELECT 72 AS Temperature, 'Rainy' AS Weather
	UNION
	SELECT 62 AS Temperature, 'Cold' AS Weather
	UNION
	SELECT 71 AS Temperature, 'Sunny' AS Weather
	UNION
	SELECT 70 AS Temperature, 'Cool' AS Weather
	UNION
	SELECT 67 AS Temperature, 'Cool' AS Weather
	UNION
	SELECT 77 AS Temperature, 'Sunny' AS Weather
)
SELECT 
	COUNT(DISTINCT Weather) AS 'Frequency of weather',
    AVG(Temperature) AS 'Average Temprature'
FROM Weather_Record;

-- Question 13 - Generate a list of employees who made more than one sale on the same date
WITH employees AS
(
	SELECT 1 AS emp_id, 'Jim Halpert' AS full_name
	UNION
	SELECT 2 AS emp_id, 'Dwight Schrute' AS full_name
	UNION
	SELECT 3 AS emp_id, 'Pam Beesley' AS full_name
	UNION
	SELECT 4 AS emp_id, 'Michael Scott' AS full_name
	UNION
	SELECT 5 AS emp_id, 'Erin L' AS full_name
),
emp_sales AS
(
	SELECT 1 AS emp_sale_id, 1 AS emp_id, 1 AS sale_id, '2013-08-02' AS sale_date
	UNION
	SELECT 2 AS emp_sale_id, 2 AS emp_id, 1 AS sale_id, '2013-08-03' AS sale_date
	UNION
	SELECT 3 AS emp_sale_id, 3 AS emp_id, 2 AS sale_id, '2013-08-02' AS sale_date
	UNION
	SELECT 4 AS emp_sale_id, 4 AS emp_id, 2 AS sale_id, '2013-08-04' AS sale_date
	UNION
	SELECT 5 AS emp_sale_id, 2 AS emp_id, 2 AS sale_id, '2013-08-03' AS sale_date
	UNION
	SELECT 6 AS emp_sale_id, 1 AS emp_id, 1 AS sale_id, '2013-08-02' AS sale_date
	UNION
	SELECT 7 AS emp_sale_id, 3 AS emp_id, 2 AS sale_id, '2013-08-04' AS sale_date
	UNION
	SELECT 8 AS emp_sale_id, 4 AS emp_id, 3 AS sale_id, '2013-08-03' AS sale_date
	UNION
	SELECT 9 AS emp_sale_id, 1 AS emp_id, 4 AS sale_id, '2013-08-03' AS sale_date
	UNION
	SELECT 10 AS emp_sale_id, 3 AS emp_id, 1 AS sale_id, '2013-08-02' AS sale_date
	UNION
	SELECT 11 AS emp_sale_id, 4 AS emp_id, 2 AS sale_id, '2013-08-04' AS sale_date
	UNION
	SELECT 12 AS emp_sale_id, 3 AS emp_id, 2 AS sale_id, '2013-08-02' AS sale_date
	UNION
	SELECT 13 AS emp_sale_id, 1 AS emp_id, 1 AS sale_id, '2013-08-02' AS sale_date
	UNION
	SELECT 14 AS emp_sale_id, 4 AS emp_id, 3 AS sale_id, '2013-08-03' AS sale_date
), counting AS
(
 SELECT
	DISTINCT sale_date,
	COUNT(sale_id) OVER(Partition by sale_date ORDER BY sale_date) AS countsales
FROM emp_sales
)
SELECT
	*
FROM counting
WHERE countsales > 1;