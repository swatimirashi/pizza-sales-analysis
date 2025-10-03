/* ============================================================
   Pizza Sales Analysis - SQL Queries
   Dataset Size: ~21,000 records
   Purpose: To analyze sales performance, customer behavior,
            and operational efficiency for a pizza store.
   ============================================================ */

/* ------------------------------------------------------------
   Dataset Overview
   ------------------------------------------------------------
   Orders         → Basic order details (order_id, date, time)
   Order_Details  → Pizzas included in each order (order_id, pizza_id, quantity)
   Pizzas         → Pizza size and price (pizza_id, pizza_type_id, size, price)
   Pizza_Types    → Pizza names and ingredients (pizza_type_id, name, category, ingredients)
   ------------------------------------------------------------ */

use pizzas_sale;
/* ------------------------------------------------------------
   1. Orders by Weekday: Total and Average Orders
   Business Insight: Identify the busiest weekdays and average
   orders placed per day of the week.
   ------------------------------------------------------------ */
SELECT 
    DAYNAME(o.date) AS weekday,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT o.date), 0) AS avg_orders_per_day
FROM orders o
GROUP BY DAYNAME(o.date)
ORDER BY total_orders DESC;


/* ------------------------------------------------------------
   2. Orders by Hour: Total and Average Orders
   Business Insight: Understand customer ordering behavior by
   hour of the day.
   ------------------------------------------------------------ */
SELECT 
    DATE_FORMAT(o.time, '%H:00') AS hour_slot,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT o.date), 0) AS avg_orders_per_day
FROM orders o
GROUP BY DATE_FORMAT(o.time, '%H:00')
ORDER BY total_orders DESC;


/* ------------------------------------------------------------
   3. Peak Hours Pizza Orders
   Business Insight: Measure pizza demand during peak hours 
   (12–1 PM and 5–6 PM).
   ------------------------------------------------------------ */
SELECT
    HOUR(o.time) AS hour_24,
    SUM(od.quantity) AS total_pizzas_ordered,
    ROUND(SUM(od.quantity) / COUNT(DISTINCT o.date), 0) AS avg_pizzas_per_day
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
WHERE HOUR(o.time) IN (12, 13, 17, 18)
GROUP BY HOUR(o.time)
ORDER BY total_pizzas_ordered DESC;


/* ------------------------------------------------------------
   4. Worst-Selling Pizza Types (Bottom 3)
   Business Insight: Identify least popular pizzas to optimize 
   the menu or marketing.
   ------------------------------------------------------------ */
SELECT
    pt.name AS pizza_type,
    SUM(od.quantity) AS pizzas_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY pizzas_sold ASC
LIMIT 3;


/* ------------------------------------------------------------
   5. Best-Selling Pizza Types (Top 3)
   Business Insight: Identify top-performing pizzas for 
   promotions and customer loyalty strategies.
   ------------------------------------------------------------ */
SELECT
    pt.name AS pizza_type,
    SUM(od.quantity) AS pizzas_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY pizzas_sold DESC
LIMIT 3;


/* ------------------------------------------------------------
   6. Average Order Value
   Business Insight: Understand how much revenue is generated 
   per order on average.
   ------------------------------------------------------------ */
SELECT
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS avg_order_value
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;


/* ------------------------------------------------------------
   7. Tables Needed per Order (Operational Metric)
   Business Insight: Estimate how many tables are required 
   to serve based on pizza quantities.
   ------------------------------------------------------------ */
SELECT 
    CONCAT(o.date, ' at ', DATE_FORMAT(o.time, '%h %p')) AS Hours,
    SUM(
        CASE 
            WHEN od.pizza_quantity < 5 THEN 1
            WHEN od.pizza_quantity < 9 THEN 2
            WHEN od.pizza_quantity < 13 THEN 3
            WHEN od.pizza_quantity < 17 THEN 4
            WHEN od.pizza_quantity < 21 THEN 5
            WHEN od.pizza_quantity < 25 THEN 6
            WHEN od.pizza_quantity < 29 THEN 7
            ELSE 8
        END
    ) AS tables_needed,
    SUM(od.pizza_quantity) AS pizzas_ordered
FROM orders o
JOIN (
    SELECT order_id, SUM(quantity) AS pizza_quantity
    FROM order_details
    GROUP BY order_id
) od ON o.order_id = od.order_id
GROUP BY Hours
ORDER BY tables_needed DESC;
