/* Group 3: Pragati Koladiya
Fall A 2020
ALY 6030
Assignment 4
Last updated: 10/19/2020 */

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 1
# Q1. Retrieve the highest and second highest cab price with their product type and category.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH CabDetail AS
(
	SELECT 0 AS  CabID, 'Lyft' AS cab_type,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	4 AS capacity
	UNION
	SELECT 1 AS  CabID, 'Lyft' AS cab_type,		'lyft_premier' 	AS	product_name,	'Shared'		AS cab_name,	5 AS capacity
	UNION
	SELECT 2 AS  CabID, 'Lyft' AS cab_type,		'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	4 AS capacity
	UNION
	SELECT 3 AS  CabID, 'Lyft' AS cab_type,		'lyft_luxsuv'	AS	product_name,	'Lux Black' 	AS cab_name,	4 AS capacity
	UNION
	SELECT 4 AS  CabID, 'Lyft' AS cab_type,		'Lyft_Plus'	 	AS	product_name,	'Lyft'			AS cab_name,	6 AS capacity
	UNION
	SELECT 5 AS  CabID, 'Lyft' AS cab_type,		'lyft_lux'	 	AS	product_name,	'Lux Black'	 	AS cab_name,	4 AS capacity
	UNION
	SELECT 6 AS  CabID, 'Lyft' AS cab_type,		'lyft_XL'	 	AS	product_name,	'Lyft'			AS cab_name,	6 AS capacity
	UNION
	SELECT 7 AS  CabID, 'Lyft' AS cab_type,		'lyft_lux'	 	AS	product_name,	'Lux Black'	 	AS cab_name,	4 AS capacity
	UNION
	SELECT 8 AS  CabID, 'Lyft' AS cab_type,	  	'lyft_line'	 	AS	product_name,	'Shared'	 	AS cab_name,	4 AS capacity
),  RideDetail AS
(
	SELECT 1 AS RID, 2 AS CabID,  23 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 5 		   AS price, 1 AS rating, '16/12/18'  AS rideDate, 'start' AS status 
	UNION
	SELECT 2 AS RID, 3 AS CabID,  21 AS CustID,  12 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 11		   AS price, 5 AS rating, '27/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 3 AS RID, 5 AS CabID,  24 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 7 		   AS price, 4 AS rating, '28/11/18' AS rideDate, 'cancled' AS status
	UNION
	SELECT 4 AS RID, 7 AS CabID,  22 AS CustID,  14 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 26		   AS price, 3 AS rating,  '30/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 5 AS RID, 6 AS CabID,  23 AS CustID,  15 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 9 		   AS price, 5 AS rating,  '29/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 6 AS RID, 4 AS CabID,  25 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 16.5   	   AS price, 3 AS rating,  '17/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 7 AS RID, 1 AS CabID,  27 AS CustID,  17 AS DriverID, 	1.08 AS distance, 'Northeastern University'  	AS destination, 'Back Bay'		 	AS origin, 10.5   	   AS price, 4 AS rating,  '26/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 8 AS RID, 8 AS CabID,  26 AS CustID,  18 AS DriverID,  	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 16.5   	   AS price, 5 AS rating,  '02/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 9 AS RID, 7 AS CabID,  26 AS CustID,  15 AS DriverID,	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 3		   AS price, 3 AS rating, '03/12/18' AS rideDate, 'cancled' AS status
), cabprice AS
(	
	SELECT 
		a.product_name AS Product_Type,
        a.cab_name AS Cab_Category,
        b.price,
        DENSE_RANK() OVER(PARTITION BY a.cab_name  ORDER BY b.price DESC) AS Rank_By_Price
	FROM CabDetail a
	JOIN RideDetail b
		ON b.CabID = a.CabID
)SELECT
	Rank_By_Price,
    Product_Type,
    Cab_Category,
    Price
FROM cabprice
WHERE Rank_By_Price < 3;

