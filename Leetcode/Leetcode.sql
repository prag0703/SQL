CREATE SCHEMA Leetcode;

USE Leetcode;

Create Table emp_salary
(
	Id Int,
    Name Varchar(10),
    Salary Int,
    Manager_Id Int Default Null
);

Insert Into emp_salary 
	Values 
	(1, 'Joe', 7000,3),
    (2, 'Herry', 8000,4),
    (3,'Sam', 6000, Null),
    (4,'Max', 9000, Null);
   
CREATE TABLE email
(
	Id int,
    Email varchar(40)
);

Insert Into email 
	Values (1, 'john@example.com'),
    (2, 'bob@example.com'),
    (3,'john@example.com');
    
-- Write an SQL query to report all the duplicate emails.

-- Return the result table in any order.

-- The query result format is in the following example.
-- https://leetcode.com/problems/duplicate-emails/

DELETE 
	p1
FROM email p1, email p2
WHERE p1.Email = p2.Email
	AND 
    p1.Id > p2.ID;
                
Create Table orders
(
	Id Int,
    CustomerId Int
);

Insert Into orders 
	Values (1,3),
    (2, 1);

SELECT
	c.Name AS Customer
FROM emp_salary c
LEFT JOIN orders o
	ON c.Id = o.CustomerId
WHERE o.CustomerId IS NULL;

-- finding emp who has more salary than their managers

SELECT 
	e2.Name AS Employee
FROM emp_salary e1
Join emp_salary e2 ON e1.Id = e2.Manager_Id
WHERE e1.Salary < e2.Salary;


SELECT
	E.Salary AS EMP_SALARY,
    E.Name,
    M.Salary AS Manager_Salary,
    M.Name
FROM emp_salary E
JOIN emp_salary M
	ON E.Id = M.Manager_Id
WHERE E.Salary <  M.Salary;


-- Solution 

SELECT
   e.name
FROM emp_salary e
LEFT JOIN emp_salary m
	ON e.manager_id = m.Id
WHERE e.salary > m.salary;

-- Trued Ifnull

SELECT
	e.name,
	IFNULL(m.name,'NO MANAGER') As Manager
FROM emp_salary e
LEFT JOIN emp_salary m
	ON e.Manager_Id = m.id
;


-- Write an SQL query that reports for every date within at most 90 days from today, 
-- the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

WITH firstlogin AS
(
	SELECT
		activity_date,
		user_id,
		COUNT(user_id),
		RANK() OVER (PARTITION BY user_id ORDER BY activity_date) AS rankdate
	FROM Trafic
	WHERE activity = 'login'
	GROUP BY activity_date, user_id
)
SELECT 
    activity_date AS login_date,
    COUNT(user_id) AS user_count
FROM firstlogin
WHERE rankdate = 1
GROUP BY activity_date
HAVING MONTH(activity_date) IN (6,5,4)
ORDER BY user_count ASC;

-- Write an SQL query to find all the authors that viewed at least one of 
-- their own articles, sorted in ascending order by their id.
SELECT
    author_id AS id
FROM Views
WHERE author_id = viewer_id
GROUP BY author_id
ORDER BY id ASC;

-- Write an SQL query to find all the people who viewed more than 
-- one article on the same date, sorted in ascending order by their id.

SELECT DISTINCT viewer_id AS 'id'
FROM Views
GROUP BY view_date, viewer_id
HAVING COUNT(DISTINCT article_id) > 1
ORDER BY viewer_id
;

-- Question with linked

CREATE TABLE trafic
(
 user_id       int,  
 activity       varchar(30),
 activity_date  date    
);

INSERT INTO trafic VALUES
(  1        , 'login',     '2019-05-01'  ),
(  1        , 'homepage',  ' 2019-05-01 '    ),
(  1        , 'logout',    ' 2019-05-01 '    ),
(  2        , 'login',     ' 2019-06-21 '    ),
(  2        , 'logout  ',  ' 2019-06-21 '    ),
(  3        , 'login',     ' 2019-01-01 '    ),
(  3        , 'jobs    ',  ' 2019-01-01 '    ),
(  3        , 'logout  ',  ' 2019-01-01 '    ),
(  4        , 'login',     ' 2019-06-21 '    ),
(  4        , 'groups  ',  ' 2019-06-21 '    ),
(  4        , 'logout  ',  ' 2019-06-21 '    ),
(  5        , 'login',     ' 2019-03-01 '    ),
(  5        , 'logout  ',  ' 2019-03-01 '    ),
(  5        , 'login',     ' 2019-06-21 '    ),
(  5        , 'logout  ',  ' 2019-06-21 '    );


