USE dental_company;

# CREATE CLEAN EMPLOYEE TABLE 

CREATE TABLE clean_employees AS 
SELECT DISTINCT
	TRIM(employee_id) AS employee_id,
	TRIM(first_name) AS first_name,
	TRIM(last_name) AS last_name,
	TRIM(salary) AS salary,
	TRIM(department_id) AS department_id,
	TRIM(job_id) AS job_id,
	TRIM(manager_id) AS manager_id,
	TRIM(hire_date) AS hire_date
FROM employees;

# CREATE CLEAN DEPARTMENT TABLE

CREATE TABLE clean_departments AS 
SELECT DISTINCT
	 TRIM(department_id) AS department_id,
	 TRIM(department_name) AS department_name,
	 TRIM(location_id) AS location_id,
	 TRIM(department_head_id) AS department_head_id,
	 TRIM(budget_amount) AS budget_amount,
	 TRIM(floor_number) AS floor_number,
	 TRIM(created_date) AS created_date
FROM departments;

--- DATA QUALITY AUDITING

# MISSING SALARIES

SELECT *
FROM clean_employees 
WHERE salary IS NULL 
	OR salary = '';

# DUPLICATE EMPLOYEES

SELECT  
	first_name, 
	last_name, 
	COUNT(*) AS duplicate_count
FROM clean_employees 
GROUP BY first_name, last_name 
HAVING COUNT(*) > 1;

# INVALID DEPARTMENT ID'S

SELECT *
FROM clean_employees 
WHERE department_id NOT IN (
    SELECT department_id 
    FROM clean_departments 
);

# CHECKING FOR DUPLICATES EMPLOYEE ID'S

SELECT 
	employee_id,
	COUNT(*) AS duplicate_count 
FROM clean_employees 
GROUP BY employee_id 
HAVING COUNT(*) > 1;

# CHECK FOR NULL EMPLOYEE ID'S 

SELECT *
FROM clean_employees 
WHERE employee_id IS NULL 
	OR employee_id = '';

# CHECK INVALID DEPARTMENT RELATIONSHIPS

SELECT *
FROM clean_employees 
WHERE department_id NOT IN (
	SELECT department_id 
	FROM clean_departments 
);

# CHECK INVALID MANAGER ID'S

SELECT *
FROM clean_employees
WHERE manager_id NOT IN (
    SELECT employee_id
    FROM clean_employees
)
AND manager_id IS NOT NULL
AND manager_id <> '';

--- CREATING A TRUE FINAL EMPLOYEE TABLE

# REMOVE INVALID MANAGER ID'S

CREATE TABLE employee_final AS 
SELECT 
	employee_id,
	first_name,
	last_name,
	
	CASE
		WHEN salary = '' THEN NULL
		ELSE salary
	END AS salary,
	
	department_id,
	job_id, 
	
	CASE
		WHEN manager_id NOT IN (
			SELECT employee_id
			FROM clean_employees
		)
		THEN NULL
		ELSE manager_id
	END AS manager_id,
	
	hire_date
FROM clean_employees;

# CHECK RESULT

SELECT *
FROM employee_final
LIMIT 20;

# VALIDATE AGAIN

SELECT *
FROM employee_final
WHERE manager_id NOT IN (
	SELECT employee_id
	FROM employee_final
)
AND manager_id IS NOT NULL; 


--- CLEAN DEPARTMENT RELATIONSHIPS

SELECT *
FROM employee_final
WHERE department_id NOT IN(
	SELECT department_id
	FROM clean_departments
);

--- CREATED ANOTHER CLEAN VERSION:

CREATE TABLE employee_final_v2 AS
SELECT
    employee_id,
    first_name,
    last_name,
    salary,

    CASE
        WHEN department_id NOT IN (
            SELECT department_id
            FROM clean_departments
        )
        THEN NULL
        ELSE department_id
    END AS department_id,

    job_id,
    manager_id,
    hire_date
FROM employee_final;


--- ADD PRIMARY KEYS & FOREIGN KEYS

ALTER TABLE employee_final_v2
ADD PRIMARY KEY (employee_id);


SELECT
    department_id,
    COUNT(*) AS duplicate_count
FROM clean_departments
GROUP BY department_id
HAVING COUNT(*) > 1;