# Output:
-- The result shows the list of cab category and product type which is ranked by price. 
-- For instance, cab "Lux Black" has top two ranked prices which are different based on product type. 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 2
# Q2. Write a query to get drivers who made more than one trip a day.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 WITH DriverDetail AS 
(
	SELECT 11 AS DriverID, 6 AS CabID, 'Mary'		AS DName, 34 AS DAge		
	UNION
	SELECT 12 AS DriverID, 4 AS CabID, 'Anna'		AS DName, 40 AS DAge	
	UNION
	SELECT 13 AS DriverID, 2 AS CabID, 'Emma'		AS DName, 28 AS DAge
	UNION
	SELECT 14 AS DriverID, 7 AS CabID, 'Elizabeth'	AS DName, 56 AS DAge	
	UNION
	SELECT 15 AS DriverID, 2 AS CabID, 'Minnie'		AS DName, 34 AS DAge
	UNION
	SELECT 16 AS DriverID, 7 AS CabID, 'Margaret'	AS DName, 46 AS DAge	
	UNION
	SELECT 17 AS DriverID, 1 AS CabID, 'Ida'		AS DName, 33 AS DAge
	UNION
	SELECT 18 AS DriverID, 8 AS CabID, 'Sarah'		AS DName, 27 AS DAge
), RideDetail AS
(
	SELECT 1 AS RID, 2 AS CabID,  23 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 5 		   AS price, 1 AS rating, '16/11/18'  AS rideDate, 'start' AS status 
	UNION
	SELECT 2 AS RID, 6 AS CabID,  23 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 11		   AS price, 5 AS rating, '16/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 3 AS RID, 6 AS CabID,  24 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 7 		   AS price, 4 AS rating, '16/11/18' AS rideDate, 'cancled' AS status
	UNION
	SELECT 4 AS RID, 4 AS CabID,  23 AS CustID,  12 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' AS origin, 26		   AS price, 3 AS rating,  '16/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 5 AS RID, 6 AS CabID,  23 AS CustID,  15 AS DriverID,   	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 9 		   AS price, 5 AS rating,  '16/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 6 AS RID, 4 AS CabID,  25 AS CustID,  12 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 16.5   	   AS price, 3 AS rating,  '16/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 7 AS RID, 4 AS CabID,  27 AS CustID,  12 AS DriverID, 	1.08 AS distance, 'Northeastern University'  	AS destination, 'Back Bay'		 	AS origin, 10.5   	   AS price, 4 AS rating,  '16/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 8 AS RID, 6 AS CabID,  23 AS CustID,  18 AS DriverID,  	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 16.5   	   AS price, 5 AS rating,  '16/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 9 AS RID, 7 AS CabID,  26 AS CustID,  15 AS DriverID,	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 3		   AS price, 3 AS rating, '16/11/18' AS rideDate, 'cancled' AS status
)
SELECT
      d.DriverID,
      d.DName AS DriverName,
      r.CabID,
      r.rideDate AS RideDate,
      COUNT(r.RID) AS RIDECOUNT
FROM DriverDetail d 
JOIN RideDetail r ON r.DriverID = d.DriverID
GROUP BY d.DriverID,
           d.DNAME,
           r.CabID,
           r.rideDate
HAVING COUNT(r.RID) > 1
ORDER BY r.rideDate DESC;

# Output:
-- The result shows the top two price of cab by it's product type and grouped by cab category. 
-- For instance, the cab category "Lux Black" has two different price based on it's product type "lyft_lux and lyft_luxsuv". 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 3
# Q3. For a given rider with same ride source and destination, comeup with their satisfaction 
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH DriverDetail AS 
(
	SELECT 11 AS DriverID, 6 AS CabID, 'Mary'		AS DName, 34 AS DAge		
	UNION
	SELECT 12 AS DriverID, 4 AS CabID, 'Anna'		AS DName, 40 AS DAge	
	UNION
	SELECT 13 AS DriverID, 2 AS CabID, 'Emma'		AS DName, 28 AS DAge
	UNION
	SELECT 14 AS DriverID, 7 AS CabID, 'Elizabeth'	AS DName, 56 AS DAge	
	UNION
	SELECT 15 AS DriverID, 2 AS CabID, 'Minnie'		AS DName, 34 AS DAge
	UNION
	SELECT 16 AS DriverID, 7 AS CabID, 'Margaret'	AS DName, 46 AS DAge	
	UNION
	SELECT 17 AS DriverID, 1 AS CabID, 'Ida'		AS DName, 33 AS DAge
	UNION
	SELECT 18 AS DriverID, 8 AS CabID, 'Sarah'		AS DName, 27 AS DAge
), RideDetail AS
(
	SELECT 1 AS RID, 2 AS CabID,  23 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 5 		   AS price, 1 AS rating, '16/12/18'  AS rideDate, 'start' AS status 
	UNION
	SELECT 2 AS RID, 3 AS CabID,  21 AS CustID,  12 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 11		   AS price, 5 AS rating, '27/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 3 AS RID, 5 AS CabID,  24 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 7 		   AS price, 4 AS rating, '28/11/18' AS rideDate, 'cancled' AS status
	UNION
	SELECT 4 AS RID, 4 AS CabID,  22 AS CustID,  14 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 26		   AS price, 3 AS rating,  '30/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 5 AS RID, 6 AS CabID,  23 AS CustID,  15 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 9 		   AS price, 5 AS rating,  '29/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 6 AS RID, 4 AS CabID,  25 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 16.5   	   AS price, 3 AS rating,  '17/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 7 AS RID, 1 AS CabID,  27 AS CustID,  17 AS DriverID, 	1.08 AS distance, 'Northeastern University'  	AS destination, 'Back Bay'		 	AS origin, 10.5   	   AS price, 4 AS rating,  '26/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 8 AS RID, 8 AS CabID,  26 AS CustID,  18 AS DriverID,  	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 16.5   	   AS price, 5 AS rating,  '02/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 9 AS RID, 7 AS CabID,  26 AS CustID,  15 AS DriverID,	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 3		   AS price, 3 AS rating, '03/12/18' AS rideDate, 'cancled' AS status
), CabDetail AS
(
	SELECT 0 AS  CabID, 'Lyft' AS cab_type,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	4 AS capacity
	UNION
	SELECT 1 AS  CabID, 'Lyft' AS cab_type,		'lyft_premier' 	AS	product_name,	'Lux'			AS cab_name,	5 AS capacity
	UNION
	SELECT 2 AS  CabID, 'Lyft' AS cab_type,		'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	4 AS capacity
	UNION
	SELECT 3 AS  CabID, 'Lyft' AS cab_type,		'lyft_luxsuv'	AS	product_name,	'Lux Black XL' 	AS cab_name,	4 AS capacity
	UNION
	SELECT 4 AS  CabID, 'Lyft' AS cab_type,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	6 AS capacity
	UNION
	SELECT 5 AS  CabID, 'Lyft' AS cab_type,		'lyft_lux'	 	AS	product_name,	'Lux Black'	 	AS cab_name,	4 AS capacity
	UNION
	SELECT 6 AS  CabID, 'Lyft' AS cab_type,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	6 AS capacity
	UNION
	SELECT 7 AS  CabID, 'Lyft' AS cab_type,		'lyft_lux'	 	AS	product_name,	'Lux Black'	 	AS cab_name,	4 AS capacity
	UNION
	SELECT 8 AS  CabID, 'Lyft' AS cab_type,	  	'lyft_line'	 	AS	product_name,	'Shared'	 	AS cab_name,	4 AS capacity
), CustomerDetail AS
(
	SELECT 21 AS CustID, Jennie 	AS CName, 23 AS CAge, 'San Francisco' AS CAddress, 90004 AS PostalCode 
	UNION
	SELECT 22 AS CustID, Gertrude 	AS CName, 34 AS CAge, 'Los Angeles'   AS CAddress, 90005 AS PostalCode 
	UNION
	SELECT 23 AS CustID, Julia 	AS CName, 56 AS CAge, 'Los Angeles'   AS CAddress, 94208 AS PostalCode 
	UNION
	SELECT 24 AS CustID, Hattie 	AS CName, 34 AS CAge, 'Los Angeles'   AS CAddress, 90006 AS PostalCode 
	UNION
	SELECT 25 AS CustID, Edith 	AS CName, 78 AS CAge, 'Sacramento'    AS CAddress, 95101 AS PostalCode 
	UNION
	SELECT 26 AS CustID, Mattie 	AS CName, 45 AS CAge, 'Los Angeles'   AS CAddress, 92071 AS PostalCode 
	UNION
	SELECT 27 AS CustID, Rose 		AS CName, 89 AS CAge, 'San Francisco' AS CAddress, 95101 AS PostalCode 
), cte_ride AS
(
	SELECT 
		rd.CustID,
        rd.Distance,
        rd.rating,
		d.DName,
		c.cab_type,
		c.cab_name,
		rd.destination,
		rd.origin
	FROM RideDetail rd
	INNER JOIN DriverDetail AS d ON d.DriverID=rd.DriverID
	INNER JOIN CabDetail AS c ON c.CabID=rd.CabID
)
SELECT 
	CustID,
	DName AS DriverName,
	cab_type AS CabCompany,
	cab_name AS CabCategory,
	destination AS Destination,
    origin AS Origin,
    AVG(rating) AS AverageRating
