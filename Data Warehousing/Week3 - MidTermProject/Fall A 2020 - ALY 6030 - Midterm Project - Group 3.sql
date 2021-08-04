/* Group 3: Sijie Wang, Na Qian, Chunlu Zhu, Pragati Koladiya
Fall A 2020
ALY 6030
Midterm Project
Last updated: 10/12/2020 */

CREATE DATABASE `yelp`;

USE yelp;

CREATE TABLE `yelp`.`DimDate` (
  `DateKey`  VARCHAR(8) NOT NULL,
  `CalendarDate` DATE DEFAULT NULL,
  `MonthNumber` INT DEFAULT NULL,
  `CalendarQuarter` INT DEFAULT NULL,
  `CalendarYear` INT DEFAULT NULL,
  `DayOfWeek` INT DEFAULT NULL,
  `DayOfWeekName` VARCHAR(40) DEFAULT NULL,
  `DayOfYear` INT DEFAULT NULL,
  PRIMARY KEY (`DateKey`)
) ;

CREATE TABLE `yelp`.`DimStore` (
  `StoreKey`  VARCHAR(8) NOT NULL,
  `StoreName` VARCHAR(255) DEFAULT NULL,
  `StoreType` VARCHAR(40) DEFAULT NULL,
  `City` VARCHAR(255) DEFAULT NULL,
  `State` VARCHAR(40) DEFAULT NULL,
  `StorePostalCode` INT DEFAULT NULL,
  `StoreYelpSince` INT DEFAULT NULL,
  `AveragePricePerPerson` DECIMAL(10,4) DEFAULT NULL,
  `IsDelivery` BOOLEAN DEFAULT NULL,
  `IsTakeOut` BOOLEAN DEFAULT NULL, 
  `IsDineIn` BOOLEAN DEFAULT NULL,
  `OpenTime` TIME DEFAULT NULL,
  `CloseTime` TIME DEFAULT NULL,
  PRIMARY KEY (`StoreKey`)
) ;

CREATE TABLE `yelp`.`DimUsers` (
  `UserKey`  VARCHAR(24) NOT NULL,
  `UserName` VARCHAR(40) NOT NULL,
  `UserYelpSince` VARCHAR(24) DEFAULT NULL,
  `ActiveInd` VARCHAR(24) DEFAULT NULL,
  `OldAddress` TEXT DEFAULT NULL,
  `OldCity` TEXT DEFAULT NULL,
  `CurrentAddress` TEXT NOT NULL,
  `CurrentCity` TEXT NOT NULL,
  `OldUserPostalCode` TEXT,
  `CurrentUserPostalCode` TEXT NOT NULL,
  PRIMARY KEY (`UserKey`),
  FOREIGN KEY (UserYelpSince) REFERENCES DimDate(DateKey),
  FOREIGN KEY (ActiveInd) REFERENCES DimDate(DateKey) 
) ;

CREATE TABLE `yelp`.`DimAdvertisementType` (
  `AdTypeKey`  INT NOT NULL,
  `AdTypeName` VARCHAR(80) DEFAULT NULL,
  `AdTypeDescription` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`AdTypeKey`)
) ;


CREATE TABLE `yelp`.`FactReviews` (
  `ReviewKey`  VARCHAR(24) NOT NULL,
  `StoreKey` VARCHAR(24) NOT NULL,
  `DateKey` VARCHAR(24) NOT NULL,
  `UserKey` VARCHAR(24) NOT NULL,
  `RatingValue` DECIMAL(10,4) DEFAULT NULL,
  `Useful` INT DEFAULT NULL,
  `Funny` INT DEFAULT NULL,
  `Cool` INT DEFAULT NULL,
  `Image` VARCHAR(19) DEFAULT NULL,
  PRIMARY KEY (`ReviewKey`),
  FOREIGN KEY (StoreKey) REFERENCES DimStore(StoreKey),
  FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
  FOREIGN KEY (UserKey) REFERENCES DimUsers(UserKey)
  ) ;


CREATE TABLE `yelp`.`FactAdvertisement` (
  `AdKey`  VARCHAR(25) NOT NULL,
  `DateKey` VARCHAR(25) NOT NULL,
  `StoreKey` VARCHAR(25) NOT NULL,
  `AdTypeKey` INT NOT NULL,
  `AdvertisingPrice` BIGINT NOT NULL,
  PRIMARY KEY (`AdKey`),
  FOREIGN KEY (StoreKey) REFERENCES DimStore(StoreKey),
  FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
  FOREIGN KEY (AdTypeKey) REFERENCES DimAdvertisementType(AdTypeKey)
) ;


