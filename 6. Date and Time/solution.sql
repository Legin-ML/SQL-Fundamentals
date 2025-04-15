CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    order_date DATE NOT NULL,
    total_amount REAL
);

INSERT INTO orders (customer_name, order_date, total_amount) VALUES
('Alice', '2025-04-14', 150.00),
('Bob', '2025-03-20', 200.00),
('Charlie', '2025-04-01', 300.00),
('Diana', '2025-03-10', 120.00),
('Eve', '2025-03-31', 250.00);

SELECT *
FROM orders
WHERE order_date >= DATE('now', '-30 days'); -- gives the orders placed in the last 30 days


SELECT 
    order_id,
    customer_name,
    order_date,
    DATE(order_date, '+7 days') AS delivery_estimate
FROM orders; -- Gives the list of dates with 7 days added


SELECT 
    order_id,
    customer_name,
    strftime('%d-%m-%Y', order_date) AS formatted_order_date
FROM orders; -- formatted date for easier perusal