FROM cte_ride 
GROUP BY 
	CustID,
	Dname,
    cab_type,
    cab_name,
    destination,
    origin
ORDER BY CustID ASC;

# Output:
-- The result shows that the customer who has made trips multiple time for same source and destination, gave the average rating consedaring key factor cab category.
-- For instance, Customer 21 has made the multiple trips in cab category "Lux Black XL" for same distance with driver Anna and gave average rating 5.

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 4
# Q4. Come up with trips by their tip ranking (top 5) for a given source and desination.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH Payment AS
(
	SELECT 1 AS PayID, 1 AS RID, 0.9 AS tax, 27.5	AS subtotal, '16/12/18' AS pay_date, 10 AS tip
	UNION
 	SELECT 2 AS PayID, 2 AS RID, 0.3 AS tax, 13.5	AS subtotal, '27/11/18' AS pay_date, 5  AS tip
 	UNION
 	SELECT 3 AS PayID, 3 AS RID, 0.2 AS tax, 7		AS subtotal, '28/11/18' AS pay_date, 0  AS tip
 	UNION
 	SELECT 4 AS PayID, 4 AS RID, 0.7 AS tax, 12		AS subtotal, '30/11/18' AS pay_date, 5  AS tip
 	UNION
 	SELECT 5 AS PayID, 5 AS RID, 0.3 AS tax, 16		AS subtotal, '29/11/18' AS pay_date, 2  AS tip
 	UNION
 	SELECT 6 AS PayID, 6 AS RID, 0.4 AS tax, 7.5	AS subtotal, '17/12/18' AS pay_date, 3  AS tip
 	UNION
 	SELECT 7 AS PayID, 7 AS RID, 0.6 AS tax, 7.5	AS subtotal, '26/11/18' AS pay_date, 3  AS tip
 	UNION
 	SELECT 8 AS PayID, 8 AS RID, 0.3 AS tax, 26		AS subtotal, '02/12/18' AS pay_date, 16 AS tip
 	UNION
 	SELECT 9 AS PayID, 9 AS RID, 0.2 AS tax, 5.5	AS subtotal, '03/12/18' AS pay_date, 0  AS tip
),  RideDetail AS
(
	SELECT 1 AS RID, 2 AS CabID,  23 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 5 		   AS price, 1 AS rating, '16/12/18'  AS rideDate, 'start' AS status 
	UNION
	SELECT 2 AS RID, 3 AS CabID,  21 AS CustID,  12 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 11		   AS price, 5 AS rating, '27/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 3 AS RID, 5 AS CabID,  24 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 7 		   AS price, 4 AS rating, '28/11/18' AS rideDate, 'cancled' AS status
	UNION
	SELECT 4 AS RID, 4 AS CabID,  22 AS CustID,  14 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 26		   AS price, 3 AS rating,  '30/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 5 AS RID, 6 AS CabID,  23 AS CustID,  15 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 9 		   AS price, 5 AS rating,  '29/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 6 AS RID, 4 AS CabID,  25 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 16.5   	   AS price, 3 AS rating,  '17/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 7 AS RID, 1 AS CabID,  27 AS CustID,  17 AS DriverID, 	1.08 AS distance, 'Northeastern University'  	AS destination, 'Back Bay'		 	AS origin, 10.5   	   AS price, 4 AS rating,  '26/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 8 AS RID, 8 AS CabID,  26 AS CustID,  18 AS DriverID,  	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 16.5   	   AS price, 5 AS rating,  '02/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 9 AS RID, 7 AS CabID,  26 AS CustID,  15 AS DriverID,	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 3		   AS price, 3 AS rating, '03/12/18' AS rideDate, 'cancled' AS status
), RatTip AS
(
SELECT 
	rd.RID AS RideNumber,
    rd.distance AS Distance,
    rd.destination AS Destination,
    rd.origin AS Origin,
	p.tip AS Tip,
	DENSE_RANK() OVER(ORDER BY p.tip DESC) AS RankByTip
FROM RideDetail rd
JOIN Payment AS p ON p.RID = rd.RID
)SELECT
	RideNumber,
    Distance,
    Destination,
    Origin,
	Tip,
    RankByTip