CREATE TABLE `yelp`.`FactDelivery` (
  `DeliveryKey`  VARCHAR(24) NOT NULL,
  `StoreKey` VARCHAR(24) NOT NULL,
  `DateKey` VARCHAR(24) NOT NULL,
  `UserKey` VARCHAR(24)  NOT NULL,
  `DeliveryItem` INT DEFAULT NULL,
  `TotalAmount` DECIMAL(10,4) DEFAULT NULL,
  `DeliveryFees` DECIMAL(10,4) DEFAULT NULL,
  `ServiceFee` DECIMAL(10,4) DEFAULT NULL,
  `ETA(min)` INT DEFAULT NULL,
  `CreditCardTransactionFees` DECIMAL(10,4) DEFAULT NULL, 
  PRIMARY KEY (`DeliveryKey`),
  FOREIGN KEY (StoreKey) REFERENCES DimStore(StoreKey),
  FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
  FOREIGN KEY (UserKey) REFERENCES DimUsers(UserKey)
) ;

CREATE TABLE `yelp`.`FactIncomeStatement` (
  `ISKey`  VARCHAR(25) NOT NULL,
  `AccountName` VARCHAR(255) NOT NULL,
  `AccountType` VARCHAR(255) NOT NULL,
  `DateKey` VARCHAR(25) NOT NULL,
  `Amount` BIGINT DEFAULT NULL,
  PRIMARY KEY (`ISKey`),
  FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey)
) ;


/* Q1: Recommend to a reviewer (Mary) three restaurants with the highest average ratings 
under the same store type as the restaurant for which she wrote a recent review on Yelp 
in the same city.*/
SELECT s.StoreName, s.StoreType, s.City, s.State, 
s.StorePostalCode, s.IsDelivery, s.IsTakeOut, s.IsDineIn, s.OpenTime, s.CloseTime, AVG(r.RatingValue) AS AverageRatingValue
FROM FactReviews AS r
INNER JOIN DimDate AS d
ON r.DateKey = d.DateKey
INNER JOIN DimStore AS s
ON r.StoreKey = s.StoreKey
INNER JOIN DimUsers AS u
ON r.UserKey = u.UserKey
INNER JOIN
(SELECT s.StoreType, s.City
FROM FactReviews AS r
INNER JOIN DimDate AS d
ON r.DateKey = d.DateKey
INNER JOIN DimStore AS s
ON r.StoreKey = s.StoreKey
INNER JOIN DimUsers AS u
ON r.UserKey = u.UserKey
WHERE u.UserName = "Mary"
ORDER BY d.CalendarDate
LIMIT 1) AS A
ON A.StoreType = s.StoreType AND
A.City = s.City
GROUP BY s.StoreName, s.StoreType, s.City, s.State, 
s.StorePostalCode, s.IsDelivery, s.IsTakeOut, s.IsDineIn, s.OpenTime, s.CloseTime
ORDER BY AverageRatingValue DESC
LIMIT 3;

/*Q2: In order to know whether our advertisement products are valuable, 
create a report for average advertisement fees paid by restaurants, 
average delivery amounts and average review rating values by restaurants with different advertisement spending buckets. */

