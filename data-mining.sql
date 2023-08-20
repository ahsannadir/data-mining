-- Pre-Processing

-- Renaming column which was named incorrectly while importing.
ALTER TABLE OnlineRetail
RENAME COLUMN ï»¿InvoiceNo to InvoiceNo;

-- Removing Null Values.
DELETE FROM OnlineRetail 
WHERE InvoiceNo IS NULL 
OR StockCode IS NULL
OR Description IS NULL
OR Quantity IS NULL
OR InvoiceDate IS NULL
OR UnitPrice IS NULL
OR CustomerID IS NULL
OR Country IS NULL;

-- Checking If Null Values Exist.
SELECT *
FROM OnlineRetail 
WHERE InvoiceNo IS NULL 
OR StockCode IS NULL
OR Description IS NULL
OR Quantity IS NULL
OR InvoiceDate IS NULL
OR UnitPrice IS NULL
OR CustomerID IS NULL

-- BEGINNER QUERIES

-- Checking the total number of rows in the Table.
SELECT COUNT(Quantity)
FROM your_table;

-- Define meta data in MySQL Workbench or any other SQL tool.
DESCRIBE OnlineRetail;

-- Distribution of order values across all customers in the dataset.
SELECT CustomerID, ROUND(SUM(Quantity * UnitPrice)) as OrderValue
FROM OnlineRetail
GROUP BY CustomerID
ORDER BY OrderValue DESC;

-- Number of unique products each customer has purchased.
SELECT CustomerID, COUNT(DISTINCT StockCode) as UniqueProducts
FROM OnlineRetail
GROUP BY CustomerID
ORDER BY UniqueProducts DESC;

-- Customers who have made only a single purchase from the company.
SELECT CustomerID
FROM OnlineRetail
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;

-- Products most commonly purchased together by customers in the dataset.
SELECT a.StockCode as Product1, b.StockCode as Product2, COUNT(*) as Frequency
FROM OnlineRetail a
JOIN OnlineRetail b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode < b.StockCode
GROUP BY a.StockCode, b.StockCode
ORDER BY Frequency DESC;

-- ADVANCE QUERIES

-- Customer Segmentation by Purchase Frequency.
WITH customer_frequency AS (
    SELECT CustomerID, COUNT(*) as PurchaseFrequency
    FROM OnlineRetail
    GROUP BY CustomerID
)

SELECT 
    CustomerID,
    CASE 
        WHEN PurchaseFrequency > 100 THEN 'High Frequency'
        WHEN PurchaseFrequency > 50 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS CustomerSegment
FROM customer_frequency;

-- Average Order Value by Country.
SELECT  Country, ROUND(AVG(Quantity * UnitPrice)) as AvgOrder
FROM OnlineRetail
GROUP BY Country;

-- Customer Churn Analysis.
SELECT CustomerID
FROM OnlineRetail
WHERE InvoiceDate < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY CustomerID;

-- Product Affinity Analysis.
SELECT a.StockCode as Product1, b.StockCode as Product2, COUNT(*) as Frequency
FROM OnlineRetail a JOIN OnlineRetail b ON a.InvoiceNo = b.InvoiceNo WHERE a.StockCode < b.StockCode
GROUP BY Product1, Product2
ORDER BY Frequency DESC;

-- Time-based Analysis.
SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %h:%i:%s %p'), '%d %M %Y') as Month, ROUND(SUM(Quantity * UnitPrice)) as TotalSales
FROM OnlineRetail
GROUP BY Month
HAVING Month IS NOT NULL;