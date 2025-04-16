-- 1. Create Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE
);

-- 2. Create Products Table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- 3. Insert Sample Data into Orders
INSERT INTO Orders (customer_name, total_amount, order_date) VALUES
('Alice', 120.00, '2025-01-10'),
('Bob', 450.00, '2025-02-15'),
('Charlie', 600.00, '2025-03-20'),
('Diana', 1000.00, '2025-04-01'),
('Eve', 300.00, '2025-04-10');

-- 4. Insert Sample Data into Products
INSERT INTO Products (product_name, price) VALUES
('Laptop', 1200.00),
('Mouse', 25.00),
('Keyboard', 45.00),
('Monitor', 200.00),
('USB Hub', 30.00);

-- 5. Create Stored Procedure: Get Total Sales in a Date Range (RETURNS a TABLE)
CREATE OR REPLACE FUNCTION GetTotalSales(startDate DATE, endDate DATE)
RETURNS TABLE(total_sales DECIMAL(10,2)) AS $$
BEGIN
    RETURN QUERY
    SELECT SUM(total_amount)
    FROM Orders
    WHERE order_date BETWEEN startDate AND endDate;
END;
$$ LANGUAGE plpgsql;

-- 6. Scalar Function: Calculate Discount (RETURNS a single VALUE)
CREATE OR REPLACE FUNCTION CalculateDiscount(price DECIMAL(10,2), discount_rate DECIMAL(5,2))
RETURNS DECIMAL(10,2) AS $$
BEGIN
    RETURN price - (price * discount_rate / 100);
END;
$$ LANGUAGE plpgsql;

-- 7.Table-Valued Function via Stored Procedure (RETURNS a TABLE) [POSTGRESQL and MySQL does not have inherent support for TVF, so RETURN TABLE is used]
CREATE OR REPLACE FUNCTION HighValueOrders(minAmount DECIMAL(10,2))
RETURNS TABLE(order_id INT, customer_name VARCHAR(100), total_amount DECIMAL(10,2), order_date DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT o.order_id, o.customer_name, o.total_amount, o.order_date
    FROM Orders o
    WHERE o.total_amount > minAmount;
END;
$$ LANGUAGE plpgsql;

-- Test: Call Stored Procedure to Get Total Sales
SELECT * FROM GetTotalSales('2025-01-01', '2025-03-31');

-- Test: Call Scalar Function to Calculate Discount
SELECT 
    product_name, 
    price, 
    CalculateDiscount(price, 10) AS discounted_price
FROM Products;

-- Test: Call Emulated Table-Valued Function for High-Value Orders
SELECT * FROM HighValueOrders(500);