SELECT C.AD_SPENDING_BUCKET, AVG(C.TotalAdSpending) AS AverageAdSpending, 
AVG(C.TotalOrderAmount) AS AverageOrderAmount, AVG(C.AverageRating) AS Avg_rating
FROM
(SELECT 
CASE
	WHEN B.RankAdSpending >=1 AND B.RankAdSpending <=15 THEN '1-15'
    WHEN B.RankAdSpending >=16 AND B.RankAdSpending <=30 THEN '16-30'
    WHEN B.RankAdSpending >=31 AND B.RankAdSpending <=45 THEN '31-45'
    WHEN B.RankAdSpending >=46 AND B.RankAdSpending <=60 THEN '46-60'
    WHEN B.RankAdSpending >=61 AND B.RankAdSpending <=75 THEN '61-75'
    WHEN B.RankAdSpending >=76 AND B.RankAdSpending <=90 THEN '76-90'
    WHEN B.RankAdSpending >=91 AND B.RankAdSpending <=105 THEN '91-105'
    ELSE '106-123'
END AS AD_SPENDING_BUCKET,
B.StoreName, B.TotalAdSpending, B.TotalOrderAmount, B.AverageRating
FROM
(SELECT A.StoreName, A.TotalAdSpending, A.TotalOrderAmount, A.AverageRating, RANK() OVER (ORDER BY A.TotalAdSpending DESC) AS RankAdSpending
FROM
(SELECT s.StoreName, SUM(a.AdvertisingPrice) AS TotalAdSpending, SUM(dl.TotalAmount) AS TotalOrderAmount, AVG(r.RatingValue) AS AverageRating
FROM FactReviews AS r
INNER JOIN DimDate AS d
ON r.DateKey = d.DateKey
INNER JOIN DimStore AS s
ON r.StoreKey = s.StoreKey
INNER JOIN DimUsers AS u
ON r.UserKey = u.UserKey
INNER JOIN FactDelivery AS dl
ON r.StoreKey = dl.StoreKey
INNER JOIN FactAdvertisement AS a
ON r.StoreKey = a.StoreKey
GROUP BY s.StoreName) AS A) AS B) AS C
GROUP BY C.AD_SPENDING_BUCKET
ORDER BY AverageAdSpending DESC;

/*Q3: Yelp wants to know what type of stores bought most of the ads for each type of advertisement 
so that it can recommend that type of advertisement to those stores with the same store type on Yelp Platform. 
Create a report for average advertising fees and number of stores by advertisement types and store types 
and do the recommendation to those stores with the same store type on Yelp Platform. */

/* Find store type(s) bought most of ads for each type of advertisement. */
CREATE TABLE MostPopular
SELECT*
FROM
(SELECT A.AdTypeName, A.StoreType, A.Numberofstores, A.AverageAdSpending, 
RANK () OVER (PARTITION BY A.AdTypeName ORDER BY A.AverageAdSpending DESC) AS RankAdsSpending
FROM
(SELECT ad.AdTypeName, s.StoreType, COUNT(s.StoreName) AS Numberofstores, AVG(a.AdvertisingPrice) AS AverageAdSpending
FROM FactAdvertisement AS a
INNER JOIN DimAdvertisementType AS ad
ON ad.AdTypeKey = a.AdTypeKey
INNER JOIN DimStore AS s
ON a.StoreKey = s.StoreKey
GROUP BY ad.AdTypeName, s.StoreType
ORDER BY ad.AdTypeName, AverageAdSpending DESC) AS A) AS B
WHERE B.RankAdsSpending = "1";

/*Recommendation to those stores with the same store type.*/
SELECT DISTINCT s.StoreType, s.StoreName, p.AdTypeName
FROM FactAdvertisement AS ad
INNER JOIN DimAdvertisementType AS t
ON ad.AdTypeKey = t.AdTypeKey
INNER JOIN DimStore AS s
ON ad.StoreKey = s.StoreKey
INNER JOIN MostPopular AS p
ON s.StoreType = p.StoreType
ORDER  BY s.StoreType;



/*Q4: Yelp cares about the most active users. 
Recommend 3 the cheapest restaurants to 1 of 10 users who are the most active users (give the most of reviews) on Yelp. 
These 3 restaurants should have similar average prices per person (+$3 or -$3) 
comparing with the average prices per person for those restaurants that they wrote the reviews. 
Note that we only choose one person as an example to do the recommendation.*/

/* Find top 10 most active users */
SELECT u.UserName, COUNT(r.RatingValue) AS Count_Reviews, AVG(s.AveragePricePerPerson) AS AVGPrice_Review
FROM FactReviews AS r
INNER JOIN DimUsers AS u
ON r.UserKey = u.UserKey
INNER JOIN DimStore AS s
ON r.StoreKey = s.StoreKey
GROUP BY u.UserName
ORDER BY Count_Reviews DESC
LIMIT 10;

/*For example, we recommend three cheapest restaurants for Margery. She reviewed 4 restaurants with average price of $62.155 per person. 
Note that we show the open and close time and other features related to these 3 restaurants.*/
SELECT StoreName, AveragePricePerPerson, IsDelivery, IsTakeOut, IsDineIn, OpenTime, CloseTime
FROM DimStore AS s
WHERE AveragePricePerPerson >= 62.155 - 3 AND
AveragePricePerPerson <= 62.155 + 3
ORDER BY AveragePricePerPerson ASC
LIMIT 3;

