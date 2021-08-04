/*
Pragati Koladiya
FALL A 2020
ALY 6030
Assignment 1 
	Problem-1
Last Updated 09/22/2020
*/ 
--
-- 2.Creating schema in MYSQL workbench
--
CREATE SCHEMA `cars`;

CREATE TABLE `cars`.`Car_detail`(
	`Cars` VARCHAR(45) NOT NULL,
	`MPG` INT  NOT NULL,
	`Cylinders` INT  NOT NULL,
	`Displacement` INT NOT NULL,
	`Horsepower` VARCHAR(45) NOT NULL,
	`Weight` INT NOT NULL,
	`Acceleration` DECIMAL NOT NULL,
	`Model` VARCHAR(45)NOT NULL,
	`Origin` VARCHAR(45)NOT NULL);

-- -------------------------------------------------------------
/*Viewing entire table name "Car_detail" */
-- -------------------------------------------------------------
SELECT 
	* 
FROM `cars`.`Car_detail`;

-- --------------------------------------------------------
/* Q1. What is the count of cars by distinct models? */
-- --------------------------------------------------------
SELECT 
	DISTINCT Model, 
    COUNT(Cars) AS Count_of_cars 
FROM Car_detail 
GROUP BY Model;
/* => There are 13 unique car model among those the maximum number of cars belongs to model 73 with cars count 40. */

-- --------------------------------------------------------
/*Q2. List count of cars by distinct origin.*/
-- --------------------------------------------------------
SELECT 
	DISTINCT(Origin) AS Distinct_origin, 
    COUNT(Cars) AS Car_Count 
FROM Car_detail 
GROUP BY Origin;
/* => There are mainly three origin US, Europe and Japan. US has the maximum number of cars among all the origin which is 254 in total. */

-- --------------------------------------------------------
/* Q3. What is the count of car which has more than one cylinder? */
-- --------------------------------------------------------
SELECT 
	Cylinders, 
	COUNT(Cars) AS Number_of_cars 
FROM Car_detail 
GROUP BY Cylinders 
HAVING Cylinders>1 ;
/* The maximum number of cars has 4 cylinder and the second most is with 8-cylinder car whereas 3 and 5 cylinder cars the list popular..*/

-- --------------------------------------------------------
/* Q4. Give a list of models with maximum cylinders and an engine with highest horsepower along with high MPG. */
-- --------------------------------------------------------
SELECT 
	Model, 
    Cylinders, 
    AVG(Horsepower) 
FROM Car_detail 
GROUP BY Model,Clinders;
/*=> The model 70 with cylinders 8 has the highest average horsepower among 13 different models.*/

-- --------------------------------------------------------
/* Q5. Provide a list of unique models with average MPG (Mileage Per Gallon). */
-- --------------------------------------------------------
SELECT 
	DISTINCT(Model), 
    AVG(MPG) AS avg_mpg  
FROM Car_detail 
GROUP BY Model 
ORDER BY avg_mpg DESC;
/*=> The model 80 has the highest average mileage per gallon,33.69. */

-- --------------------------------------------------------
/*Q6. Provide a list of cars which has origin 'US', average horsepower and MPG from highest to lowest. */
-- --------------------------------------------------------
SELECT 
	Cars, 
    Origin, 
    AVG(Horsepower) as avg_hp, 
    AVG(MPG) as avg_mpg 
FROM Car_detail 
WHERE Origin IN ('US') 
GROUP BY Cars, Origin
ORDER BY avg_hp DESC;
/*=> The above table shows the cars from US. They have highest to lowest order of average MPG. */

-- --------------------------------------------------------
/*Q7. List the name of cars which has origin US and their MPG should be more than 10 with weight less than 3000 */
-- --------------------------------------------------------
SELECT 
	Cars,
    MPG,
    Weight,
    Origin 
FROM Car_detail 
WHERE MPG>10 AND Weight < 3000 AND Origin='US';
/*=> There are 91 records which show cars from the US. Their MPG is more than 10 and weight is less than 3000.
  => Most cars have MPG above 10.
*/


-- --------------------------------------------------------
/*Q8, List the cars with maximum acceleration and horsepower but minimum weight */
-- --------------------------------------------------------
SELECT 
	Cars, 
    MAX(Acceleration) AS Max_Acceleration, 
    MIN(Weight)AS Min_Weight, 
    MAX(Horsepower) AS Max_Horsepower 
FROM Car_detail 
WHERE MPG BETWEEN 0 AND 35 
GROUP BY Cars 
ORDER BY Max_Acceleration DESC;
/*=>The speed of a car is high if acceleration and horsepower are high. But the weight is inversely proportional to its velocity.  
Lower the weight of the car better the speed. According to the given data Peugeot 504 is a high-speed car. 
*/


-- --------------------------------------------------------
/*Q9. What is the average displacement by origin? */
-- --------------------------------------------------------
SELECT 
	Origin, 
    Avg(Displacement) AS Average_Displacement
FROM Car_detail
GROUP BY Origin;
/*=> The average displacement is highest in the US cars whereas Japan has the lowest displacement of 102.71. */

