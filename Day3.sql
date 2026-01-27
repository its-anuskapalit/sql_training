SELECT 
    NEWID() AS customer_guid,
    first_name
FROM customers;


SELECT
    NEWID() AS customer_id,
    first_name,
    last_name,
    email
FROM customers;


--UNION
select top 15 BusinessEntityID, LastName from [Person].[Person]
union 
select top 15 BusinessEntityID, LastName from [Person].[Person] order by BusinessEntityID desc

--UNION ALL
select top 15 BusinessEntityID, LastName from [Person].[Person]
union all
select top 15 BusinessEntityID, LastName from [Person].[Person] order by BusinessEntityID dec