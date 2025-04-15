CREATE TABLE employees (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    department TEXT NOT NULL,
    salary REAL NOT NULL
);

INSERT INTO employees (emp_name, department, salary) VALUES
('Alice', 'HR', 50000),
('Bob', 'HR', 60000),
('Charlie', 'HR', 60000),
('Diana', 'Engineering', 80000),
('Eve', 'Engineering', 85000),
('Frank', 'Engineering', 80000),
('Grace', 'Marketing', 45000),
('Heidi', 'Marketing', 47000);


-----------------

SELECT 
    emp_id,
    emp_name,
    department,
    salary,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS dept_salary_rank
FROM employees;


SELECT 
    emp_id,
    emp_name,
    department,
    salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees;


SELECT 
    emp_id,
    emp_name,
    department,
    salary,
    LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS prev_salary,
    LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_salary
FROM employees;