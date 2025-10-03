# 🍕 Pizza Sales Analysis Using SQL

## 📌 Project Overview
This project analyzes one year of pizza sales to understand customer behavior, sales patterns, and operational efficiency using SQL. The insights help optimize staffing, menu performance, kitchen operations, and seating.

---

## 📂 Dataset Overview
- **Orders** → Basic order details (`order_id`, `date`, `time`)  
- **Order_Details** → Pizzas in each order (`order_id`, `pizza_id`, `quantity`)  
- **Pizzas** → Pizza size and price (`pizza_id`, `pizza_type_id`, `size`, `price`)  
- **Pizza_Types** → Pizza names and ingredients (`pizza_type_id`, `name`, `category`, `ingredients`)  

(All four tables are in the pizza-sales-dataset folder)

---

## 🛠 SQL Queries
- Orders by weekday  
- Orders by hour  
- Peak hours pizza orders  
- Best & worst-selling pizzas  
- Average order value  
- Tables needed per order  

(All queries are in `queries.sql`)

---

## 📊 Key Insights
- **Busiest Days & Hours:** Fridays, 12–1 PM and 5–6 PM  
- **Pizza Demand:** ~19 pizzas per hour at lunch, 15 at dinner  
- **Menu Performance:** Classic Deluxe top seller, Brie Carre lowest  
- **Customer Spending:** Avg order = $38.31; yearly revenue ≈ $817,860  
- **Seating Usage:** 15 tables (60 seats) often full or over capacity  

---

## 💡 SQL Performance Tips
- Use **JOINs** instead of subqueries  
- **Index key columns** (`order_id`, `pizza_id`, `date`)  
- **Filter early** with WHERE  
- **Select only required columns**  
- Use **EXPLAIN** to check query execution  
- **Batch heavy calculations** in temporary tables  

---

## ✨ Takeaway
- Efficiently analyze large datasets  
- Generate actionable business insights  
- Optimize operations (menu, staffing, seating)  
- Communicate results clearly to managers  

---

