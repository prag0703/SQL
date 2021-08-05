   /* Group 3: Chunlu Zhu, Na Qian, Pragati Koladiya, Sijie Wang 
Fall A 2020
ALY 6030
Group Assignment
Last updated: 10/5/2020 
*/

/* 
Case #4:
- An executive states that R&D has been increasing its cost by 15% every quarter and believes that 
  the cost is associated with Accessory product churn.
- The executive believes that the churn is unncessary and is losing money for the company
- What data can you provide to support or refute the executive's claim?
*/

-- ------------------------------------------------------------------------
/* First, we are going to check the cost that R&D spends in each quarter. */
-- ------------------------------------------------------------------------

CREATE TABLE R_D_Cost
SELECT	
	B.year_quarter, 
	B.Total_cost_R_D, 
	RANK() OVER	(ORDER BY B.year_quarter ASC) AS rank_year
FROM
	(SELECT 
		CONCAT(A.FiscalYear, '-' , A.FiscalQuarter) AS year_quarter, 
		A.Total_cost_R_D
	FROM
		(SELECT 
			t.FiscalYear, 
			t.FiscalQuarter, 
			SUM(f.Amount) AS Total_cost_R_D
		FROM FactFinance AS f
		INNER JOIN DimTime AS t
			ON f.TimeKey = t.TimeKey
		INNER JOIN DimAccount AS a
			ON f.AccountKey = a.AccountKey
		INNER JOIN DimScenario AS s 
			ON f.ScenarioKey = s.ScenarioKey
		INNER JOIN DimDepartmentGroup AS d
			ON f.DepartmentGroupKey = d.DepartmentGroupKey
		WHERE s.ScenarioName = "Actual" AND d.DepartmentGroupName = "Research and Development" AND a.AccountType = "Expenditures"
		GROUP BY t.FiscalYear, t.FiscalQuarter
        ) AS A
    ) AS B;

-- -----------------------------------------------------------------------------
/* Second, check whether R&D has been increasing its cost by 15% every quarter*/
-- -----------------------------------------------------------------------------

CREATE TABLE R_D_Percent_cost
SELECT 
	C.year_quarter, 
	CONCAT(ROUND(100 * (C.Total_cost_R_D - C.Total_cost_lag)/C.Total_cost_lag, 0), ' ' , "%") AS Cost_percent_increasing
FROM
	(SELECT 
		A.Total_cost_R_D AS Total_cost_lag, 
        A.year_quarter AS year_quarter_lag, 
        B.Total_cost_R_D AS Total_cost_R_D, 
        B.year_quarter AS year_quarter
	FROM R_D_Cost AS A
	INNER JOIN R_D_Cost AS B 
		ON A.rank_year +1 = B.rank_year
	) AS C;

-- ------------------------------------------------
/* Check total accessory profit for each quarter */
-- ------------------------------------------------

CREATE TABLE Accessory_Info
SELECT 
	CONCAT(A.FiscalYear, "-", A.FiscalQuarter) AS year_quarter, 
    A.Accessory_Cost, 
    A.Accessory_Profit
FROM
	(SELECT 
		t.FiscalYear, 
		t.FiscalQuarter, 
		SUM(i.TotalProductCost) AS Accessory_Cost, 
		SUM(i.SalesAmount - i.TotalProductCost) AS Accessory_Profit
	FROM DimProductCategory AS p
	INNER JOIN DimProductSubcategory AS s
		ON p.ProductCategoryKey = s.ProductCategoryKey
	INNER JOIN DimProduct AS product
		ON s.ProductSubcategoryKey = product.ProductSubcategoryKey
	INNER JOIN FactInternetSales AS i
		ON i.ProductKey = product.ProductKey
	INNER JOIN DimTime AS t
		ON i.OrderDateKey = t.TimeKey
	WHERE p.EnglishProductCategoryName = "Accessories" AND product.Status = "Current"
	GROUP BY t.FiscalYear, t.FiscalQuarter
	) AS A;

-- -----------------------------------------------------
/* Join Accessory_Info, R_D_Cost, and R_D_Percent_cost */
-- -----------------------------------------------------

SELECT 
	a.year_quarter, 
    a.Accessory_Cost, 
    a.Accessory_Profit, 
    r.Total_cost_R_D, 
    p.Cost_percent_increasing
FROM Accessory_Info AS a
INNER JOIN R_D_Cost AS r
	ON a.year_quarter = r.year_quarter
INNER JOIN R_D_Percent_cost AS p
	ON a.year_quarter = p.year_quarter;


/*
Case #5: 
- Your manager has asked you to prepare a revenue forecast.  
- Select the data that is necessary to predict revenue 12 months into the future.
*/

-- ---------------------------------------------------
/* Get the table for time-series revenue forecasting*/
-- ---------------------------------------------------

SELECT 
	CONCAT(A.CalendarYear, "-", A.new_month) AS YearMonth, 
    SUM(A.SalesAmount) AS Total_SalesAmount
FROM
	(SELECT 
		t.CalendarYear, 
        i.SalesAmount,
		CASE
			WHEN t.EnglishMonthName = "January" THEN "01"
			WHEN t.EnglishMonthName = "February" THEN "02"
			WHEN t.EnglishMonthName = "March" THEN "03"
			WHEN t.EnglishMonthName = "April" THEN "04"
			WHEN t.EnglishMonthName = "May" THEN "05"
			WHEN t.EnglishMonthName = "June" THEN "06"
			WHEN t.EnglishMonthName = "July" THEN "07"
			WHEN t.EnglishMonthName = "August" THEN "08"
			WHEN t.EnglishMonthName = "September" THEN "09"
			WHEN t.EnglishMonthName = "October" THEN "10"
			WHEN t.EnglishMonthName = "November" THEN "11"
			ELSE "12"
		END AS new_month
	FROM DimTime AS t
	INNER JOIN FactInternetSales AS i
		ON i.OrderDateKey = t.TimeKey
	) AS A
GROUP BY YearMonth;
