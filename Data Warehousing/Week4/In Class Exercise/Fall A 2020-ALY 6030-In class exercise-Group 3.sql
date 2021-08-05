/* Group 3: Sijie Wang, Na Qian, Chunlu Zhu, Pragati Koladiya
Fall A 2020
ALY 6030
In class exercise
Last updated: 09/16/2020 */

/* 1NF (First Normal Form) */
/* Create the schema */
CREATE SCHEMA `database`;

DROP TABLE IF EXISTS `database`.`full_table`;
DROP TABLE IF EXISTS `database`.`owner_info`;
DROP TABLE IF EXISTS `database`.`vehicle_info`;
DROP TABLE IF EXISTS  `database`.`maintenance_info`;

/* Notice that we assume that each customer may has more than 1 car to normalize the data and to answer all four questions. */
/* 1NF */
/* Create table */
CREATE TABLE `database`.`full_table` (
  `VEHICLE_OWNER_ID` INT NOT NULL,
  `VEHICLE_COLOR` VARCHAR(45) NOT NULL,
  `VEHICLE_TYPE` VARCHAR(45) NOT NULL,
  `VEHICLE_AGE` INT NOT NULL,
  `VEHICLE_OWNER` VARCHAR(45) NOT NULL,
  `MAINTENANCE_DATE` DATE NOT NULL,
  `PROCEDURE` VARCHAR(45) NOT NULL);
  
/* Insert values */
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('3515', 'RED', 'CAR', '4', 'Marissa Jones', '2019-06-10', '01- Oil Change');
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('3515', 'RED', 'CAR', '4', 'Marissa Jones', '2019-03-06', '10 - Brakes');
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('3515', 'RED', 'CAR', '4', 'Marissa Jones', '2019-03-03', '05 - Radiator Service');
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('3827', 'WHITE', 'TRUCK', '3', 'Liam Neeson', '2019-02-21', '08 - Broken Windshield');
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('3827', 'WHITE', 'TRUCK', '3', 'Liam Neeson', '2019-01-23', '05 - Radiator Service');
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('4649', 'BLACK', 'LIMOUSINE', '8', 'Roger Gupta', '2019-04-09', '01- Oil Change');
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('4649', 'BLACK', 'LIMOUSINE', '8', 'Roger Gupta', '2019-01-19', '01- Oil Change');
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('4876', 'GRAY', 'CAR', '1', 'Diego Minh Vu', '2019-05-12', '20 - Annual Check Up');
INSERT INTO `database`.`full_table` (`VEHICLE_OWNER_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER`, `MAINTENANCE_DATE`, `PROCEDURE`) VALUES ('4876', 'GRAY', 'CAR', '1', 'Diego Minh Vu', '2019-05-22', '12 - Battery Replacement');

/* 2NF and 3NF (Second and Third Normal Form) */
/* Create table */
CREATE TABLE `database`.`owner_info` (
  `VEHICLE_OWNER_ID` INT NOT NULL,
  `VEHICLE_OWNER` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`VEHICLE_OWNER_ID`));
  
/* Insert values */
INSERT INTO `database`.`owner_info` (`VEHICLE_OWNER_ID`, `VEHICLE_OWNER`) VALUES ('3515', 'Marissa Jones');
INSERT INTO `database`.`owner_info` (`VEHICLE_OWNER_ID`, `VEHICLE_OWNER`) VALUES ('3827', 'Liam Neeson');
INSERT INTO `database`.`owner_info` (`VEHICLE_OWNER_ID`, `VEHICLE_OWNER`) VALUES ('4649', 'Roger Gupta');
INSERT INTO `database`.`owner_info` (`VEHICLE_OWNER_ID`, `VEHICLE_OWNER`) VALUES ('4876', 'Diego Minh Vu');

/* Create table */
CREATE TABLE `database`.`vehicle_info` (
  `VEHICLE_ID` INT NOT NULL,
  `VEHICLE_COLOR` VARCHAR(45) NOT NULL,
  `VEHICLE_TYPE` VARCHAR(45) NOT NULL,
  `VEHICLE_AGE` VARCHAR(45) NOT NULL,
  `VEHICLE_OWNER_ID` INT NOT NULL,
  PRIMARY KEY (`VEHICLE_ID`),
  FOREIGN KEY (`VEHICLE_OWNER_ID`) REFERENCES `database`.`owner_info`(`VEHICLE_OWNER_ID`));
  
