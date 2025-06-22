-- create database pizza_sale;
use pizza_sale;
show tables;

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

-- 1. Total number of orders placed
SELECT COUNT(order_id) AS total_orders FROM orders;

-- 2. Total revenue generated
SELECT 
	ROUND(SUM(price * quantity), 2) AS total_revenue
FROM 
	order_details
		JOIN 
	pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
-- 3. Average order value (AOV)
SELECT 
	ROUND(AVG(order_total), 2) AS avg_order_value
FROM 
	(
		SELECT 
			order_id, SUM(price * quantity) AS order_total
		FROM 
			order_details 
				JOIN 
			pizzas ON pizzas.pizza_id = order_details.pizza_id
		GROUP BY order_id
) AS sum;
    
-- 4. Daily revenue trend
SELECT 
	date, ROUND(SUM(price * quantity), 2) AS daily_revenue
FROM 
	orders
		JOIN 
	order_details ON orders.order_id = order_details.order_id
		JOIN 
	pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY date;

-- 5. Cumulative revenue over time
SELECT 
	date, SUM(daily_revenue) OVER (ORDER BY date) AS cumulative_revenue
FROM 
	(
		SELECT 
			orders.date, SUM(price * quantity) AS daily_revenue
		FROM 
			orders
				JOIN 
			order_details ON orders.order_id = order_details.order_id
				JOIN 
			pizzas ON pizzas.pizza_id = order_details.pizza_id
		GROUP BY orders.date
	) AS sales;
    
-- 6. Top 5 most ordered pizza types
SELECT 
	name, SUM(quantity) AS total_quantity
FROM 
	pizza_types
		JOIN 
	pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY total_quantity DESC
LIMIT 5;

-- 7. Least selling pizzas
SELECT 
	name, SUM(quantity) AS total_quantity
FROM 
	pizza_types
		JOIN 
	pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY total_quantity ASC
LIMIT 5;

-- 8. Highest revenue-generating pizza types
SELECT 
	name, ROUND(SUM(price * quantity), 2) AS revenue
FROM 
	pizza_types
		JOIN 
	pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY revenue DESC
LIMIT 5;

-- 9. Premium pizzas (high revenue, fewer orders)
SELECT 
	name, 
    COUNT(order_id) AS num_orders, ROUND(SUM(price * quantity), 2) AS revenue
FROM 
	pizza_types
		JOIN 
	pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY revenue DESC
LIMIT 5;

-- 10. Pizzas never ordered (zero quantity)
SELECT 
	name
FROM 
	pizza_types
WHERE 
	pizza_type_id NOT IN 
    (
		SELECT 
			pizza_type_id
		FROM 
			pizzas
				JOIN 
			order_details ON pizzas.pizza_id = order_details.pizza_id
	);
    
-- 11. Order distribution by hour
SELECT 
	HOUR(time) AS hour, COUNT(*) AS order_count
FROM 
	orders
GROUP BY HOUR(time)
ORDER BY order_count DESC;

-- 12. Most active order day
SELECT 
	date, COUNT(*) AS order_count
FROM 
	orders
GROUP BY date
ORDER BY order_count DESC
LIMIT 1;

-- 13. Pizza orders by weekday

SELECT 
	DAYNAME(date) AS weekday, COUNT(*) AS total_orders
FROM 
	orders
GROUP BY weekday
ORDER BY total_orders DESC;

-- 14. Average pizzas ordered per day
SELECT 
	ROUND(AVG(quantity), 2) AS avg_pizzas_per_day
FROM 
	(
		SELECT 
			date, SUM(quantity) AS quantity
		FROM 
			orders
				JOIN 
			order_details ON orders.order_id = order_details.order_id
		GROUP BY date
	) AS daily;
    
-- 15. Top category per day
SELECT 
	date, category, total_quantity
FROM 
	(
		SELECT 
			orders.date, pizza_types.category, SUM(order_details.quantity) AS total_quantity,
			RANK() OVER (PARTITION BY orders.date ORDER BY SUM(order_details.quantity) DESC) AS rk
		FROM 
			orders
				JOIN 
			order_details ON orders.order_id = order_details.order_id
				JOIN 
			pizzas ON pizzas.pizza_id = order_details.pizza_id
				JOIN 
			pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		GROUP BY orders.date, pizza_types.category
	) as ranked
WHERE rk = 1;

-- 16. Revenue by pizza size
SELECT 
	size, ROUND(SUM(price * quantity), 2) AS total_revenue
FROM 
	pizzas
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size
ORDER BY total_revenue DESC;

--  17. Most preferred pizza size
SELECT 
	size, SUM(quantity) AS quantity_ordered
FROM 
	pizzas
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size
ORDER BY quantity_ordered DESC
limit 1;

-- 18. Most profitable category
SELECT 
	category, ROUND(SUM(price * quantity), 2) AS revenue
FROM 
	pizza_types
		JOIN 
	pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
ORDER BY revenue DESC;

-- 19. Most ordered category by volume
SELECT 
	category, SUM(quantity) AS total_quantity
FROM 
	pizza_types
		JOIN 
	pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
ORDER BY total_quantity DESC;

-- 20. Average pizzas per order
SELECT 
	ROUND(AVG(quantity), 2) AS avg_pizzas_per_order
FROM 
	(
		SELECT 
			order_id, SUM(quantity) AS quantity
		FROM 
			order_details
		GROUP BY order_id
	) q;























