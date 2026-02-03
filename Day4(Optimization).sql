-- Shows logical reads, physical reads, CPU time, etc.
SET STATISTICS IO ON;
-- Shows CPU time and elapsed execution time
SET STATISTICS TIME ON;

-- Fetching all rows from Person.Person
-- This is our baseline query for comparison
SELECT * 
FROM Person.Person;

-- Creates a new table and copies all data
-- SELECT INTO creates table + inserts data
SELECT * 
INTO perf_issue 
FROM Person.Person;

-- Insert data again to increase table size
-- This simulates data growth (performance degradation scenario)
INSERT INTO perf_issue
SELECT * 
FROM Person.Person;

-- Verify data
SELECT * 
FROM perf_issue;

-- Creating a view on top of perf_issue
-- Views do NOT store data (unless indexed view)
CREATE VIEW perd_issue_vw
AS
SELECT * 
FROM perf_issue;

-- Querying the view
SELECT * 
FROM perd_issue_vw;

-- ROW_NUMBER requires sorting
-- Sorting is expensive without an index
SELECT 
    ROW_NUMBER() OVER (ORDER BY BusinessEntityID) AS RowNum,
    *
FROM perf_issue;

-- Shows how many pages each table consumes
-- Useful to identify large tables causing performance issues
SELECT
    so.name,
    ps.used_page_count
FROM sys.dm_db_partition_stats ps
INNER JOIN sysobjects so
    ON ps.object_id = so.id
WHERE so.xtype = 'U'  -- U = User tables
ORDER BY ps.used_page_count DESC;

-- perf_issue will be an issue for performance
GO
-- Drop table if it already exists
DROP TABLE IF EXISTS dbo.SOH_Practice;

-- Copy 300,000 rows into a practice table
-- ORDER BY ensures sequential insert (better for clustered index later)
SELECT TOP (300000)
    SalesOrderID,
    CustomerID,
    OrderDate,
    SubTotal,
    TaxAmt,
    Freight,
    TotalDue
INTO dbo.SOH_Practice
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID;

-- Create a clustered index on SalesOrderID
-- Clustered index defines physical row order
CREATE CLUSTERED INDEX CX_SOH_Practice_SalesOrderID
ON dbo.SOH_Practice(SalesOrderID);



-- Dropping clustered index to compare performance
DROP INDEX IF EXISTS CX_SOH_Practice_SalesOrderID 
ON dbo.SOH_Practice;
