-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
DROP TRIGGER sales.Tri_Insert_Customer;
GO

CREATE TRIGGER Tri_Insert_Customer
ON sales.customers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO loginfo (id,Logtext)
    SELECT
        NEWID(),
        CONCAT(
            'Logged On : ', CONVERT(VARCHAR(19), GETDATE(), 120), ' ',
            'Customer ID : ', customer_id, ' ',
            'Name : ', first_name, ' ',
            'Email : ', email,
            'Date : ' 
        )
    FROM inserted;
END
GO

