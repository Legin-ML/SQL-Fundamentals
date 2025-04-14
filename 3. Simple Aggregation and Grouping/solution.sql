SELECT AVG(Salary) AS AverageSalary FROM Employees; --Calculates the average salary of all employees

SELECT Department, COUNT(*) AS EmployeeCount FROM Employees GROUP BY Department;  -- Lists number of employees in each department

SELECT Department, COUNT(*) AS EmployeeCount FROM Employees GROUP BY Department HAVING COUNT(*) > 1; -- Finds the department with more than one employee

