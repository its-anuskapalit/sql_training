-- We are creating a procedure to add details into adventure works dataset 

USE [AdventureWorks2025]
GO
/****** Object:  StoredProcedure [Person].[usp_InsertPersonFullDetails]    Script Date: 22-01-2026 15:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Person].[usp_InsertPersonFullDetails]
(
    @PersonType CHAR(2),
    @Title NVARCHAR(8),
    @FirstName NVARCHAR(50),
    @MiddleName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50),
    @EmailAddress NVARCHAR(100),
    @PhoneNumber NVARCHAR(25),
    @PhoneNumberTypeID INT,
    @PasswordHash NVARCHAR(128),
    @PasswordSalt NVARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BusinessEntityID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert into BusinessEntity
        INSERT INTO Person.BusinessEntity (rowguid, ModifiedDate)
        VALUES (NEWID(), GETDATE());

        SET @BusinessEntityID = SCOPE_IDENTITY();

        -- Insert into Person
        INSERT INTO Person.Person
        (
            BusinessEntityID,
            PersonType,
            NameStyle,
            Title,
            FirstName,
            MiddleName,
            LastName,
            Suffix,
            EmailPromotion,
            AdditionalContactInfo,
            Demographics,
            rowguid,
            ModifiedDate
        )
        VALUES
        (
            @BusinessEntityID,
            @PersonType,
            0,
            @Title,
            @FirstName,
            @MiddleName,
            @LastName,
            NULL,
            0,
            NULL,
            NULL,
            NEWID(),
            GETDATE()
        );

        -- Insert into EmailAddress
        INSERT INTO Person.EmailAddress
        (
            BusinessEntityID,
            EmailAddress,
            rowguid,
            ModifiedDate
        )
        VALUES
        (
            @BusinessEntityID,
            @EmailAddress,
            NEWID(),
            GETDATE()
        );

        -- Insert into PersonPhone
        INSERT INTO Person.PersonPhone
        (
            BusinessEntityID,
            PhoneNumber,
            PhoneNumberTypeID,
            ModifiedDate
        )
        VALUES
        (
            @BusinessEntityID,
            @PhoneNumber,
            @PhoneNumberTypeID,
            GETDATE()
        );

        -- Insert into Password
        INSERT INTO Person.Password
        (
            BusinessEntityID,
            PasswordHash,
            PasswordSalt,
            rowguid,
            ModifiedDate
        )
        VALUES
        (
            @BusinessEntityID,
            @PasswordHash,
            @PasswordSalt,
            NEWID(),
            GETDATE()
        );

        COMMIT TRANSACTION;

        -- Return inserted data
        SELECT *
        FROM Person.Person p
        LEFT JOIN Person.EmailAddress e 
            ON p.BusinessEntityID = e.BusinessEntityID
        LEFT JOIN Person.PersonPhone ph 
            ON p.BusinessEntityID = ph.BusinessEntityID
        WHERE p.BusinessEntityID = @BusinessEntityID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;

EXEC Person.usp_InsertPersonFullDetails
    @PersonType = 'EM',
    @Title = 'Mr.',
    @FirstName = 'Rahul',
    @MiddleName = 'K',
    @LastName = 'Sharma',
    @EmailAddress = 'rahul.sharma@example.com',
    @PhoneNumber = '9876543210',
    @PhoneNumberTypeID = 1,
    @PasswordHash = 'FakeHash123',
    @PasswordSalt = 'FakeSalt456';