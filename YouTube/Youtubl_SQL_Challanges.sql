-- Query 3:

-- Write a SQL query to display only the details of employees who either earn the highest salary
-- or the lowest salary in each department from the employee table.

-- Tables Structure:

drop table employee;
create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

select * from employee;

-- Solution:
select x.*
from employee e
join (select *,
max(salary) over (partition by dept_name) as max_salary,
min(salary) over (partition by dept_name) as min_salary
from employee) x
on e.emp_id = x.emp_id
and (e.salary = x.max_salary or e.salary = x.min_salary)
order by x.dept_name, x.salary;




-- Query 5:
-- From the login_details table, fetch the users who logged in consecutively 3 or more times.
-- Table Structure:

drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

select * from login_details;

With cte as
(
	SELECT 
		*,
		LEAD(user_name) OVER(ORDER BY login_id) AS nextuser,
		LEAD(user_name,2) OVER(ORDER BY login_id) AS nexttonextuser
	FROM login_details
)
SELECT 
	DISTINCT user_name 
FROM cte 
WHERE user_name = nextuser AND user_name = nexttonextuser;

-- Solution from blog:

select distinct repeated_names
from (
select *,
case when user_name = lead(user_name) over(order by login_id)
and  user_name = lead(user_name,2) over(order by login_id)
then user_name else null end as repeated_names
from login_details) x
where x.repeated_names is not null;


-- Query 7:

-- From the weather table, fetch all the records when London had extremely cold 
-- temperature for 3 consecutive days or more.

-- Note: Weather is considered to be extremely cold then its temperature is less than zero.

-- Table Structure:
USE newschema;
drop table weather;
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
delete from weather;
insert into weather values
(1, 'London', -1, '2021-01-01'),
(2, 'London', -2, '2021-01-02'),
(3, 'London', 4, '2021-01-03'),
(4, 'London', 1, '2021-01-04'),
(5, 'London', -2, '2021-01-05'),
(6, 'London', -5, '2021-01-06'),
(7, 'London', -7, '2021-01-07'),
(8, 'London', 5, '2021-01-08');

select * from weather;
With nextdayweather AS
(
SELECT
	id,
	day,
    LEAD(day) OVER(ORDER BY id) AS nextday,
    LEAD(day,2) OVER(ORDER BY id) AS nexttonext,
    LEAD(temperature) OVER(ORDER BY id) AS nexttemp,
    LEAD(temperature,2) OVER(ORDER BY id) AS nextnexttemp,
    temperature
FROM weather
)
SELECT 
	id,
    temperature,
    day,
    nextday,
    nexttonext
FROM nextdayweather
WHERE temperature < 0 AND nexttemp < 0 AND nextnexttemp < 0
GROUP BY id,temperature, nextday, nexttonext, day
HAVING Day(nextday) - DAY(day) = 1 AND DAY(nexttonext) - DAY(nextday) = 1 OR nexttonext IS NULL;

-- Solution from blog:
SELECT 
	id,
    city,
    temperature,
    day
FROM 
(SELECT
	*,
	CASE 
		WHEN temperature < 0 
			AND lead(temperature) OVER(ORDER BY day)  < 0
            AND lead(temperature,2) OVER(ORDER BY day) < 0 
        THEN 'Y'
        WHEN temperature < 0 
			AND lead(temperature) OVER(ORDER BY day)  < 0
            AND lag(temperature) OVER(ORDER BY day) < 0 
		THEN 'Y'
        WHEN temperature < 0 
			AND lag(temperature) OVER(ORDER BY day)  < 0
            AND lag(temperature,2) OVER(ORDER BY day) < 0 
		THEN 'Y'
	END AS tempratureinrow
FROM weather
) x
WHERE x.tempratureinrow = 'Y';

-- Query 9:

-- Find the top 2 accounts with the maximum number of unique patients on a monthly basis.

-- Note: Prefer the account if with the least value in case of same number of unique patients

-- Table Structure:

drop table patient_logs;
create table patient_logs
(
  account_id int,
  Dates date,
  patient_id int
);

insert into patient_logs values (1, '2020-01-02', 100);
insert into patient_logs values (1, '2020-01-27', 200);
insert into patient_logs values (2, '2020-01-01', 300);
insert into patient_logs values (2, '2020-01-21', 400);
insert into patient_logs values (2, '2020-01-21', 300);
insert into patient_logs values (2, '2020-01-01', 500);
insert into patient_logs values (3, '2020-01-20', 400);
insert into patient_logs values (1, '2020-03-04', 500);
insert into patient_logs values (3, '2020-01-20', 450);

select * from patient_logs;