FROM RatTip
WHERE RankByTip < 5
GROUP BY
	RideNumber,
	Distance,
    Destination,
    Origin,
	Tip,
    RankByTip
ORDER BY Origin ASC;

# Output:
-- The output provides the trips by their tip ranking (top 5) for a given source and desination.
-- For example, Northeastern University to Back Bay has distance 1.08 miles and the customer has provided the highest tip $16 has over all rank 1 and second highest $3 tip has over all rank 4. 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 5
# Q5. Fetch the rout details and categorise the tip and rating into three major category Low, Moderate and High.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH Payment AS
(
	SELECT 1 AS PayID, 1 AS RID, 0.9 AS tax, 27.5	AS subtotal, '16/12/18' AS pay_date, 10 AS tip
	UNION
 	SELECT 2 AS PayID, 2 AS RID, 0.3 AS tax, 13.5	AS subtotal, '27/11/18' AS pay_date, 5  AS tip
 	UNION
 	SELECT 3 AS PayID, 3 AS RID, 0.2 AS tax, 7		AS subtotal, '28/11/18' AS pay_date, 0  AS tip
 	UNION
 	SELECT 4 AS PayID, 4 AS RID, 0.7 AS tax, 12		AS subtotal, '30/11/18' AS pay_date, 5  AS tip
 	UNION
 	SELECT 5 AS PayID, 5 AS RID, 0.3 AS tax, 16		AS subtotal, '29/11/18' AS pay_date, 2  AS tip
 	UNION
 	SELECT 6 AS PayID, 6 AS RID, 0.4 AS tax, 7.5	AS subtotal, '17/12/18' AS pay_date, 3  AS tip
 	UNION
 	SELECT 7 AS PayID, 7 AS RID, 0.6 AS tax, 7.5	AS subtotal, '26/11/18' AS pay_date, 3  AS tip
 	UNION
 	SELECT 8 AS PayID, 8 AS RID, 0.3 AS tax, 26		AS subtotal, '02/12/18' AS pay_date, 16 AS tip
 	UNION
 	SELECT 9 AS PayID, 9 AS RID, 0.2 AS tax, 5.5	AS subtotal, '03/12/18' AS pay_date, 0  AS tip
),  RideDetail AS
(
	SELECT 1 AS RID, 2 AS CabID,  23 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 5 		   AS price, 1 AS rating, '16/12/18'  AS rideDate, 'start' AS status 
	UNION
	SELECT 2 AS RID, 3 AS CabID,  21 AS CustID,  12 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 11		   AS price, 5 AS rating, '27/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 3 AS RID, 5 AS CabID,  24 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 7 		   AS price, 4 AS rating, '28/11/18' AS rideDate, 'cancled' AS status
	UNION
	SELECT 4 AS RID, 4 AS CabID,  22 AS CustID,  14 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 26		   AS price, 3 AS rating,  '30/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 5 AS RID, 6 AS CabID,  23 AS CustID,  15 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 9 		   AS price, 5 AS rating,  '29/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 6 AS RID, 4 AS CabID,  25 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 16.5   	   AS price, 3 AS rating,  '17/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 7 AS RID, 1 AS CabID,  27 AS CustID,  17 AS DriverID, 	1.08 AS distance, 'Northeastern University'  	AS destination, 'Back Bay'		 	AS origin, 10.5   	   AS price, 4 AS rating,  '26/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 8 AS RID, 8 AS CabID,  26 AS CustID,  18 AS DriverID,  	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 16.5   	   AS price, 5 AS rating,  '02/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 9 AS RID, 7 AS CabID,  26 AS CustID,  15 AS DriverID,	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 3		   AS price, 3 AS rating, '03/12/18' AS rideDate, 'cancled' AS status
), RatTip AS
(  
	SELECT 
			rd.RID AS Rout,
			rd.distance AS Distance,
			rd.destination AS Destination,
			rd.origin AS Origin,
			p.tip AS Tip,
		Case 
			WHEN p.tip=0 THEN "No Tip" 
			WHEN p.tip BETWEEN 1 AND 4 THEN "Low" 
			WHEN p.tip BETWEEN 5 AND 10 THEN "Moderate"
			WHEN p.tip BETWEEN 11 and 100 THEN "High" 
            END AS tip_group,
		Case 
			WHEN rd.rating IN (1,2) THEN "Low"
			WHEN rd.rating=3 THEN "Moderate"
			WHEN rd.rating IN (4,5) THEN "High" 
            END AS rating_group
	FROM RideDetail rd
	JOIN Payment AS p ON p.RID = rd.RID
)Select * from RatTip;