--- REMOVE DUPLICATE DEPARTMENT ID'S, KEEP ONE DEPARTMENT RECORD PER ID
--- DEDUPLICATION AND STANDARDIZATION 

CREATE TABLE department_final AS
SELECT
    department_id,
    MIN(department_name) AS department_name,
    MIN(location_id) AS location_id,
    MIN(department_head_id) AS department_head_id,
    MIN(budget_amount) AS budget_amount,
    MIN(floor_number) AS floor_number,
    MIN(created_date) AS created_date
FROM clean_departments
WHERE department_id IS NOT NULL
  AND department_id <> ''
GROUP BY department_id;

--- THEN ADD PRIMARY KEY

ALTER TABLE department_final
ADD PRIMARY KEY (department_id);

-- THEN ADD FOREIGN KEY

ALTER TABLE employee_final_v2
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id)
REFERENCES department_final(department_id);


--- THE JOINS DID NOT MATCH / INVESTICATING THE VALUES

SELECT DISTINCT department_id
FROM employee_final_v2
LIMIT 20;


SELECT DISTINCT department_id
FROM department_final
LIMIT 20;

---- USE TRIM IN THE JOIN

SELECT 
	d.department_name,
	COUNT(e.employee_id) AS employee_count
FROM employee_final_v2 e
JOIN department_final d
	ON TRIM(e.department_id) = TRIM(d.department_id)
GROUP BY d.department_name 
ORDER BY employee_count DESC; 


DROP TABLE employee_final_v2;

CREATE TABLE employee_final_v2 AS
SELECT
    employee_id,
    first_name,
    last_name,
    salary,

    CASE
        WHEN TRIM(department_id) NOT IN (
            SELECT TRIM(department_id)
            FROM department_final
        )
        THEN NULL
        ELSE TRIM(department_id)
    END AS department_id,

    job_id,
    manager_id,
    hire_date
FROM employee_final;

DROP TABLE employee_final;

DROP TABLE employee_final_v2;


CREATE TABLE employee_final AS
SELECT
    TRIM(employee_id) AS employee_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    NULLIF(TRIM(salary), '') AS salary,
    TRIM(department_id) AS department_id,
    TRIM(job_id) AS job_id,

    CASE
        WHEN TRIM(manager_id) NOT IN (
            SELECT TRIM(employee_id)
            FROM clean_employees
        )
        THEN NULL
        ELSE TRIM(manager_id)
    END AS manager_id,

    TRIM(hire_date) AS hire_date
FROM clean_employees;

SELECT DISTINCT department_id
FROM employee_final;


CREATE TABLE employee_final_v2 AS
SELECT
    employee_id,
    first_name,
    last_name,
    salary,

    CASE
        WHEN department_id NOT IN (
            SELECT department_id
            FROM department_final
        )
        THEN NULL
        ELSE department_id
    END AS department_id,

    job_id,
    manager_id,
    hire_date
FROM employee_final;



SELECT DISTINCT department_id
FROM employee_final;

DROP TABLE employee_final_v2;

CREATE TABLE employee_final_v2 AS
SELECT
    employee_id,
    first_name,
    last_name,
    salary,

    CASE
        WHEN TRIM(department_id) = ''
             OR department_id IS NULL
        THEN NULL

        WHEN CAST(CAST(TRIM(department_id) AS DECIMAL(10,1)) AS UNSIGNED) NOT IN (
            SELECT department_id
            FROM department_final
        )
        THEN NULL

        ELSE CAST(CAST(TRIM(department_id) AS DECIMAL(10,1)) AS UNSIGNED)

    END AS department_id,

    job_id,
    manager_id,
    hire_date

FROM employee_final;

SELECT DISTINCT department_id
FROM employee_final_v2;

SELECT DISTINCT manager_id
FROM employee_final_v2
LIMIT 20;

DROP TABLE employee_final_v2;

CREATE TABLE employee_final_v2 AS
SELECT
    employee_id,
    first_name,
    last_name,
    salary,

    CASE
        WHEN TRIM(department_id) = ''
             OR department_id IS NULL
        THEN NULL

        ELSE CAST(CAST(TRIM(department_id) AS DECIMAL(10,1)) AS UNSIGNED)

    END AS department_id,

    job_id,

    TRIM(manager_id) AS manager_id,

    hire_date

FROM employee_final;