with cte AS
(
	SELECT
		DISTINCT account_id,
		Dates,
		COUNT(*) OVER(PARTITION BY account_id, MONTH(Dates)) AS monthcount
	FROM patient_logs
),max AS
(
	SELECT 
		account_id,
		date_format(Dates, '%M') AS months,
		MAX(monthcount)
	FROM cte 
	GROUP BY account_id, months
	ORDER BY monthcount DESC
)
SELECT 
	*
FROM max;

WITH CTE AS 
(
	SELECT
		date_format(Dates, '%M') AS months,
		account_id,
		COUNT(DISTINCT patient_id) AS no_of_patients
	FROM patient_logs
	GROUP BY months, account_id
	ORDER BY no_of_patients DESC
), rankresult AS
(
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY months ORDER BY no_of_patients DESC) AS rn
	FROM CTE
)
SELECT
	months,
    account_id,
    no_of_patients
 FROM rankresult
 WHERE rn < 3;
 
 -- MoM(Month over month) percentage change 
WITH previous AS
(
SELECT
	DATE_FORMAT(Dates, '%m') AS months,
    account_id,
    LAG(account_id,1) OVER(PARTITION BY DATE_FORMAT(Dates, '%m')) as previoususer
FROM patient_logs
 )
 SELECT
	*,
    ROUND((account_id - previoususer)/previoususer * 100,2)
 FROM previous
 GROUP BY Months; 
 
 
WITH Orders AS 
(

SELECT  1 AS order_id, 1 AS customer_id, 10 as product_id, '2020-06-10'  AS order_date, 100  AS quantity union
SELECT  2 AS order_id, 1 AS customer_id, 20 as product_id, '2020-07-01'  AS order_date, 10000  AS quantity union
SELECT  3 AS order_id, 1 AS customer_id, 30 as product_id, '2020-07-08'  AS order_date, 200  AS quantity union
SELECT  4 AS order_id, 2 AS customer_id, 10 as product_id, '2020-06-15'  AS order_date, 20  AS quantity union
SELECT  5 AS order_id, 2 AS customer_id, 40 as product_id, '2020-07-01'  AS order_date, 100 AS quantity union
SELECT  6 AS order_id, 3 AS customer_id, 20 as product_id, '2020-06-24'  AS order_date, 2000  AS quantity union
SELECT  7 AS order_id, 3 AS customer_id, 30 as product_id, '2020-06-25'  AS order_date, 2000 AS quantity union
SELECT  9 AS order_id, 3 AS customer_id, 30 as product_id, '2020-05-08'  AS order_date, 30000  AS quantity 
), olddata AS
(
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') As month,
    SUM(quantity) As total_revenu
    -- LAG(quantity,1) OVER(PARTITION BY DATE_FORMAT(order_date, '%Y-%m') ORDER BY order_id) AS last_month
FROM Orders
GROUP BY month
ORDER BY month
)
SELECT 
	month,
    ROUND((total_revenu - LAG(total_revenu,1) OVER())/ LAG(total_revenu,1) OVER() * 100,2) AS percentage_change
FROM olddata ;

-- SECOND WAY to use sum() in lag for MoM % change 

WITH Orders AS 
(
SELECT  1 AS order_id, 1 AS customer_id, 10 as product_id, '2020-06-10'  AS order_date, 100  AS quantity union
SELECT  2 AS order_id, 1 AS customer_id, 20 as product_id, '2020-07-01'  AS order_date, 10000  AS quantity union
SELECT  3 AS order_id, 1 AS customer_id, 30 as product_id, '2020-07-08'  AS order_date, 200  AS quantity union
SELECT  4 AS order_id, 2 AS customer_id, 10 as product_id, '2020-06-15'  AS order_date, 20  AS quantity union
SELECT  5 AS order_id, 2 AS customer_id, 40 as product_id, '2020-07-01'  AS order_date, 100 AS quantity union
SELECT  6 AS order_id, 3 AS customer_id, 20 as product_id, '2020-06-24'  AS order_date, 2000  AS quantity union
SELECT  7 AS order_id, 3 AS customer_id, 30 as product_id, '2020-06-25'  AS order_date, 2000 AS quantity union
SELECT  9 AS order_id, 3 AS customer_id, 30 as product_id, '2020-05-08'  AS order_date, 30000  AS quantity 
)
SELECT
	DATE_FORMAT(order_date,'%Y-%m') as month,
    SUM(quantity),
    LAG(SUM(quantity),1) OVER(W) AS previous,
    ROUND((SUM(quantity) - LAG(SUM(quantity),1) OVER(W))/ LAG(SUM(quantity),1) OVER(W) * 100,2) AS percentchange
FROM Orders
GROUP BY month
WINDOW W AS (ORDER BY DATE_FORMAT(order_date,'%Y-%m'))
ORDER BY month ASC;

-- parent null is root
-- node in parent is inner 
-- node not in parent is leaf