#Output: 
-- The result shows the list of different rout with it's tip group and rating group.
-- It can be interpreted that for the same distance customers are giving different tip and different rating based on other features like comfort of car, driver's behaviour , on time arrival and many more,

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 6
# Q6. Retrive the data which provides the cheapest price for the given location on a given day.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH Payment AS
(
	SELECT 1 AS PayID, 1 AS RID, 0.9 AS tax, 27.5	AS subtotal, '16/12/18' AS pay_date, 10 AS tip
	UNION
 	SELECT 2 AS PayID, 2 AS RID, 0.3 AS tax, 13.5	AS subtotal, '27/11/18' AS pay_date, 5  AS tip
 	UNION
 	SELECT 3 AS PayID, 3 AS RID, 0.2 AS tax, 7		AS subtotal, '28/11/18' AS pay_date, 0  AS tip
 	UNION
 	SELECT 4 AS PayID, 4 AS RID, 0.7 AS tax, 12		AS subtotal, '30/11/18' AS pay_date, 5  AS tip
 	UNION
 	SELECT 5 AS PayID, 5 AS RID, 0.3 AS tax, 16		AS subtotal, '29/11/18' AS pay_date, 2  AS tip
 	UNION
 	SELECT 6 AS PayID, 6 AS RID, 0.4 AS tax, 7.5	AS subtotal, '17/12/18' AS pay_date, 3  AS tip
 	UNION
 	SELECT 7 AS PayID, 7 AS RID, 0.6 AS tax, 7.5	AS subtotal, '26/11/18' AS pay_date, 3  AS tip
 	UNION
 	SELECT 8 AS PayID, 8 AS RID, 0.3 AS tax, 26		AS subtotal, '02/12/18' AS pay_date, 16 AS tip
 	UNION
 	SELECT 9 AS PayID, 9 AS RID, 0.2 AS tax, 5.5	AS subtotal, '03/12/18' AS pay_date, 0  AS tip
),  RideDetail AS
(
	SELECT 1 AS RID, 5 AS CabID,  23 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 5 		   AS price, 1 AS rating, '16/12/18'  AS rideDate, 'start' AS status 
	UNION
	SELECT 2 AS RID, 3 AS CabID,  21 AS CustID,  12 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 11		   AS price, 5 AS rating, '27/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 3 AS RID, 5 AS CabID,  24 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 7 		   AS price, 4 AS rating, '16/12/18' AS rideDate, 'cancled' AS status
	UNION
	SELECT 4 AS RID, 4 AS CabID,  22 AS CustID,  14 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 26		   AS price, 3 AS rating,  '30/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 5 AS RID, 6 AS CabID,  23 AS CustID,  15 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 9 		   AS price, 5 AS rating,  '29/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 6 AS RID, 4 AS CabID,  25 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 16.5   	   AS price, 3 AS rating,  '30/11/18' AS rideDate, 'start' AS status
	UNION
    SELECT 10 AS RID, 4 AS CabID,  25 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 66  	   AS price, 3 AS rating,  '30/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 7 AS RID, 7 AS CabID,  27 AS CustID,  17 AS DriverID, 	1.08 AS distance, 'Northeastern University'  	AS destination, 'Back Bay'		 	AS origin, 15   	   AS price, 4 AS rating,  '03/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 8 AS RID, 7 AS CabID,  26 AS CustID,  18 AS DriverID,  	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 22  	   AS price, 5 AS rating,  '03/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 9 AS RID, 7 AS CabID,  26 AS CustID,  15 AS DriverID,	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 13	   	   AS price, 3 AS rating, '03/12/18' AS rideDate, 'cancled' AS status
) 
SELECT 
	i.CabID AS CabNumber,
    i.destination AS Destination,
    i.origin AS Origin,
    i.rideDate AS RideDate,
    MIN(i.price)  AS Cheapest_Price
