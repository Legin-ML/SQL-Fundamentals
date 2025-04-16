-- Create regions table
CREATE TABLE regions (
    region_id INTEGER PRIMARY KEY,
    region_name TEXT
);

-- Create salespersons table
CREATE TABLE salespersons (
    salesperson_id INTEGER PRIMARY KEY,
    name TEXT,
    region_id INTEGER,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

-- Create orders table
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    salesperson_id INTEGER,
    order_total REAL,
    FOREIGN KEY (salesperson_id) REFERENCES salespersons(salesperson_id)
);

-- Create employees table for hierarchical data
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    name TEXT,
    manager_id INTEGER,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- Regions
INSERT INTO regions (region_id, region_name) VALUES
(1, 'North'),
(2, 'South'),
(3, 'East'),
(4, 'West');

-- Salespersons
INSERT INTO salespersons (salesperson_id, name, region_id) VALUES
(101, 'Alice', 1),
(102, 'Bob', 2),
(103, 'Charlie', 1),
(104, 'Diana', 3);

-- Orders
INSERT INTO orders (order_id, salesperson_id, order_total) VALUES
(1, 101, 100.00),
(2, 101, 200.00),
(3, 102, 150.00),
(4, 103, 300.00),
(5, 104, 400.00),
(6, 104, 250.00);

-- Employees (Org Chart)
INSERT INTO employees (employee_id, name, manager_id) VALUES
(1, 'CEO', NULL),         -- Top-level manager
(2, 'CTO', 1),
(3, 'CFO', 1),
(4, 'Engineer A', 2),
(5, 'Engineer B', 2),
(6, 'Accountant A', 3),
(7, 'Intern', 4);         -- Intern reports to Engineer A


----------------------- CALCULATING REGIONAL TOTALS VIA Non-Recursive CTE
WITH RegionalSales AS (
    SELECT
        r.region_name,
        s.salesperson_id,
        SUM(o.order_total) AS total_sales
    FROM
        orders o
        JOIN salespersons s ON o.salesperson_id = s.salesperson_id
        JOIN regions r ON s.region_id = r.region_id
    GROUP BY
        r.region_name, s.salesperson_id
),
RegionTotals AS (
    SELECT
        region_name,
        SUM(total_sales) AS region_total
    FROM
        RegionalSales
    GROUP BY
        region_name
)
SELECT * FROM RegionTotals;


--------------------------CALCULATING THE ORGANIZATIONAL CHART VIA Recursive CTE
WITH RECURSIVE OrgChart AS (
    SELECT
        employee_id,
        name,
        manager_id,
        1 AS level
    FROM
        employees
    WHERE
        manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.name,
        e.manager_id,
        oc.level + 1
    FROM
        employees e
        JOIN OrgChart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM OrgChart
ORDER BY level, manager_id;
