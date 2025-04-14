-- PRAGMA foreign_keys = ON; (Required for SQLite)

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


INSERT INTO Customers (CustomerID, FirstName, LastName)
VALUES
    (1, 'Alice', 'Doe'),
    (2, 'Bob', 'Ross'),
    (3, 'Jane', 'Smith');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Amount)
VALUES
    (101, 1, '2025-04-01', 150.00),
    (102, 2, '2025-04-02', 200.00),
    (103, 1, '2025-04-03', 300.00);


-- INNER JOIN Returns records that have matching values in both tables
SELECT Customers.FirstName, Customers.LastName, Orders.OrderDate, Orders.Amount
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- LEFT JOIN Returns all records from the left table, and the matched records from the right table ()
SELECT Orders.OrderID, Customers.FirstName, Customers.LastName, Orders.OrderDate
FROM Customers
LEFT JOIN Orders ON Orders.CustomerID=Customers.CustomerID;

-- There is also RIGHT JOIN and FULL JOIN. The missing data is filled with NULL