FROM RideDetail i
WHERE
price >
	(
    SELECT MIN(s.price)
	FROM RideDetail s
	LEFT JOIN RideDetail ss ON s.CabID = ss.CabID
    )
GROUP BY 
	CabNumber,
    Destination,
	Origin,
	RideDate;

#Output:
-- The data shows that the cab number 3 has the cheapest price $11 on 27th November 2018.

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 7
# Q7. Provide the Sales increase rate quarterly with cab category for the year 2018 and 2019.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH LyftSales AS
(
	SELECT 1  AS  CSID,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	'Q1'	AS quarter_number, 2018 AS calander_year, 32435 AS net_sale
	UNION
	SELECT 2  AS  CSID,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	'Q2'	AS quarter_number, 2018 AS calander_year, 54563 AS net_sale
	UNION
	SELECT 3  AS  CSID,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	'Q3'  	AS quarter_number, 2018 AS calander_year, 76734 AS net_sale
	UNION
	SELECT 4  AS  CSID,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	'Q1'	AS quarter_number, 2019 AS calander_year, 32435 AS net_sale
	UNION
	SELECT 5  AS  CSID,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	'Q2'	AS quarter_number, 2019 AS calander_year, 54563 AS net_sale
	UNION
	SELECT 6  AS  CSID,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	'Q3'  	AS quarter_number, 2019 AS calander_year, 76734 AS net_sale
	UNION
	SELECT 7  AS  CSID,		'lyft_premier' 	AS	product_name,	'Lux'			AS cab_name,	'Q1'	AS quarter_number, 2018 AS calander_year, 58745 AS net_sale
	UNION
	SELECT 8  AS  CSID,		'lyft_premier' 	AS	product_name,	'Lux'			AS cab_name,	'Q2'	AS quarter_number, 2018 AS calander_year, 89567 AS net_sale
	UNION
	SELECT 9  AS  CSID,		'lyft_premier' 	AS	product_name,	'Lux'			AS cab_name,	'Q3'	AS quarter_number, 2018 AS calander_year, 77554 AS net_sale
	UNION
	SELECT 10  AS  CSID,	'lyft_premier' 	AS	product_name,	'Lux'			AS cab_name,	'Q1'	AS quarter_number, 2019 AS calander_year, 58745 AS net_sale
	UNION
	SELECT 11  AS  CSID,	'lyft_premier' 	AS	product_name,	'Lux'			AS cab_name,	'Q2'	AS quarter_number, 2019 AS calander_year, 89567 AS net_sale
	UNION
	SELECT 12  AS  CSID,	'lyft_premier' 	AS	product_name,	'Lux'			AS cab_name,	'Q3'	AS quarter_number, 2019 AS calander_year, 77554 AS net_sale
	UNION
	SELECT 13  AS  CSID,	'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	'Q1'	AS quarter_number, 2018 AS calander_year, 57934 AS net_sale
	UNION
	SELECT 14  AS  CSID,	'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	'Q2'	AS quarter_number, 2018 AS calander_year, 76766 AS net_sale
	UNION
	SELECT 15  AS  CSID,	'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	'Q3'	AS quarter_number, 2018 AS calander_year, 65776 AS net_sale
	UNION
	SELECT 16  AS  CSID,	'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	'Q1'	AS quarter_number, 2019 AS calander_year, 57934 AS net_sale	
	UNION
	SELECT 17  AS  CSID,	'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	'Q2'	AS quarter_number, 2019 AS calander_year, 76766 AS net_sale
	UNION
	SELECT 18  AS  CSID,	'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	'Q3'	AS quarter_number, 2019 AS calander_year, 65776 AS net_sale
	UNION
	SELECT 19 AS  CSID,		'lyft_luxsuv'	AS	product_name,	'Lux Black XL' 	AS cab_name,	'Q1'	AS quarter_number, 2018 AS calander_year, 98956 AS net_sale
	UNION
	SELECT 20 AS  CSID,		'lyft_luxsuv'	AS	product_name,	'Lux Black XL' 	AS cab_name,	'Q2'	AS quarter_number, 2018 AS calander_year, 87868 AS net_sale
	UNION
	SELECT 21 AS  CSID,		'lyft_luxsuv'	AS	product_name,	'Lux Black XL' 	AS cab_name,	'Q3'	AS quarter_number, 2018 AS calander_year, 46454 AS net_sale
	UNION
	SELECT 22 AS  CSID,		'lyft_luxsuv'	AS	product_name,	'Lux Black XL' 	AS cab_name,	'Q1'	AS quarter_number, 2019 AS calander_year, 98956 AS net_sale
	UNION
	SELECT 23 AS  CSID,		'lyft_luxsuv'	AS	product_name,	'Lux Black XL' 	AS cab_name,	'Q2'	AS quarter_number, 2019 AS calander_year, 87868 AS net_sale
	UNION
	SELECT 24 AS  CSID,		'lyft_luxsuv'	AS	product_name,	'Lux Black XL' 	AS cab_name,	'Q3'	AS quarter_number, 2019 AS calander_year, 46454 AS net_sale
	UNION
	SELECT 25 AS  CSID,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	'Q1'	AS quarter_number, 2018 AS calander_year, 87874 AS net_sale
	UNION
	SELECT 26 AS  CSID,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	'Q2'	AS quarter_number, 2018 AS calander_year, 89000 AS net_sale
	UNION
	SELECT 27 AS  CSID,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	'Q3'	AS quarter_number, 2018 AS calander_year, 94540 AS net_sale
	UNION
	SELECT 28 AS  CSID,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	'Q1'	AS quarter_number, 2019 AS calander_year, 87874 AS net_sale
	UNION
	SELECT 29 AS  CSID,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	'Q2'	AS quarter_number, 2019 AS calander_year, 89000 AS net_sale
	UNION
	SELECT 30 AS  CSID,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	'Q3'	AS quarter_number, 2019 AS calander_year, 94540 AS net_sale
), SalesInfo AS
(
SELECT 
	i.calander_year AS Year,
	i.quarter_number AS Quarter,
    i.cab_name AS CabCategory,
	i.net_sale AS Net_Current_Sales,
	LAG(i.net_sale,1) OVER (PARTITION BY i.calander_year ORDER BY i.quarter_number) AS Previous_Quarter_Sales,
    LEAD(i.net_sale) OVER (PARTITION BY i.calander_year ORDER BY i.quarter_number) AS Next_Quarter_Sales
FROM 
	LyftSales i
)
SELECT 
    Year,
    Quarter,
    CabCategory,
    Net_Current_Sales,
    Previous_Quarter_Sales,
    Next_Quarter_Sales,
    IFNULL(CONCAT(ROUND((Net_Current_Sales - Previous_Quarter_Sales) / Previous_Quarter_Sales * 100,2),'%'),'') AS Sales_Increase_Rate
