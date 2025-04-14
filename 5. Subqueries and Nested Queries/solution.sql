

SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees WHERE Department = 'Sales'); -- Selects employees having greater than average salary

SELECT FirstName, LastName, Salary,
       (SELECT AVG(Salary) FROM Employees WHERE Department = Employees.Department) AS AvgDeptSalary -- Shows employees salaries along with their department's average salary
FROM Employees;

