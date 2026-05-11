USE dental_company;


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