FROM
    SalesInfo;

#Output:
-- The output shows the sales increase rate by each quarter for given cab categories. 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 8 
# Q8. Get the running total of each payment made by customer by each date
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
SELECT P.PayID,
    P.pay_date,
    P.pay_amount, 
    (SELECT SUM(pay_amount) FROM Payment 
                          WHERE PayID <= P.PayID AND pay_date = P.pay_date)'Running Total' 
FROM Payment P
  ORDER BY PayID;

#Output: 
-- The table shows the payment dates and the amount with it's running total. The running total for three days(12th December to 14th December in the year 2018) is $39.0.

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 9 
# Q9. Provide the list of distance and prices with cab names which has passenger capacity 4.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH CabDetail AS
(
	SELECT 0 AS  CabID, 'Lyft' AS cab_type,		'lyft_line'	 	AS	product_name,	'Shared'		AS cab_name,	4 AS capacity
	UNION
	SELECT 1 AS  CabID, 'Lyft' AS cab_type,		'lyft_premier' 	AS	product_name,	'Lux'			AS cab_name,	5 AS capacity
	UNION
	SELECT 2 AS  CabID, 'Lyft' AS cab_type,		'lyft'		 	AS	product_name,	'Lyft'		 	AS cab_name,	4 AS capacity
	UNION
	SELECT 3 AS  CabID, 'Lyft' AS cab_type,		'lyft_luxsuv'	AS	product_name,	'Lux Black XL' 	AS cab_name,	4 AS capacity
	UNION
	SELECT 4 AS  CabID, 'Lyft' AS cab_type,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	6 AS capacity
	UNION
	SELECT 5 AS  CabID, 'Lyft' AS cab_type,		'lyft_lux'	 	AS	product_name,	'Lux Black'	 	AS cab_name,	4 AS capacity
	UNION
	SELECT 6 AS  CabID, 'Lyft' AS cab_type,		'lyft_plus'	 	AS	product_name,	'Lyft XL'		AS cab_name,	6 AS capacity
	UNION
	SELECT 7 AS  CabID, 'Lyft' AS cab_type,		'lyft_lux'	 	AS	product_name,	'Lux Black'	 	AS cab_name,	4 AS capacity
	UNION
	SELECT 8 AS  CabID, 'Lyft' AS cab_type,	  	'lyft_line'	 	AS	product_name,	'Shared'	 	AS cab_name,	4 AS capacity
    UNION
    SELECT 9 AS CabID, 'Uber' AS cab_type,      'UberX'         AS product_name,    'Shared' 		AS cab_name,	4 AS capacity
), RideDetail AS
(
	SELECT 1 AS RID, 2 AS CabID,  23 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 5 		   AS price, 1 AS rating, '16/12/18'  AS rideDate, 'start' AS status 
	UNION
	SELECT 2 AS RID, 3 AS CabID,  21 AS CustID,  12 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 11		   AS price, 5 AS rating, '27/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 3 AS RID, 5 AS CabID,  24 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 7 		   AS price, 4 AS rating, '28/11/18' AS rideDate, 'cancled' AS status
	UNION
	SELECT 4 AS RID, 4 AS CabID,  22 AS CustID,  14 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 26		   AS price, 3 AS rating,  '30/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 5 AS RID, 6 AS CabID,  23 AS CustID,  15 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 9 		   AS price, 5 AS rating,  '29/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 6 AS RID, 4 AS CabID,  25 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 16.5   	   AS price, 3 AS rating,  '17/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 7 AS RID, 1 AS CabID,  27 AS CustID,  17 AS DriverID, 	1.08 AS distance, 'Northeastern University'  	AS destination, 'Back Bay'		 	AS origin, 10.5   	   AS price, 4 AS rating,  '26/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 8 AS RID, 8 AS CabID,  26 AS CustID,  18 AS DriverID,  	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 16.5   	   AS price, 5 AS rating,  '02/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 9 AS RID, 7 AS CabID,  26 AS CustID,  15 AS DriverID,	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 3		   AS price, 3 AS rating, '03/12/18' AS rideDate, 'cancled' AS status
)
SELECT 
	c.cab_name,
    c.capacity,
    r.distance,
	r.price
