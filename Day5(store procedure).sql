CREATE OR ALTER PROCEDURE dbo.usp_ShowPerformance_WithWithoutIndex
(
    @TestProductId INT,
    @Loops INT = 100,
    @ClearCache BIT = 1
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @t0 DATETIME2,
        @t1 DATETIME2,
        @i INT,
        @ElapsedWithoutMs BIGINT,
        @ElapsedWithMs BIGINT,
        @Rows INT;

    ---------------------------------------------------------
    -- 1) Create practice table if not exists
    ---------------------------------------------------------
    IF OBJECT_ID('dbo.SalesOrderDetail_Practice') IS NULL
    BEGIN
        SELECT *
        INTO dbo.SalesOrderDetail_Practice
        FROM Sales.SalesOrderDetail;
    END

    SELECT @Rows = COUNT(*) FROM dbo.SalesOrderDetail_Practice;

    ---------------------------------------------------------
    -- 2) DROP index if exists (for test-1)
    ---------------------------------------------------------
    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes
        WHERE name = 'IX_SOD_Practice_ProductID'
        AND object_id = OBJECT_ID('dbo.SalesOrderDetail_Practice')
    )
    DROP INDEX IX_SOD_Practice_ProductID
    ON dbo.SalesOrderDetail_Practice;

    ---------------------------------------------------------
    -- 3) TEST 1 — WITHOUT INDEX
    ---------------------------------------------------------
    IF @ClearCache = 1
    BEGIN
        CHECKPOINT;
        DBCC DROPCLEANBUFFERS;
        DBCC FREEPROCCACHE;
    END

    PRINT '===============================';
    PRINT 'TEST 1 : WITHOUT ANY INDEX';
    PRINT '===============================';

    SET STATISTICS IO ON;
    SET STATISTICS TIME ON;

    SET @t0 = SYSDATETIME();
    SET @i = 1;

    WHILE @i <= @Loops
    BEGIN
        SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, UnitPrice
        FROM dbo.SalesOrderDetail_Practice
        WHERE ProductID = @TestProductId
        OPTION (RECOMPILE);

        SET @i += 1;
    END

    SET @t1 = SYSDATETIME();

    SET STATISTICS IO OFF;
    SET STATISTICS TIME OFF;

    SET @ElapsedWithoutMs = DATEDIFF_BIG(MILLISECOND, @t0, @t1);

    ---------------------------------------------------------
    -- 4) Create CLUSTERED INDEX
    ---------------------------------------------------------
    CREATE CLUSTERED INDEX IX_SOD_Practice_ProductID
    ON dbo.SalesOrderDetail_Practice(ProductID);

    ---------------------------------------------------------
    -- 5) TEST 2 — WITH CLUSTERED INDEX
    ---------------------------------------------------------
    IF @ClearCache = 1
    BEGIN
        CHECKPOINT;
        DBCC DROPCLEANBUFFERS;
        DBCC FREEPROCCACHE;
    END

    PRINT '===============================';
    PRINT 'TEST 2 : WITH CLUSTERED INDEX';
    PRINT '===============================';

    SET STATISTICS IO ON;
    SET STATISTICS TIME ON;

    SET @t0 = SYSDATETIME();
    SET @i = 1;

    WHILE @i <= @Loops
    BEGIN
        SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, UnitPrice
        FROM dbo.SalesOrderDetail_Practice
        WHERE ProductID = @TestProductId
        OPTION (RECOMPILE);

        SET @i += 1;
    END

    SET @t1 = SYSDATETIME();

    SET STATISTICS IO OFF;
    SET STATISTICS TIME OFF;

    SET @ElapsedWithMs = DATEDIFF_BIG(MILLISECOND, @t0, @t1);

    ---------------------------------------------------------
    -- 6) FINAL PERFORMANCE REPORT
    ---------------------------------------------------------
    SELECT
        @Rows AS RowsCopiedIntoPracticeTable,
        @Loops AS LoopsExecuted,
        @TestProductId AS TestedProductID,

        @ElapsedWithoutMs AS TotalElapsedMs_WithoutIndex,
        CAST(@ElapsedWithoutMs * 1.0 / NULLIF(@Loops,0) AS DECIMAL(18,2)) 
            AS AvgElapsedMsPerLoop_WithoutIndex,

        @ElapsedWithMs AS TotalElapsedMs_WithIndex,
        CAST(@ElapsedWithMs * 1.0 / NULLIF(@Loops,0) AS DECIMAL(18,2)) 
            AS AvgElapsedMsPerLoop_WithIndex,

        CASE 
            WHEN @ElapsedWithMs = 0 THEN NULL
            ELSE CAST(@ElapsedWithoutMs * 1.0 / @ElapsedWithMs AS DECIMAL(18,2))
        END AS ImprovementFactor_XTimes;
END
GO

EXEC dbo.usp_ShowPerformance_WithWithoutIndex 
     @TestProductId = 870,
     @Loops = 100,
     @ClearCache = 1;