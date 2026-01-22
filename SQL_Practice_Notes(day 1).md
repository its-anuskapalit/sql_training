# 📘 SQL Practice Queries 

## 1. Basic SELECT Statements

### 1.1 Select Specific Columns
```sql
-- Select customer_id and first_name from customers table
SELECT 
    customer_id AS Customer_ID,
    first_name AS First_Name
FROM customers;
```
Explanation:
Fetches only required columns and renames them using aliases.

1.2 SELECT with Table Alias
```sql
-- Using alias 'C' for customers table
SELECT 
    C.customer_id AS Customer_ID,
    C.first_name AS First_Name
FROM customers C;
```
Explanation:
Aliases make queries shorter and easier to read.

2. JSON & Expressions
2.1 Convert Table to JSON
```sql
SELECT * 
FROM tbl_employee 
FOR JSON AUTO;
```
Explanation:
Automatically converts table data into JSON format.

2.2 Arithmetic Expression
```sql
SELECT 10 + 400 AS RESULT;
```
Explanation:
Used for testing expressions or calculations.

3. Data Labeling & Backup
3.1 Add Static Column
```
SELECT 'Valid Records' AS MyCol, *
FROM customers;
```
Explanation:
Adds a constant value column to each row.

3.2 Backup Table
```sql
SELECT *
INTO customers_backup
FROM customers;
```
Explanation:
Creates a backup copy of the table.

4. Filtering Records
4.1 DISTINCT Values
```sql
SELECT DISTINCT city
FROM customers;
```
4.2 WHERE Conditions
1.
```sql
SELECT *
FROM customers
WHERE city = 'Kolkata';
```
```sql
SELECT *
FROM customers
WHERE city <> 'Kolkata';
```
4.3 IN & NOT IN
```sql
SELECT *
FROM customers
WHERE city IN ('Chennai', 'Kolkata');
```
```sql
SELECT *
FROM customers
WHERE city NOT IN ('Chennai', 'Kolkata');
```
4.4 BETWEEN
```sql
SELECT *
FROM order_items
WHERE list_price BETWEEN 800 AND 15000;
```
4.5 LIKE
```sql
SELECT *
FROM customers
WHERE first_name LIKE 'A%';
```
```sql
SELECT *
FROM customers
WHERE first_name LIKE 'A%a' or last_name='Palit';
```
5. Sorting & Pagination
5.1 ORDER BY
```sql
SELECT *
FROM order_items
ORDER BY list_price DESC;
```
5.2 TOP
```sql
SELECT TOP 3 *
FROM orders
ORDER BY order_id DESC;
```
5.3 OFFSET & FETCH
```sql
SELECT *
FROM orders
ORDER BY order_date DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
```
6. Aggregate Functions
6.1 GROUP BY & HAVING
```sql
SELECT item_id, SUM(list_price) AS TotalSpent
FROM order_items
GROUP BY item_id
HAVING SUM(list_price) > 500;
```
7. Joins
7.1 INNER JOIN
```sql
SELECT c.order_id, c.customer_id, o.list_price, o.quality
FROM orders c
INNER JOIN order_items o
ON c.order_id = o.order_id;
```
7.2 LEFT JOIN
```sql
SELECT c.order_id, c.customer_id, o.list_price, o.quality
FROM orders c
LEFT JOIN order_items o
ON c.order_id = o.order_id;
```
8. Subqueries
8.1 IN Subquery
```sql
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE store_id = 1
);
```
8.2 EXISTS
```sql
SELECT c.customer_id, c.first_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.staff_id = 1
);
```
9. CASE Statement
```sql
SELECT order_id, list_price,
       CASE 
           WHEN list_price >= 3000 THEN 'High'
           WHEN list_price >= 1000 THEN 'Medium'
           ELSE 'Low'
       END AS OrderSize
FROM order_items;
```
10. UNION
```sql
SELECT city FROM customers WHERE city = 'Kolkata'
UNION
SELECT city FROM customers WHERE city = 'Coimbatore';
```
11. SELECT INTO with Condition
```sql
SELECT *
INTO DeliveredOrders
FROM orders
WHERE shipped_date = '2025-01-03';
```
12. Common Table Expression (CTE)
```sql
WITH BigOrders AS (
    SELECT order_id, quality, list_price
    FROM order_items
    WHERE list_price >= 2000
)
SELECT *
FROM BigOrders;
```