From CabDetail c
JOIN RideDetail AS r ON r.CabID = c.CabID
WHERE capacity = 4
GROUP BY 
	cab_name,
    capacity,
    distance,
    price
ORDER BY 
	cab_name;

#Output:
-- The below list shows cab prices which has passenger capacity 4.
-- As we can observe, Lux Black XL has the highest price $11 for distance 0.44 miles. 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# QUERY 10 
# Q10. Count the number of rides requested on a single day by each customer and also prove their age group. 
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH CustomerDetail AS
(
	SELECT 21 AS CustID, 'Jennie' 	AS CName, 17 AS CAge, 'San Francisco' AS CAddress, 90004 AS PostalCode 
	UNION
	SELECT 22 AS CustID, 'Gertrude' AS CName, 34 AS CAge, 'Los Angeles'   AS CAddress, 90005 AS PostalCode 
	UNION
	SELECT 23 AS CustID, 'Julia'	AS CName, 25 AS CAge, 'Los Angeles'   AS CAddress, 94208 AS PostalCode 
	UNION
	SELECT 24 AS CustID, 'Hattie' 	AS CName, 34 AS CAge, 'Los Angeles'   AS CAddress, 90006 AS PostalCode 
	UNION
	SELECT 25 AS CustID, 'Edith' 	AS CName, 78 AS CAge, 'Sacramento'    AS CAddress, 95101 AS PostalCode 
	UNION
	SELECT 26 AS CustID, 'Mattie' 	AS CName, 45 AS CAge, 'Los Angeles'   AS CAddress, 92071 AS PostalCode 
	UNION
	SELECT 27 AS CustID, 'Rose' 	AS CName, 89 AS CAge, 'San Francisco' AS CAddress, 95101 AS PostalCode 
),  RideDetail AS
(
	SELECT 1 AS RID, 2 AS CabID,  21 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 5 		   AS price, 1 AS rating, '16/12/18'  AS rideDate, 'start' AS status 
	UNION
	SELECT 2 AS RID, 3 AS CabID,  23 AS CustID,  12 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 11		   AS price, 5 AS rating, '16/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 3 AS RID, 5 AS CabID,  22 AS CustID,  11 AS DriverID,  	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 7 		   AS price, 4 AS rating, '16/11/18' AS rideDate, 'cancled' AS status
	UNION
	SELECT 4 AS RID, 4 AS CabID,  24 AS CustID,  14 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 26		   AS price, 3 AS rating,  '16/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 5 AS RID, 6 AS CabID,  26 AS CustID,  15 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 9 		   AS price, 5 AS rating,  '16/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 6 AS RID, 4 AS CabID,  25 AS CustID,  11 AS DriverID, 	0.44 AS distance, 'North Station'			 	AS destination, 'Haymarket Square' 	AS origin, 16.5   	   AS price, 3 AS rating,  '16/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 7 AS RID, 1 AS CabID,  27 AS CustID,  17 AS DriverID, 	1.08 AS distance, 'Northeastern University'  	AS destination, 'Back Bay'		 	AS origin, 10.5   	   AS price, 4 AS rating,  '26/11/18' AS rideDate, 'start' AS status
	UNION
	SELECT 8 AS RID, 8 AS CabID,  21 AS CustID,  18 AS DriverID,  	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 16.5   	   AS price, 5 AS rating,  '16/12/18' AS rideDate, 'start' AS status
	UNION
	SELECT 9 AS RID, 7 AS CabID,  26 AS CustID,  15 AS DriverID,	1.08 AS distance, 'Northeastern University'		AS destination, 'Back Bay'		 	AS origin, 3		   AS price, 3 AS rating, '26/12/18' AS rideDate, 'cancled' AS status
)
SELECT 
		COUNT(rd.RID) AS Number_of_ride,
		c.CName,
		c.CAge,
        rd.rideDate,
	Case 
		WHEN c.CAge BETWEEN 12 AND 17 THEN "Teens" 
		WHEN c.CAge BETWEEN 18 AND 64 THEN "Adults" 
		WHEN c.CAge BETWEEN 65 AND 100 THEN "Elderly"
		END AS age_grouP 
FROM CustomerDetail c	
JOIN RideDetail rd ON rd.CustID = c.CustID
GROUP BY CName,CAge,rideDate
ORDER BY CAge;

#Output:
-- The table shows the number of ride requested by each customer on a given day with their age groups.
-- Customer Jennie has made two trips on 16th December 2018 and she falls under the age group of teens.
-- We can also use this data to analyze which age group people are using the cab service the most. 









