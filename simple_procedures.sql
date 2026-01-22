/* ===========================
       PROCEDURE : GetBrandName
       Description : Fetch all brand names
       =========================== */
CREATE PROCEDURE GetBrandName
AS
BEGIN
    SELECT brand_name 
    FROM production.brands;
END
GO

exec GetBrandName
 /* ===========================
       PROCEDURE : GetBicycleCategories
       Description : Fetch category names containing 'Bicycles'
       =========================== */
CREATE PROCEDURE GetBicycleCategories
AS
BEGIN
    SELECT category_name
    FROM production.categories
    WHERE category_name LIKE '%Bicycles%';
END
GO
EXEC GetBicycleCategories;

 /* ===========================
       PROCEDURE : GetProductsSortedByPrice
       Description : Fetch products sorted by price in descending order
       =========================== */
CREATE PROCEDURE GetProductsSortedByPrice
AS
BEGIN
    SELECT 
        product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price
    FROM production.products
    ORDER BY list_price DESC;
END
GO
exec GetProductsSortedByPrice

/* ===========================
       PROCEDURE : GetProductQualitySorted
       Description : Fetch stock details sorted by quantity in descending order
       =========================== */
Create Procedure GetProductQualitySorted
as
begin 
select * from [production].[stocks]
order by quantity Desc
end
go
exec GetProductQualitySorted

 /* ===========================
       PROCEDURE : GetCustomerDetails
       Description : Fetch customer details including contact and address information
       =========================== */
CREATE PROCEDURE GetCustomersByCity
    @City VARCHAR(50)
AS
BEGIN
    SELECT
        customer_id,
        first_name,
        last_name,
        phone,
        email,
        city,
        state,

        CASE 
            WHEN email IS NOT NULL THEN 'Email Available'
            ELSE 'Email Not Available'
        END AS email_status

    FROM sales.customers
    WHERE city = @City;
END
GO

EXEC GetCustomersByCity 'New York';

/* ===========================
       PROCEDURE : GetOrderItemSummary
       Description : Fetch order items with calculated final price
       =========================== */

CREATE PROCEDURE GetOrderItemSummary
AS
BEGIN
    SELECT
        order_id,
        item_id,
        product_id,
        quantity,
        list_price,
        discount,
        (quantity * list_price) - discount AS final_price
    FROM sales.order_items;
END
GO

EXEC GetOrderItemSummary;
 /* ===========================
       PROCEDURE : GetOrderDeliveryStatus
       Description : Determine order status using order, shipped, and required dates
       =========================== */
CREATE PROCEDURE GetOrderDeliveryStatus
AS
BEGIN
    SELECT
        order_id,
        customer_id,
        order_date,
        required_date,
        shipped_date,
        store_id,
        staff_id,

        CASE
            WHEN shipped_date IS NULL THEN 'Not Shipped'
            WHEN shipped_date > required_date THEN 'Delivered Late'
            ELSE 'Delivered On Time'
        END AS delivery_status

    FROM sales.orders;
END
GO

EXEC GetOrderDeliveryStatus;
/* ===========================
       PROCEDURE : GetStaffActivityStatus
       Description : Fetch staff details with activity status
       =========================== */

CREATE PROCEDURE GetStaffActivityStatus
AS
BEGIN

    SELECT
        staff_id,
        first_name,
        last_name,
        email,
        phone,
        store_id,
        CASE 
            WHEN active = 1 THEN 'Active'
            ELSE 'Inactive'
        END AS staff_status
    FROM sales.staffs;
END
GO

EXEC GetStaffActivityStatus;
/* ===========================
       PROCEDURE : GetStoreLocations
       Description : Fetch store details with formatted address
       =========================== */
CREATE PROCEDURE GetStoreLocations
AS
BEGIN
    SELECT
        store_id,
        store_name,
        phone,
        email,
        city,
        state,
        zip_code,
        city + ', ' + state AS store_location
    FROM sales.stores;
END
GO

EXEC GetStoreLocations;
