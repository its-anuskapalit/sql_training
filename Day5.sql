--1
SELECT name
FROM sys.databases
WHERE name LIKE 'AdventureWorks%';

--2 Create Clustered Index
USE AdventureWorks2025;
GO
DROP TABLE IF EXISTS dbo.Product_Practice;
SELECT TOP (5000)
  ProductID, Name, ProductNumber, Color, ListPrice, ModifiedDate
INTO dbo.Product_Practice
FROM Production.Product
ORDER BY ProductID;

-- Create Clustered Index
CREATE CLUSTERED INDEX CX_Product_Practice_ProductID
ON dbo.Product_Practice(ProductID);

-- Verify indexes
SELECT i.index_id, i.name, i.type_desc
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('dbo.Product_Practice');

--3 Create Nonclustered Index
USE AdventureWorks2025;
GO

CREATE NONCLUSTERED INDEX IX_Product_Practice_ProductNumber
ON dbo.Product_Practice(ProductNumber);

SELECT i.index_id, i.name, i.type_desc
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('dbo.Product_Practice');

--4 Single key vs Composite (multiple keys)
Index on (Color, ListPrice)
--Good:
WHERE Color='Black'
WHERE Color='Black' AND ListPrice>=1000
--Not great:
WHERE ListPrice>=1000  -- Color missing

--5 INCLUDE
USE AdventureWorks2025;
GO
DROP INDEX IF EXISTS IX_Product_Practice_ProductNumber ON dbo.Product_Practice;
CREATE NONCLUSTERED INDEX IX_Product_Practice_ProductNumber_Cover
ON dbo.Product_Practice(ProductNumber)
INCLUDE (Name, ListPrice);

--6 Heap scan ? Nonclustered seek
USE AdventureWorks2025;
GO

-- Create HEAP table
DROP TABLE IF EXISTS dbo.Person_Practice;
SELECT TOP (20000)
  BusinessEntityID, FirstName, LastName, ModifiedDate
INTO dbo.Person_Practice
FROM Person.Person
ORDER BY BusinessEntityID;

-- Without index
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT TOP 200 BusinessEntityID, FirstName, LastName
FROM dbo.Person_Practice
WHERE LastName = 'Smith'
ORDER BY FirstName;

-- With index
CREATE NONCLUSTERED INDEX IX_Person_Practice_LastName
ON dbo.Person_Practice(LastName);

SELECT TOP 200 BusinessEntityID, FirstName, LastName
FROM dbo.Person_Practice
WHERE LastName = 'Smith'
ORDER BY FirstName;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

USE AdventureWorks2025;
GO

DROP TABLE IF EXISTS dbo.SalesOrderHeader_Practice;
SELECT TOP (200000)
  SalesOrderID, CustomerID, OrderDate, TotalDue
INTO dbo.SalesOrderHeader_Practice
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Before index
SELECT TOP 200 SalesOrderID, CustomerID, OrderDate, TotalDue
FROM dbo.SalesOrderHeader_Practice
WHERE CustomerID = 11000
  AND OrderDate >= '2013-01-01' AND OrderDate < '2014-01-01'
ORDER BY OrderDate;

-- Create composite + covering index
CREATE NONCLUSTERED INDEX IX_SOH_Practice_Customer_OrderDate_Cover
ON dbo.SalesOrderHeader_Practice(CustomerID, OrderDate)
INCLUDE (TotalDue);

-- After index
SELECT TOP 200 SalesOrderID, CustomerID, OrderDate, TotalDue
FROM dbo.SalesOrderHeader_Practice
WHERE CustomerID = 11000
  AND OrderDate >= '2013-01-01' AND OrderDate < '2014-01-01'
ORDER BY OrderDate;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;