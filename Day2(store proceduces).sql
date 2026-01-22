/* ===========================
   PROCEDURES
   =========================== */
USE db2;
GO

/* ===========================
   PROCEDURE : MyPractice
   Description : Fetch customers by city
   =========================== */
CREATE PROCEDURE dbo.MyPractice
    @City VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM dbo.customers
    WHERE city = @City;
END
GO

EXEC dbo.MyPractice 'Kolkata';


/* ===========================
   PROCEDURE : MyPractice (ALTER)
   Description : Modify existing procedure to fetch customers by city
   =========================== */
ALTER PROCEDURE dbo.MyPractice
    @City VARCHAR(50),
    @State VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM db2.customers
    WHERE city = @City
      AND state = @State;
END
GO

-- Execute procedure for Delhi
EXEC db2.MyPractice 'Kolkata', 'Wb';

/* ===========================
   PROCEDURE : GetName
   Description : Fetch first and last names of all customers
   =========================== */

CREATE PROCEDURE GetName
AS
BEGIN
    SELECT first_name, last_name
    FROM customers;
END
GO

-- Execute GetName procedure
EXEC GetName;


/* ===========================
   PROCEDURE : GetName (ALTER)
   Description : Fetch customer name using customer ID
   =========================== */

-- Alter procedure to accept customer ID
ALTER PROCEDURE GetName
    @CustomerId INT
AS
BEGIN
    SELECT first_name, last_name
    FROM customers
    WHERE customer_id = @CustomerId;
END
GO

-- Execute procedure for customer_id = 1
EXEC GetName 1;


/* ===========================
   PROCEDURE : GetCustomerByNameCity
   Description : Fetch customer details using name and city
   =========================== */

-- Create procedure to get customer by name and city
CREATE PROCEDURE GETCUSTOMERBYNAMECITY
    @NAME VARCHAR(50),
    @CITY VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM customers
    WHERE first_name = @NAME
      AND city = @CITY;
END
GO

-- Execute procedure with name and city
EXEC GETCUSTOMERBYNAMECITY 'Anuska', 'Kolkata';

/* ===========================
   PROCEDURE : UpdateStore
   Description : Update store id 
   =========================== */

Create procedure UpdateStore
AS
BEGIN
    update [dbo].[staffs]
    set store_id=5, actice=0
    where staff_id=1;
END
GO
/* ===========================
   PROCEDURE : PrintStaff
   Description : Print staff table
   =========================== */
Create procedure PrintStaff
AS
BEGIN
    select * from [dbo].[staffs];
END
GO

exec UpdateStore
exec PrintStaff