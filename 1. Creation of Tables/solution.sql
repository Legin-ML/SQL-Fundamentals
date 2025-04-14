CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary)
VALUES
    (1, 'John', 'Smith', 'Sales', 50000.00),
    (2, 'Jane', 'Doe', 'Marketing', 55000.00),
    (3, 'Alice', 'Brown', 'Sales', 48000.00),
    (4, 'Bob', 'Ross', 'IT', 60000.00);

SELECT * FROM Employees;