WITH tree AS 
(
SELECT  1 AS node, 2 as parent union
SELECT  2 AS node, 5 as parent union
SELECT  3 AS node, 5 as parent union
SELECT  4 AS node, 3 as parent union
SELECT  5 AS node, NULL as parent
)
SELECT
	node,
	CASE 
		WHEN parent IS NULL THEN 'Root'
        WHEN node IN (SELECT parent FROM tree) THEN 'Inner'
        ELSE 'Leaf'
    END AS label
FROM tree
GROUP BY node, label; 

-- *:* Write a query that gets the number of retained users per month. In this case, retention for a 
-- given month is defined as the number of users who logged in that month who also logged in the 
-- immediately previous month. 

WITH logins AS 
(
SELECT  1    AS user_id, '2018-07-01' AS dates union
SELECT  234  AS user_id, '2018-07-02' AS dates union
SELECT  3    AS user_id, '2018-07-02' AS dates union
SELECT  1    AS user_id, '2018-07-02' AS dates union
SELECT  1    AS user_id, '2018-08-01' AS dates union
SELECT  234  AS user_id, '2018-08-02' AS dates union
SELECT  3    AS user_id, '2018-08-02' AS dates union
SELECT  1    AS user_id, '2018-08-02' AS dates union
SELECT  1    AS user_id, '2018-09-01' AS dates union
SELECT  234  AS user_id, '2018-09-02' AS dates union
SELECT  3    AS user_id, '2018-09-02' AS dates union
SELECT  234  AS user_id, '2018-09-02' AS dates 
), listresult AS
(
SELECT
	DATE_FORMAT(dates,'%m') as month,
	COUNT(user_id) AS Numberofuser,
    GROUP_CONCAT(user_id) AS alllogins,
    LAG(GROUP_CONCAT(user_id),1) OVER() AS previosmonthlogins
FROM logins
GROUP BY month
)
SELECT 
	*
FROM listresult
WHERE alllogins = previosmonthlogins;

WITH transactions AS
(
	SELECT '2018-01-01' AS date, -1000     as cash_flow union 
	SELECT '2018-01-02' AS date, -100      as cash_flow union 
	SELECT '2018-01-03' AS date, 50        as cash_flow 
)
SELECT
	date,
    SUM(cash_flow) OVER(ORDER BY date) as cumulative_cf
FROM transactions;

-- Write a query to get 7-day rolling (preceding) average of daily sign ups. 
WITH signups AS
(
	SELECT '2018-01-01' AS date, 1 as cash_flow union 
	SELECT '2018-01-02' AS date, 2 as cash_flow union 
	SELECT '2018-01-03' AS date, 3 as cash_flow union
    SELECT '2018-01-04' AS date, 4 as cash_flow union 
	SELECT '2018-01-05' AS date, 5 as cash_flow union 
	SELECT '2018-01-06' AS date, 6 as cash_flow union
    SELECT '2018-01-07' AS date, 7 as cash_flow union 
	SELECT '2018-01-08' AS date, 1 as cash_flow union 
	SELECT '2018-01-09' AS date, 2 as cash_flow union
    SELECT '2018-01-10' AS date, 3 as cash_flow union
    SELECT '2018-01-11' AS date, 1 as cash_flow union 
	SELECT '2018-01-12' AS date, 2 as cash_flow union 
	SELECT '2018-01-13' AS date, 3 as cash_flow union
    SELECT '2018-01-14' AS date, 4 as cash_flow union 
	SELECT '2018-01-15' AS date, 5 as cash_flow union 
	SELECT '2018-01-16' AS date, 6 as cash_flow union
    SELECT '2018-01-17' AS date, 7 as cash_flow 
    
)
SELECT
	date,
    cash_flow,
    AVG(cash_flow),
	ROUND(AVG(cash_flow) OVER(ORDER BY date ROWS BETWEEN 6 PRECEDING AND 0 PRECEDING),1) AS avgrolling
FROM signups
GROUP BY date, cash_flow ;

-- Explore ROWS BETWEEN PRECEDING AND FOLLOWING

WITH rowsexp AS
(
	SELECT '2018-01-01' AS date, 1 as cash_flow union 
	SELECT '2018-01-02' AS date, 2 as cash_flow union 
	SELECT '2018-01-03' AS date, 3 as cash_flow union
    SELECT '2018-01-04' AS date, 4 as cash_flow union 
	SELECT '2018-01-05' AS date, 5 as cash_flow union 
	SELECT '2018-01-06' AS date, 6 as cash_flow union
    SELECT '2018-01-07' AS date, 7 as cash_flow union
    SELECT '2018-01-07' AS date, 2 as cash_flow
)
SELECT
	date,
    cash_flow,
	SUM(cash_flow) OVER(ORDER BY date ROWS BETWEEN 6 PRECEDING AND 0 PRECEDING) AS sunover
FROM rowsexp;
-- Multiple Joins
 
