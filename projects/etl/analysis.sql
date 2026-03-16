-- Select whole table
SELECT * FROM dbo.clean_sales_data;


-- Select distinct or unique Customers 
SELECT 
	COUNT(DISTINCT CustomerID) AS "Unique Customers",
	COUNT(*) AS "Total Sales"
FROM dbo.clean_sales_data;


-- Select min and max order date
SELECT 
	MIN(TransactionDate) AS "Earliest Order Date",
	MAX(TransactionDate) AS "Latest Order Date"
FROM dbo.clean_sales_data;


-- See Total Revenues, Average Order Value, and Total Quantity Sold
SELECT
	SUM(TransactionAmount) AS "Total Revenue (₹)",
	AVG(TransactionAmount) AS "Average Order Value (₹)",
	SUM(Quantity) AS "Total Quantity Sold"
FROM dbo.clean_sales_data;


-- Top 10 products by revenue
SELECT
	ProductName,
	SUM(TransactionAmount) AS Total_Revenue
FROM dbo.clean_sales_data
GROUP BY ProductName
ORDER BY Total_Revenue;


-- Revenue by region
SELECT
	Region,
	SUM(TransactionAmount) AS Total_Revenue
FROM dbo.clean_sales_data
GROUP BY Region
ORDER BY Total_Revenue;


-- Revenue by city
SELECT
	City,
	SUM(TransactionAmount) AS Total_Revenue
FROM dbo.clean_sales_data
GROUP BY City
ORDER BY Total_Revenue;


-- Return rates by product
SELECT 
    ProductName,
    COUNT(TransactionID) AS Total_Sales,
    SUM(CAST(Returned AS INT)) AS Total_Returns,
    (CAST(SUM(CAST(Returned AS INT)) AS FLOAT) / COUNT(TransactionID)) * 100 AS Return_Rate_Percentage
FROM dbo.clean_sales_data
GROUP BY ProductName
ORDER BY Return_Rate_Percentage DESC;


-- Revenue by Customer Gender
SELECT 
    CustomerGender,
    COUNT(DISTINCT CustomerID) AS Unique_Customers,
    SUM(TransactionAmount) AS Total_Spend,
    AVG(TransactionAmount) AS Avg_Spend_Per_Customer
FROM dbo.clean_sales_data
GROUP BY CustomerGender
ORDER BY Total_Spend DESC;


-- Top 10 Spenders
SELECT TOP 10
    CustomerID,
    COUNT(TransactionID) AS Transaction_Counts,
    SUM(TransactionAmount) AS Total_Value
FROM dbo.clean_sales_data
GROUP BY CustomerID
ORDER BY Total_Value DESC;


-- Top Payment Methods
SELECT 
    PaymentMethod,
    COUNT(TransactionID) AS Transactions_Count,
    SUM(TransactionAmount) AS Total_Amount
FROM dbo.clean_sales_data
GROUP BY PaymentMethod
ORDER BY Total_Amount DESC;


-- In-Store vs Online Sales
SELECT 
    StoreType,
    SUM(TransactionAmount) AS Total_Revenue,
    COUNT(TransactionID) AS Total_Transactions
FROM dbo.clean_sales_data
GROUP BY StoreType;


-- Monthly Sales
SELECT 
    MONTH(TransactionDate) AS Sale_Month,
    SUM(TransactionAmount) AS Total_Revenue,
    COUNT(TransactionID) AS Total_Transactions
FROM dbo.clean_sales_data
GROUP BY MONTH(TransactionDate)
ORDER BY Total_Revenue;


-- Monthly sales change percentage
WITH Monthly_Sales AS (
    SELECT 
        MONTH(TransactionDate) AS Sale_Month,
        SUM(TransactionAmount) AS Total_Revenue
    FROM dbo.clean_sales_data
    GROUP BY MONTH(TransactionDate)
),
SalesWithPreviousMonth AS (
    SELECT 
        Sale_Month,
        Total_Revenue,
        LAG(Total_Revenue) OVER (ORDER BY Sale_Month) AS Previous_Month_Revenue
    FROM Monthly_Sales
)
SELECT 
    Sale_Month,
    Total_Revenue,
    Previous_Month_Revenue,
    CASE 
        WHEN Previous_Month_Revenue IS NULL THEN 0
        ELSE ROUND((Total_Revenue - Previous_Month_Revenue) / Previous_Month_Revenue * 100, 2)
    END AS MoM_Percentage_Change
FROM SalesWithPreviousMonth
ORDER BY Sale_Month;


-- 7 day rolling average of sales
WITH Daily_Sales AS (
    SELECT
        CAST(TransactionDate AS DATE) AS Sale_Date,
        SUM(TransactionAmount) AS Total_Revenue
    FROM dbo.clean_sales_data
    GROUP BY CAST(TransactionDate AS DATE)
)
SELECT 
    Sale_Date,
    Total_Revenue,
    AVG(Total_Revenue) OVER (ORDER BY Sale_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Seven_Day_Rolling_Avg
FROM Daily_Sales
ORDER BY Sale_Date;