-- Write an SQL query that reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

WITH rankdata AS
(
    SELECT
        user_id,
        COUNT(user_id),
        activity_date,
        DENSE_RANK() OVER(PARTITION BY user_id ORDER BY activity_date) AS actrank
    FROM trafic
    WHERE activity = 'login'
    GROUP BY user_id, activity_date
)   
SELECT
    activity_date AS login_date,
    COUNT(user_id) AS user_count
FROM rankdata
WHERE actrank = 1
GROUP BY activity_date
HAVING MONTH(activity_date) IN (04,05,06) ;

SELECT
	*,
    RANK() OVER (PARTITION BY user_id ORDER BY activity_date) AS rankdate,
    DENSE_RANK() OVER (PARTITION BY user_id ORDER BY activity_date) AS densedate
FROM trafic
WHERE activity = 'login'
ORDER BY user_id asc;

CREATE TABLE Views
(
article_id int ,    
author_id  int ,    
viewer_id  int ,    
view_date  date    
);

INSERT INTO Views VALUES
( 1   , 3     , 5  , '2019-08-01'),
( 3   , 4     , 5  , '2019-08-01'),
( 1   , 3     , 6  , '2019-08-02'),
( 2   , 7     , 7  , '2019-08-01'),
( 2   , 7     , 6  , '2019-08-02'),
( 4   , 7     , 1  , '2019-07-22'),
( 3   , 4     , 4  , '2019-07-21'),
( 3   , 4     , 4  , '2019-07-21');


select 
	distinct viewer_id as id
from Views
group by viewer_id, view_date
having count(distinct article_id) > 1
order by 1;

CREATE TABLE temprature
(
 Id            int    , 
RecordDate    date  ,  
Temperature   int   );  

INSERT INTO temprature values
(1  , '2015-01-01' , 10 ),
(2  , '2015-01-02' , 25 ),
(3  , '2015-01-03' , 20 ),
(4  , '2015-01-04' , 30 );

select 
    Id
from 
(
    SELECT 
        *,
        lag(Temperature, 1) OVER(ORDER BY RecordDate ) AS temp2,
        lag(recorddate, 1) OVER(ORDER BY RecordDate ) as rd2
    FROM 
    (
        select 
            * 
        from temprature 
        order by recorddate asc
    ) t2
) t1
where Temperature > temp2 and datediff(RecordDate,rd2)=1;



SELECT 
	ID 
FROM
(
	SELECT
		*,
		LAG(RecordDate, 1) OVER(ORDER BY RecordDate ASC) AS DATETEMP,
		LAG(Temperature, 1) OVER(order by RecordDate ASC) AS TEMP
	FROM (
		SELECT
			*
		FROM temprature
		ORDER BY RecordDate ASC
		) t2
) t1
WHERE Temperature > Temp AND DATEDIFF(RecordDate,DATETEMP) = 1;

SELECT 
	*
FROM
(SELECT
	*,
    LEAD(RecordDate, 1) OVER (ORDER BY RecordDate ASC) AS leadrecorddate,
    LEAD(Temperature, 1) OVER (ORDER BY RecordDate ASC) AS leadtemp 
FROM temprature
) T1
WHERE Temperature < leadtemp;  

CREATE TABLE logs
(
 Id            int    , 
Num    int   );  

INSERT INTO logs values
(1  , 1   ),
(2  , 1   ),
(3  , 1   ),
(4  , 2   ),
(5  , 1   ),
(6  , 2   ),
(7  , 2   );


SELECT
    Num AS ConsecutiveNums
FROM (
    SELECT
        *,
        LAG(Num,1,1) OVER(ORDER BY Id) AS ranknum
    FROM Logs
) a 
WHERE Num = ranknum AND ABS(ranknum - ID) = 1
GROUP BY Num
HAVING COUNT(DISTINCT Num) <=3;

