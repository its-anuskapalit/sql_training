/* ===========================
   BASIC SELECT QUERIES
   =========================== */

SELECT customer_id AS Customer_ID, first_name AS First_Name
FROM customers;

SELECT customer_id AS Customer_ID, first_name AS First_Name
FROM customers C;

SELECT * FROM tbl_employee FOR JSON AUTO;

SELECT 10 + 400 AS RESULT;

SELECT 'Valid Records' AS MyCol, * FROM customers;

SELECT * INTO customers_backup FROM customers;


/* ===========================
   FILTERING & CONDITIONS
   =========================== */

SELECT * FROM customers;

SELECT DISTINCT city FROM customers;

SELECT * FROM customers WHERE city = 'Kolkata';

SELECT * FROM customers WHERE city <> 'Kolkata';

SELECT * FROM orders WHERE order_status = 1 AND order_id = 101;

SELECT * FROM customers WHERE city IN ('Chennai','Kolkata');

SELECT * FROM order_items WHERE list_price BETWEEN 800 AND 15000;

SELECT * FROM customers WHERE first_name LIKE 'A%';


/* ===========================
   SORTING & LIMITING
   =========================== */

SELECT * FROM order_items ORDER BY list_price DESC;

SELECT TOP 3 * FROM orders ORDER BY order_id DESC;

SELECT *
FROM orders
ORDER BY order_date DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;


/* ===========================
   AGGREGATION
   =========================== */

SELECT order_id, SUM(list_price) AS TotalSpent
FROM order_items
GROUP BY item_id
HAVING SUM(list_price) > 500;


/* ===========================
   JOINS
   =========================== */

SELECT c.order_id, c.customer_id, o.list_price, o.quality
FROM orders c
INNER JOIN order_items o ON c.order_id = o.order_id;

SELECT c.order_id, c.customer_id, o.list_price, o.quality
FROM orders c
LEFT JOIN order_items o ON c.order_id = o.order_id;


/* ===========================
   SUBQUERIES
   =========================== */

SELECT * 
FROM customers
WHERE customer_id IN (
    SELECT customer_id 
    FROM orders
    WHERE store_id = 1
);


/* ===========================
   CASE STATEMENT
   =========================== */

SELECT order_id, list_price,
       CASE 
           WHEN list_price >= 3000 THEN 'High'
           WHEN list_price >= 1000 THEN 'Medium'
           ELSE 'Low'
       END AS OrderSize
FROM order_items;


/* ===========================
   EXISTS
   =========================== */

SELECT c.customer_id, c.first_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.staff_id = 1
);


/* ===========================
   UNION
   =========================== */

SELECT City FROM customers WHERE City = 'Kolkata'
UNION
SELECT City FROM customers WHERE City = 'Coimbatore';


/* ===========================
   SELECT INTO
   =========================== */

SELECT *
INTO DeliveredOrders
FROM orders
WHERE shipped_date = '2025-01-03';


/* ===========================
   CTE
   =========================== */

WITH BigOrders AS (
    SELECT order_id, qua, list_price
    FROM order_items
    WHERE list_price >= 2000
)
SELECT *
FROM BigOrders;