SELECT 1/2;
SELECT CAST(1 AS REAL) / 2;
SELECT 17 /5;
SELECT 17/5 , 17%5;

CREATE VIEW times AS
WITH rowsexp AS
(
	SELECT '2018-01-01' AS date, 1000 as cash_flow union 
	SELECT '2018-01-02' AS date, 200 as cash_flow union 
	SELECT '2018-01-03' AS date, 300 as cash_flow union
    SELECT '2018-01-04' AS date, 40 as cash_flow union 
	SELECT '2018-01-05' AS date, 50 as cash_flow union 
	SELECT '2018-01-06' AS date, 60 as cash_flow union
    SELECT '2018-01-07' AS date, 70 as cash_flow union
    SELECT '2018-01-07' AS date, 20 as cash_flow
)
SELECT
	cash_flow / 60 AS m,
    cash_flow % 60 AS s,
    CONCAT(ROUND(cash_flow / 60,0) ,':',cash_flow % 60) AS duration
FROM rowsexp;

 
SELECT * fROM sales;

-- '2018-01-01' - New
-- '2018-01-02' - Inactive
-- '2018-01-03' - active

WITH Listofdates AS
(
	SELECT '2018-01-01' AS date union 
	SELECT '2018-01-02' AS date union 
	SELECT '2018-01-03' AS date union
    SELECT '2018-01-04' AS date union 
	SELECT '2018-01-05' AS date union 
	SELECT '2018-01-06' AS date union
    SELECT '2018-01-07' AS date union
    SELECT '2018-01-07' AS date
), logins AS
(
	SELECT '2018-01-01' AS date, 1 as userId union 
	SELECT '2018-01-03' AS date, 1 as userId union
	SELECT '2018-01-06' AS date, 2 as userId union
    SELECT '2018-01-07' AS date, 2 as userId union
    SELECT '2018-01-07' AS date, 3 as userId
), rankdate AS
(
SELECT 
	l.date as logindate,
    l.userId as users,
    ld.date As caldate,
	RANK() OVER(PARTITION BY l.userId ORDER BY l.date) AS rn
FROM logins l
RIGHT JOIN Listofdates ld
	ON l.date = ld.date
)
SELECT 
	caldate,
	CASE 
		WHEN rn = 1 AND logindate IN (SELECT date FROM logins) THEN 'New'
        WHEN rn >= 1 AND caldate NOT IN (SELECT date FROM logins)  OR logindate IS NULL THEN 'inactive'
		WHEN caldate IN (SELECT date FROM logins) THEN 'active'
	END AS state 
FROM rankdate
ORDER BY caldate;

--  ------ ------ ------  Youtube SQL challanges --  ------ ------ ------  
-- total no of users by date =  downloads for premium and free
-- only records where free downloads > paying 
-- order by earliest date 

-- -
-- date nonplying paying 

-- ms_user_dim - user_id, acc_id
-- ms_acc_dim - acc_id, playing_cust(yes, no)
-- ms_dowloads - date, user_is, downloads(num)

-- 1) join 
With ms_user_dim AS
(	
	SELECT 1 AS user_id, 123 AS acc_id union
    SELECT 2 AS user_id, 153 AS acc_id union
    SELECT 3 AS user_id, 113 AS acc_id 
),ms_acc_dim AS
(
	SELECT 123 AS acc_id, 'yes' AS playing_cust union
    SELECT 153 AS acc_id, 'No' AS playing_cust union
    SELECT 153 AS acc_id, 'No' AS playing_cust union
    SELECT 153 AS acc_id, 'No' AS playing_cust union
    SELECT 153 AS acc_id, 'No' AS playing_cust union
    SELECT 113 AS acc_id, 'Yes' AS playing_cust 
), ms_dowloads AS
(	
	SELECT '2018-01-01' AS date, 1 as user_id, 2 AS downloads union 
	SELECT '2018-01-03' AS date, 1 as user_id, 3 AS downloads union
	SELECT '2018-01-06' AS date, 2 as user_id, 2 AS downloads  union
    SELECT '2018-01-07' AS date, 2 as user_id, 24 AS downloads union
    SELECT '2018-01-07' AS date, 1 as user_id, 7  AS downloads 
), Result AS
(
SELECT 
	d.date,
	SUM(CASE WHEN a.playing_cust = 'yes' THEN d.downloads END) as paying,
	SUM(CASE WHEN a.playing_cust = 'no' THEN d.downloads END) as nonpaying
FROM  ms_dowloads d
		LEFT JOIN ms_user_dim u 
		ON u.user_id = d.user_id
		LEFT JOIN ms_acc_dim a
		ON a.acc_id = u.acc_id
GROUP BY d.date
ORDER BY d.date ASC
)
SELECT 
	*
FROM Result
WHERE nonpaying > paying;
