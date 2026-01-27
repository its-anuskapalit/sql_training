-- Displays all system objects in the current database
select * from sysobjects


-- Shows distinct object types (xtype) present in sysobjects
select distinct xtype from sysobjects 


-- Displays only user-defined tables
-- 'U' represents User tables
select * from sysobjects where xtype = 'U'


-- Displays all records from the customers table
select * from [dbo].[customers]


-- Groups system objects by type and counts how many objects exist for each type
select xtype, count(xtype)
from sysobjects
group by xtype


-- Creates a new table t1 and stores the count of objects
-- grouped by xtype
-- HAVING filters the grouped result to include only user tables
select xtype, count(xtype) as CountOfObjects
into t1
from sysobjects
group by xtype
having xtype = 'U'


-- Batch separator (ends the current batch)
go 


-- Fetches data from t1 where the object type is 'U'
select * from t1 where xtype = 'U'

having xtype = 'U'


go 
select * from t1 where xtype = 'U'


--- Selects all columns from the derived table (subquery)
select * from
(
select xtype, count(xtype) as CountOfObjects
from sysobjects
group by xtype
)  g1 where g1.xtype='IT'


GO
-- Create table A1
select xtype, count(*) as CountOfObjects
into A1
from sysobjects
group by xtype
go
-- Create table A2
select distinct xtype
into A2
from sysobjects
go
select A1.xtype, A1.CountOfObjects
from A1
inner join A2
on A1.xtype = A2.xtype
where A1.xtype = 'IT';