/*Q5: Yelp also wants to evaluate users engagement each year. 
Create a report for the total number of responses (useful, funny, and cool) for reviews 
by groups of rating values in each year. */
SELECT B.CalendarYear, B.RatingValue_Bucket,SUM(B.Useful) AS Sum_Useful, SUM(B.Funny) AS Sum_Funny, SUM(B.Cool) AS Sum_Cool
FROM
(SELECT A.CalendarYear, 
CASE
	WHEN A.RatingValue >=0 AND A.RatingValue <1 THEN '0-1'
	WHEN A.RatingValue >=1 AND A.RatingValue <2 THEN '1-2'
    WHEN A.RatingValue >=2 AND A.RatingValue <3 THEN '2-3'
    WHEN A.RatingValue >=3 AND A.RatingValue <4 THEN '3-4'
    ELSE '4-5'
END AS RatingValue_Bucket,
A.Useful, A.Funny, A.Cool
FROM
(SELECT d.CalendarYear, r.RatingValue, r.Useful, r.Funny, r.Cool
FROM FactReviews AS r
INNER JOIN DimDate AS d
ON r.DateKey = d.DateKey) AS A) AS B
GROUP BY B.CalendarYear, B.RatingValue_Bucket
ORDER BY B.CalendarYear;

/* Q6: Create a report for each type of advertisement by unit price, sold unit, and total revenue for each year. 
Note that advertisement prices are changing every year, but price for same type of advertisement should be same in one year.*/

WITH AdPriceByYear AS
(
SELECT DISTINCT
    CalendarYear, AdTypeName, AdvertisingPrice
FROM
    DimDate AS dd
        JOIN
    FactAdvertisement AS fa ON dd.DateKey = fa.DateKey
        JOIN
    DimAdvertisementType AS da ON da.AdTypeKey = fa.AdTypeKey)
SELECT * FROM
(SELECT 
    dd.CalendarYear,
    da.AdTypeName,
    aby.AdvertisingPrice AS UnitPrice,
    ROUND(SUM(fa.AdvertisingPrice) / aby.AdvertisingPrice,
            0) AS SoldUnit,
    SUM(fa.AdvertisingPrice) AS TotalRevenue

FROM
    DimDate AS dd
        JOIN
    FactAdvertisement AS fa ON dd.DateKey = fa.DateKey
        JOIN
    DimAdvertisementType AS da ON da.AdTypeKey = fa.AdTypeKey
        JOIN
    AdPriceByYear AS aby ON aby.CalendarYear = dd.CalendarYear
        AND aby.AdTypeName = da.AdTypeName
GROUP BY dd.CalendarYear, da.AdTypeName, aby.AdvertisingPrice) AS A
ORDER BY A.CalendarYear, A.TotalRevenue DESC;

/* Q7: What are Yelp's annual profits from 2015 to 2019? What is the annual profit growth rate for each year? */
WITH YearlyProfit AS(
SELECT 
    CalendarYear, SUM(Amount) AS Profit
FROM
    FactIncomeStatement AS fis
        JOIN
    DimDate AS dd ON fis.DateKey = dd.DateKey
WHERE
    AccountType = 'Profit'
GROUP BY CalendarYear),
LagYearlyProfit AS(
SELECT 
    CalendarYear, 
    Profit,
    LAG(Profit) OVER(ORDER BY CalendarYear) AS PreviousProfit
FROM 
    YearlyProfit)
SELECT 
    CalendarYear,
    Profit,
    IFNULL(CONCAT(ROUND((Profit - PreviousProfit) / PreviousProfit * 100,2),'%'),'') AS ProfitIncreaseRate
FROM
    LagYearlyProfit;
    

/* Q8: What are the top three cities that users order delivery the most?
How many stores offer delivery service in those cities? 
Find the average number of stores that offer delivery for all cities?*/
WITH DeliveryStore AS(
SELECT 
    City, COUNT(IsDelivery) AS NumOfferDeliveryStore,
    ROUND(AVG(COUNT(IsDelivery)) OVER(),0) AS AvgOfferDeliveryStore
FROM 
    DimStore
GROUP BY City),
DeliveryOrder AS
(SELECT  
     City, 
     COUNT(City) AS NumOfDeliveryOrder,
     RANK() OVER(ORDER BY COUNT(City) DESC) AS OrderRank
FROM
    DimStore AS dd 
        JOIN
	FactDelivery AS fd ON dd.StoreKey=fd.StoreKey
GROUP BY City)
SELECT 
    DeliveryStore.City,
    NumOfDeliveryOrder,
    NumOfferDeliveryStore,
    AvgOfferDeliveryStore