/* Insert values */
INSERT INTO `database`.`vehicle_info` (`VEHICLE_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER_ID`) VALUES ('101', 'RED', 'CAR', '4', '3515');
INSERT INTO `database`.`vehicle_info` (`VEHICLE_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER_ID`) VALUES ('102', 'WHITE', 'TRUCK', '3', '3827');
INSERT INTO `database`.`vehicle_info` (`VEHICLE_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER_ID`) VALUES ('103', 'BLACK', 'LIMOUSINE', '8', '4649');
INSERT INTO `database`.`vehicle_info` (`VEHICLE_ID`, `VEHICLE_COLOR`, `VEHICLE_TYPE`, `VEHICLE_AGE`, `VEHICLE_OWNER_ID`) VALUES ('104', 'GRAY', 'CAR', '1', '4876');

/* Create table */
CREATE TABLE `database`.`maintenance_info` (
  `VEHICLE_ID` INT NOT NULL,
  `MAINTENANCE_DATE` DATE NOT NULL,
  `PROCEDURE_CODE` INT NOT NULL,
  `PROCEDURE_NAME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`),
  FOREIGN KEY (`VEHICLE_ID`) REFERENCES `database`.`vehicle_info`(`VEHICLE_ID`));

/* Insert values */
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('101', '2019-06-10', '01', 'OIL CHANGE');
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('101', '2019-03-06', '10', 'BREAKS');
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('101', '2019-03-03', '05', 'RADIATOR SERVICE');
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('102', '2019-02-21', '08', 'BROKEN WINDSHIELD');
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('102', '2019-01-23', '05', 'RADIATOR SERVICE');
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('103', '2019-04-09', '01', 'OIL CHANGE');
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('103', '2019-01-19', '01', 'OIL CHANGE');
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('104', '2019-05-12', '20', 'ANNUAL CHECK UP');
INSERT INTO `database`.`maintenance_info` (`VEHICLE_ID`, `MAINTENANCE_DATE`, `PROCEDURE_CODE`, `PROCEDURE_NAME`) VALUES ('104', '2019-05-22', '12', 'BATTERY REPLACEMENT');

/* Q1: Most common vehicle type amongest the customers */
SELECT * FROM 
(SELECT VEHICLE_TYPE, COUNT(DISTINCT VEHICLE_OWNER_ID) AS NUM_OWNERS 
FROM vehicle_info
GROUP BY VEHICLE_TYPE) AS A 
ORDER BY A.NUM_OWNERS DESC;
/* Most common vehicle type amongest the customers is Car. Two people own this vehicle type (car). */

/* Q2: The least popular vehicle color */
SELECT * FROM   
(SELECT VEHICLE_COLOR, COUNT(DISTINCT VEHICLE_OWNER_ID) AS NUM_OWNERS   
FROM vehicle_info
GROUP BY VEHICLE_COLOR) AS A   
ORDER BY A.NUM_OWNERS ASC;
/* There is no least popular vehicle color. There is only 1 car of each color. */

/* Q3: The average vehicle age */
SELECT AVG (VEHICLE_AGE)  
FROM vehicle_info;
/*The average vehicle age is 4 years.*/

/* Q4: A frequency report for the count of cars by age group */
SELECT AGE_BUCKET, COUNT(DISTINCT VEHICLE_ID) AS NUM_CARS 
FROM 
(SELECT VEHICLE_ID, 
CASE
  WHEN VEHICLE_AGE >= 0 AND VEHICLE_AGE<2 THEN '0-2'
  WHEN VEHICLE_AGE >= 2 AND VEHICLE_AGE<4 THEN '2-4'
  WHEN VEHICLE_AGE >= 4 AND VEHICLE_AGE<6 THEN '4-6'
  WHEN VEHICLE_AGE >= 6 AND VEHICLE_AGE<8 THEN '6-8'
  ELSE '>=8'
END AS AGE_BUCKET 
FROM vehicle_info) AS B 
GROUP BY B.AGE_BUCKET;
/* This is a requency report for the count of cars by age group. We devided all ages into five age groups (buckets). */
/* Each age group has one car. */