-- logic : list three in roq and compare all 
SELECT
   DISTINCT Num AS ConsecutiveNums
FROM (
    SELECT
        Num,
        LAG(Num, 1) OVER(ORDER BY Id) AS lagnum,
        LEAD(Num,1) OVER(ORDER BY Id) AS leadnum
    FROM Logs
) a 
WHERE Num = leadnum AND Num = lagnum;

/*
Write an SQL query to rank the scores. The ranking should be calculated according to the following rules:

The scores should be ranked from the highest to the lowest.
If there is a tie between two scores, both should have the same ranking.
After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
Return the result table ordered by score in descending order.
*/ 

SELECT
    Score,
    DENSE_RANK() OVER(ORDER BY Score DESC) AS 'Rank'
FROM scores;

-- Customers Who Never Order


SELECT
	c.Name AS Customers
FROM Customers c
LEFT JOIN Orders o
	ON c.Id = o.CustomerId
WHERE o.CustomerId IS NULL;


-- Write an SQL query to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa) with a single update statement and no intermediate temp table(s).

-- Note that you must write a single update statement, DO NOT write any select statement for this problem.

UPDATE Salary
SET sex = CASE sex
    WHEN 'm' THEN 'f'
    ELSE 'm' 
    END ;
    
-- hard

/*Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03".

The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

Return the result table in any order. Round Cancellation Rate to two decimal points.*/
SELECT 
    t.Request_at AS DAY,
    ROUND(COUNT( DISTINCT CASE WHEN t.Status Like 'cancel%' THEN t.Id END) / COUNT(DISTINCT Id),2) AS 'Cancellation Rate'
FROM Trips t
JOIN Users AS c
    ON c.Users_Id = t.Client_Id
JOIN Users AS d
    ON d.Users_Id = t.Driver_Id
WHERE t.Request_at BETWEEN "2013-10-01" AND "2013-10-03"
    AND c.Banned = "No"
    AND d.Banned = "No"
GROUP BY t.Request_at;


CREATE TABLE spending (
user_id    int     ,
spend_date  date   ,
platform    varchar(20)   ,
amount      int );

INSERT INTO spending values
(1  ,'2019-07-01' ,'mobile ',100   ),
(1  ,'2019-07-01' ,'desktop',100   ),
(2  ,'2019-07-01' ,'mobile ',100   ),
(2  ,'2019-07-02' ,'mobile ',100   ),
(3  ,'2019-07-01' ,'desktop',100   ),
(3  ,'2019-07-02' ,'desktop',100   );
-- need to work on 

-- HACKER RANK

CREATE TABLE STUDENTS
(
ID int ,    
NAME  Varchar(20)
);
INSERT INTO STUDENTS values
(1 ,'Ashley' ),
(2   ,'samantha' ),
(3  ,'julia'  ),
(4   ,'scarlet' );

CREATE TABLE Packages
(
ID int,
Salary float
);
INSERT INTO Packages values
(1 ,15.20),
(2   , 10.06 ),
(3  ,11.55  ),
(4   ,12.12 );

CREATE TABLE FRIENDS
(
ID int,
friend_id  int
);


INSERT INTO FRIENDS values
(1 , 2),
(2   ,3 ),
(3  , 4),
(4   , 1);

-- runing 
SELECT
    s.Name
FROM STUDENTS S
JOIN FRIENDS F
    USING(ID)
JOIN PACKAGES P1 
    ON S.ID = P1.ID
JOIN PACKAGES P2
    ON F.FRIEND_ID = P2.ID
WHERE p1.Salary < p2.salary
ORDER BY p2.salary;


-- WRONG
WITH CTE AS
(
	SELECT
		s.Name
	FROM STUDENTS S
	JOIN FRIENDS F
		USING(ID)
	JOIN PACKAGES P1 
		ON S.ID = P1.ID
	JOIN PACKAGES P2
		ON F.FRIEND_ID = P2.ID
	WHERE p1.Salary < p2.salary
    ORDER BY p2.salary DESC
)
SELECT
	NAME 
FROM CTE;


