FROM
    DeliveryStore
        JOIN
    DeliveryOrder ON DeliveryStore.City = DeliveryOrder.City
WHERE
    OrderRank IN (1 , 2, 3);

/*Q9: In each city, which store type has the most reviews?
In each city, which store type has the highest rating?*/

WITH HighestReviewCount AS
(SELECT 
    City,
    COUNT(fr.StoreKey) AS NumOfReview,
    StoreType AS MostReviewStoreType,
    RANK() OVER(PARTITION BY City ORDER BY COUNT(fr.StoreKey) DESC) AS NumOfReviewRank
FROM 
    DimStore AS ds 
        JOIN 
	FactReviews AS fr ON ds.StoreKey=fr.StoreKey
GROUP BY City,StoreType),
HighestRating AS(
SELECT 
    City, 
    StoreType AS HighestRatingStoreType,
    ROUND(AVG(RatingValue),2) AS AvgRating,
	RANK() OVER(PARTITION BY City ORDER BY AVG(RatingValue) DESC) AS RatingRank
FROM 
    DimStore AS ds 
        JOIN 
	FactReviews fr ON ds.StoreKey=fr.StoreKey
GROUP BY City,StoreType)
SELECT 
    rc.City,
    MostReviewStoreType,
    NumOfReview,
    HighestRatingStoreType,
    AvgRating
FROM
    HighestReviewCount AS rc
        JOIN
    HighestRating r ON rc.City = r.City
WHERE
    NumOfReviewRank = 1 AND RatingRank = 1
ORDER BY MostReviewStoreType , HighestRatingStoreType;

/* Q10: The average store rating is divided into three groups, High Rating, Median Rating,
and Low Rating. 
How many delivery orders are made for each group? 
What is the average price per person of each group?*/

WITH StoreRating As(
SELECT 
    StoreKey,
    AVG(RatingValue) AS AvgRating,
    CASE
        WHEN
            AVG(RatingValue) >= 0
                AND AVG(RatingValue) < 3.0
        THEN
            'LowRating(less than 3)'
        WHEN
            AVG(RatingValue) >= 3.0
                AND AVG(RatingValue) < 4
        THEN
            'MedianRating(3-4)'
        ELSE 'HighRating(Equal to or Greater than 4)'
    END AS Rating
FROM
    FactReviews
GROUP BY StoreKey)
SELECT 
    Rating,
    COUNT(DeliveryKey) AS OrderCount,
    ROUND(AVG(AveragePricePerPerson), 2) AS AvePricePerPerson
FROM
    FactDelivery
        LEFT JOIN
    StoreRating ON FactDelivery.StoreKey = StoreRating.StoreKey
        JOIN
    DimStore ON DimStore.StoreKey = StoreRating.StoreKey
GROUP BY Rating;


/*Time series for advertising revenue forcasting*/
CREATE TABLE Monthly_Revenue
SELECT CONCAT(A.CalendarYear, "-", A.MonthName) AS YearMonth, SUM(A.AdvertisingPrice) AS TotalAdvertisingAmount
FROM
(SELECT d.CalendarYear,
CASE
	WHEN d.MonthNumber = 1 THEN '01'
    WHEN d.MonthNumber = 2 THEN '02'
    WHEN d.MonthNumber = 3 THEN '03'
    WHEN d.MonthNumber = 4 THEN '04'
    WHEN d.MonthNumber = 5 THEN '05'
    WHEN d.MonthNumber = 6 THEN '06'
    WHEN d.MonthNumber = 7 THEN '07'
    WHEN d.MonthNumber = 8 THEN '08'
    WHEN d.MonthNumber = 9 THEN '09'
	WHEN d.MonthNumber = 10 THEN '10'
	WHEN d.MonthNumber = 11 THEN '11'
    ELSE '12'
END AS MonthName, a.AdvertisingPrice
FROM FactAdvertisement AS a
INNER JOIN Dimdate AS d
ON a.DateKey = d.Datekey) AS A
GROUP BY YearMonth
ORDER BY YearMonth;