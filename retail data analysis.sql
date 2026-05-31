SELECT * FROM retail_sales_analysis.`retail sales performance analysis - cleaned data`;

CREATE DATABASE retail_sales_analysis;

USE retail_sales_analysis;

ALTER TABLE `retail sales performance analysis - cleaned data`
MODIFY COLUMN Sales DECIMAL(10,2);

ALTER TABLE `retail sales performance analysis - cleaned data`
RENAME COLUMN `Sales (in dollars)` TO Sales;

SELECT Sales
FROM `retail sales performance analysis - cleaned data`
LIMIT 10;

UPDATE `retail sales performance analysis - cleaned data`
SET Sales = REPLACE(Sales, ',', '');

SET SQL_SAFE_UPDATES = 0;

UPDATE `retail sales performance analysis - cleaned data`
SET Sales = NULL
WHERE TRIM(Sales) = '';

UPDATE `retail sales performance analysis - cleaned data`
SET Sales = TRIM(Sales);

ALTER TABLE `retail sales performance analysis - cleaned data`
RENAME COLUMN `Profit (in dollars)` TO Profit;

ALTER TABLE `retail sales performance analysis - cleaned data`
MODIFY COLUMN Profit DECIMAL(10,2);

---------- total sales ---------------
SELECT SUM(Sales) AS Total_Sales
FROM retail_sales_analysis.`retail sales performance analysis - cleaned data`;

----------- top categories -----------
SELECT Category, SUM(Sales) AS Total_Sales
FROM retail_sales_analysis.`retail sales performance analysis - cleaned data`
GROUP BY Category
ORDER BY Total_Sales DESC;

------------ profit by region -----------
SELECT Region, SUM(Profit) AS Total_Profit
FROM retail_sales_analysis.`retail sales performance analysis - cleaned data`
GROUP BY Region
ORDER BY Total_Profit DESC;

---------- monthly sales trend ----------

SELECT Order_Date
FROM `retail sales performance analysis - cleaned data`
LIMIT 10;

ALTER TABLE `retail sales performance analysis - cleaned data`
ADD COLUMN Clean_Order_Date DATE;

UPDATE `retail sales performance analysis - cleaned data`
SET Clean_Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%Y');

SELECT Order_Date, Clean_Order_Date
FROM `retail sales performance analysis - cleaned data`
LIMIT 10;

SELECT 
DATE_FORMAT(Clean_Order_Date, '%d/%m/%Y') AS Formatted_Date
FROM `retail sales performance analysis - cleaned data`
LIMIT 10;

SELECT 
    YEAR(Clean_Order_Date) AS Year,
    MONTH(Clean_Order_Date) AS Month,
    SUM(Sales) AS Monthly_Sales
FROM `retail sales performance analysis - cleaned data`
GROUP BY Year, Month
ORDER BY Year, Month;

----------- avg order value ----------
SELECT 
    AVG(Sales) AS Avg_Order_Value
FROM `retail sales performance analysis - cleaned data`;

------------ sales contribution by segments ----------
SELECT 
    Segment,
    ROUND(SUM(Sales) * 100 / 
    (SELECT SUM(Sales) 
     FROM `retail sales performance analysis - cleaned data`),2)
    AS Contribution_Percentage
FROM `retail sales performance analysis - cleaned data`
GROUP BY Segment;

------------- top 5 product by revenue -------------
SELECT 
    Product_Name,
    SUM(Sales) AS Total_Revenue
FROM `retail sales performance analysis - cleaned data`
GROUP BY Product_Name
ORDER BY Total_Revenue DESC
LIMIT 5;