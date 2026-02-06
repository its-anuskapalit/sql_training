/* =========================================================
   PROCEDURE 1: GetProductsWithCursor
   Purpose : Read each product row using cursor and PRINT it
   Level   : Beginner (Cursor basics)
   ========================================================= */

CREATE PROCEDURE dbo.GetProductsWithCursor
AS
BEGIN
    SET NOCOUNT ON;

    -- Variable declarations
    DECLARE @ProductId INT;
    DECLARE @ProductName VARCHAR(100);
    DECLARE @Price DECIMAL(10,2);

    -- Cursor declaration
    DECLARE curProducts CURSOR FAST_FORWARD
    FOR
        SELECT ProductId, ProductName, Price
        FROM dbo.Products
        ORDER BY ProductId;

    -- Open cursor
    OPEN curProducts;

    -- Fetch first record
    FETCH NEXT FROM curProducts
    INTO @ProductId, @ProductName, @Price;

    -- Loop through cursor records
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'ProductId=' + CAST(@ProductId AS VARCHAR(10))
            + ' | Name=' + @ProductName
            + ' | Price=' + CAST(@Price AS VARCHAR(20));

        -- Fetch next record
        FETCH NEXT FROM curProducts
        INTO @ProductId, @ProductName, @Price;
    END

    -- Cleanup
    CLOSE curProducts;
    DEALLOCATE curProducts;
END
GO

-- Execute procedure
EXEC dbo.GetProductsWithCursor;
GO

/* =========================================================
   PROCEDURE 2: InsertLogRows
   Purpose : Log low-stock products into ReorderLog table
   Level   : Intermediate (Cursor + Insert)
   ========================================================= */

CREATE PROCEDURE dbo.InsertLogRows
AS
BEGIN
    SET NOCOUNT ON;

    -- Variable declarations
    DECLARE @ProductId INT;
    DECLARE @ProductName VARCHAR(100);
    DECLARE @StockQty INT;

    -- Cursor for low stock products
    DECLARE curLowStock CURSOR FAST_FORWARD
    FOR
        SELECT ProductId, ProductName, StockQty
        FROM dbo.Products
        WHERE StockQty < 30
        ORDER BY StockQty ASC;

    -- Open cursor
    OPEN curLowStock;

    -- Fetch first record
    FETCH NEXT FROM curLowStock
    INTO @ProductId, @ProductName, @StockQty;

    -- Loop through records
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO dbo.ReorderLog (ProductId, Message)
        VALUES
        (
            @ProductId,
            'Reorder needed for ' + @ProductName +
            ' (Stock=' + CAST(@StockQty AS VARCHAR(10)) + ')'
        );

        -- Fetch next record
        FETCH NEXT FROM curLowStock
        INTO @ProductId, @ProductName, @StockQty;
    END

    -- Cleanup
    CLOSE curLowStock;
    DEALLOCATE curLowStock;
END
GO

-- Execute procedure
EXEC dbo.InsertLogRows;
GO

/* =========================================================
   PROCEDURE 3: UpdateFashionPrices
   Purpose : Increase Fashion product prices by 5%
             with transaction safety and audit logging
   Level   : Advanced (Cursor + Transaction + TRY/CATCH)
   ========================================================= */

CREATE PROCEDURE dbo.UpdateFashionPrices
AS
BEGIN
    SET NOCOUNT ON;

    -- Variable declarations
    DECLARE @ProductId INT;
    DECLARE @OldPrice DECIMAL(10,2);
    DECLARE @NewPrice DECIMAL(10,2);

    -- Cursor for Fashion category products
    DECLARE curFashion CURSOR FAST_FORWARD
    FOR
        SELECT ProductId, Price
        FROM dbo.Products
        WHERE Category = 'Fashion';

    BEGIN TRY
        -- Start transaction
        BEGIN TRAN;

        OPEN curFashion;

        FETCH NEXT FROM curFashion
        INTO @ProductId, @OldPrice;

        -- Loop through Fashion products
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Calculate new price (5% increase)
            SET @NewPrice = ROUND(@OldPrice * 1.05, 2);

            -- Update product price
            UPDATE dbo.Products
            SET Price = @NewPrice
            WHERE ProductId = @ProductId;

            -- Log price change
            INSERT INTO dbo.PriceChangeLog (ProductId, OldPrice, NewPrice)
            VALUES (@ProductId, @OldPrice, @NewPrice);

            FETCH NEXT FROM curFashion
            INTO @ProductId, @OldPrice;
        END

        -- Cleanup
        CLOSE curFashion;
        DEALLOCATE curFashion;

        -- Commit transaction
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        -- Ensure cursor cleanup
        IF CURSOR_STATUS('global','curFashion') >= -1
        BEGIN
            CLOSE curFashion;
            DEALLOCATE curFashion;
        END

        -- Rollback if transaction exists
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        -- Rethrow error
        THROW;
    END CATCH;
END
GO

