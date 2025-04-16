-- Schema Design

-- Products table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Pending',
    total_amount DECIMAL(10, 2) NOT NULL
);

-- OrderDetails table
CREATE TABLE OrderDetails (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES Products(product_id) ON DELETE CASCADE,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Inventory table
CREATE TABLE Inventory (
    product_id INT REFERENCES Products(product_id) ON DELETE CASCADE,
    stock_quantity INT NOT NULL,
    PRIMARY KEY (product_id)
);

-- Sample Data

-- Insert customers
INSERT INTO Customers (first_name, last_name, email, phone, address)
VALUES 
    ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Main St, Springfield'),
    ('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', '456 Oak Ave, Springfield');

-- Insert products
INSERT INTO Products (name, description, price, category)
VALUES 
    ('Laptop', 'High performance laptop', 1000.00, 'Electronics'),
    ('Smartphone', 'Latest model smartphone', 700.00, 'Electronics'),
    ('Headphones', 'Noise-cancelling headphones', 150.00, 'Accessories'),
    ('Desk Chair', 'Ergonomic office chair', 200.00, 'Furniture');

-- Insert inventory
INSERT INTO Inventory (product_id, stock_quantity)
VALUES 
    (1, 50),
    (2, 100),
    (3, 30),
    (4, 20);

-- Order for John Doe
DO $$ 
DECLARE
    new_order_id INT;
BEGIN
    INSERT INTO Orders (customer_id, total_amount)
    VALUES (1, 1500.00)
    RETURNING order_id INTO new_order_id;

    INSERT INTO OrderDetails (order_id, product_id, quantity, price)
    VALUES (new_order_id, 1, 1, 1000.00),
           (new_order_id, 2, 2, 700.00);
END $$;

-- Order for Jane Smith
DO $$ 
DECLARE
    new_order_id INT;
BEGIN
    INSERT INTO Orders (customer_id, total_amount)
    VALUES (2, 850.00)
    RETURNING order_id INTO new_order_id;

    INSERT INTO OrderDetails (order_id, product_id, quantity, price)
    VALUES (new_order_id, 3, 2, 150.00);
END $$;

-- Indexing Strategy

CREATE INDEX idx_products_name_category ON Products(name, category);
CREATE INDEX idx_orders_customer_id ON Orders(customer_id);
CREATE INDEX idx_orderdetails_order_id_product_id ON OrderDetails(order_id, product_id);
CREATE INDEX idx_inventory_product_id ON Inventory(product_id);

-- Triggers

-- Update inventory after order
CREATE OR REPLACE FUNCTION update_inventory_after_order()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Inventory
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_inventory
AFTER INSERT ON OrderDetails
FOR EACH ROW
EXECUTE FUNCTION update_inventory_after_order();

-- Audit log
CREATE TABLE AuditLog (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(10),
    changed_data JSONB,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO AuditLog(table_name, operation, changed_data)
    VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW)::jsonb);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_product_changes
AFTER INSERT OR UPDATE OR DELETE ON Products
FOR EACH ROW
EXECUTE FUNCTION log_changes();

CREATE TRIGGER trigger_log_order_changes
AFTER INSERT OR UPDATE OR DELETE ON Orders
FOR EACH ROW
EXECUTE FUNCTION log_changes();

CREATE TRIGGER trigger_log_orderdetail_changes
AFTER INSERT OR UPDATE OR DELETE ON OrderDetails
FOR EACH ROW
EXECUTE FUNCTION log_changes();

-- Extra Order Example (Transaction Simulation)
DO $$ 
DECLARE
    new_order_id INT;
BEGIN
    INSERT INTO Orders (customer_id, total_amount)
    VALUES (1, 150.00)
    RETURNING order_id INTO new_order_id;

    INSERT INTO OrderDetails (order_id, product_id, quantity, price)
    VALUES (new_order_id, 1, 2, 75.00),
           (new_order_id, 2, 1, 50.00);
END $$;

-- Views

CREATE VIEW CustomerOrderSummary AS
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Materialized View (Optional)

CREATE MATERIALIZED VIEW ProductInventorySummary AS
SELECT p.product_id,
       p.name,
       i.stock_quantity,
       SUM(od.quantity) AS total_sold
FROM Products p
JOIN Inventory i ON p.product_id = i.product_id
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_id, i.stock_quantity;

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW ProductInventorySummary;

-- Testing

-- Get all orders for a customer
SELECT * FROM Orders WHERE customer_id = 1;

-- Get products for an order
SELECT p.name, od.quantity, od.price 
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
WHERE od.order_id = 1;

-- Check inventory
SELECT * FROM Inventory WHERE product_id = 1;
