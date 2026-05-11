


# VERIFYING EVERYTHING

SELECT COUNT(*)
FROM employees;

SELECT COUNT(*)
FROM departments;

# DATA EXPLORATION 

# PREVIEW DATA

SELECT *
FROM employees 
LIMIT 10;

# FIND MISSING SALARIES

SELECT *
FROM employees 
WHERE salary IS NULL
	OR salary = '';

# FIND DUPLICATE EMPLOYEES

SELECT 
	 first_name,
	 last_name,
	 COUNT(*) AS duplicate_count
FROM employees 
GROUP BY first_name, last_name 
HAVING COUNT(*) > 1;


# FIND FUTURE HIRE DATES (DATES ARE VARCHAR RIGHT NOW)

SELECT *
FROM employees
WHERE hire_date > CURDATE();

