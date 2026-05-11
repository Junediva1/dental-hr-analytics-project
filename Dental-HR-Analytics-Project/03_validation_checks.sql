USE dental_company;

--- VERIFY FINAL TABLES

SHOW TABLES;

# STEP 1 - Employee Count

SELECT COUNT(*) AS total_employees
FROM employee_final_v2;

# STEP 2 - Total Payroll

SELECT 
	ROUND(SUM(salary),2) AS total_payroll  
FROM employee_final_v2;

# STEP 3 - AVERAGE SALARY

SELECT 
	ROUND(AVG(CAST(salary AS DECIMAL(10,2))),2) AS avg_salary
FROM employee_final_v2;  

# STEP 4 - EMPLOYEES BY DEPARTMENT

SELECT 
	d.department_name,
	COUNT(e.employee_id) AS employee_count
FROM employee_final_v2 e
JOIN department_final d
	ON e.department_id = d.department_id 
GROUP BY d.department_name 
ORDER BY employee_count DESC;


--- STEP 5 Highest Paying Department

SELECT 
	d.department_name,
	ROUND(AVG(CAST(e.salary AS DECIMAL(10,2))),2) AS avg_department_salary 
FROM employee_final_v2 e
JOIN department_final d
	ON e.department_id = d.department_id 
WHERE e.salary IS NOT NULL 
GROUP BY d.department_name 
ORDER BY avg_department_salary DESC; 

--- STEP 6 - HIRING TRENDS

SELECT 
	YEAR(hire_date) AS hire_year, 
	COUNT(*) AS hires
FROM employee_final_v2 
GROUP BY YEAR(hire_date) 
ORDER BY hire_year; 


--- STEP 7 DATA QUALITY 

# MISSING SALARIES

SELECT COUNT(*) AS missing_salary_count
FROM employee_final_v2
WHERE salary IS NULL
   OR salary = '';

# EMPLOYEES MISSING DEPARTMENTS

SELECT COUNT(*) AS missing_department_count
FROM employee_final_v2 
WHERE department_id IS NULL 
   OR department_id = '';

# INVALID HIRE DATES

SELECT *
FROM employee_final_v2 
WHERE hire_date > CURDATE();


----------- ADVANCE BUSINESS ANALYTICS ------

--------- SALARY ANALYTICS------

# HIGHEST PAID EMPLOYEES

SELECT  
	first_name,
	last_name,
	salary
FROM employee_final_v2 
ORDER BY CAST(salary AS DECIMAL (10,2)) DESC
LIMIT 10;

# LOWEST PAID EMPLOYEES

SELECT 
     first_name,
     last_name, 
     salary
FROM employee_final_v2 
WHERE salary IS NOT NULL 
ORDER BY CAST(salary AS DECIMAL(10,2))
LIMIT 10;

# SALARY DISTRIBUTION BY JOB # COMPENSATION ANALYTICS 

SELECT 
	job_id,
	COUNT(*) AS employee_count,
	ROUND(AVG(CAST(salary AS DECIMAL(10,2))),2) AS avg_salary,
	ROUND(MAX(CAST(salary AS DECIMAL(10,2))),2) AS highest_salary,
	ROUND(MIN(CAST(salary AS DECIMAL(10,2))),2) AS lowest_salary
FROM employee_final_v2 
WHERE salary IS NOT NULL 
GROUP BY job_id 
ORDER BY avg_salary DESC;

------- MANAGER HEIRARCHY ANALYSIS------

# COUNT DIRECT REPORTS PER MANAGER

SELECT
    manager_id,
    COUNT(*) AS direct_reports
FROM employee_final_v2
WHERE manager_id IS NOT NULL
GROUP BY manager_id
ORDER BY direct_reports DESC;


# COMPENSATION ANALYTICS

SELECT
	job_id,
	ROUND(AVG(CAST(salary AS DECIMAL(10,2))),2) AS avg_salary
FROM employee_final_v2 
WHERE salary IS NOT NULL 
GROUP BY job_id 
ORDER BY avg_salary DESC; 

# DEPARTMENT WORKFORCE ANALYSIS 

SELECT  
	d.department_name,
	COUNT(*) AS employee_count
FROM employee_final_v2 e
JOIN department_final d
	ON e.department_id = d.department_id 
GROUP BY d.department_name 
ORDER BY employee_count DESC;

# DATA QUALITY REPORTING

SELECT 
	SUM(CASE WHEN salary IS NULL THEN 1 ELSE 0 END) AS missing_salary, 
	SUM(CASE WHEN department_id IS NULL THEN 1 ELSE 0 END) AS missing_department
FROM employee_final_v2;


# DUPLICATE NAME INVESTIGATION

SELECT 
	first_name, 
	last_name, 
	COUNT(*) AS duplicate_count
FROM employee_final_v2 
GROUP BY first_name, last_name 
HAVING COUNT(*) > 1 
ORDER BY duplicate_count DESC;

----- DEPARTMENT BUDGET ANALYTICS ------

# BUDGET VS HEADCOUNT

SELECT 
	d.department_name, 
	d.budget_amount, 
	COUNT(e.employee_id) AS employee_count
FROM department_final d
LEFT JOIN employee_final_v2 e 
	ON d.department_id = e.department_id 
GROUP BY 
	d.department_name, 
	d.budget_amount 
ORDER BY employee_count DESC; 

# BUDGET PER EMPLOYEE

SELECT 
	d.department_name, 
	ROUND( 
		d.budget_amount / COUNT(e.employee_id),
		2
	) AS budget_per_employee 
FROM department_final d
LEFT JOIN employee_final_v2 e 
	ON d.department_id = e.department_id 
GROUP BY 
	d.department_name, 
	d.budget_amount 
ORDER BY budget_per_employee DESC; 



----------- ORGANIZATIONAL STRUCTURE ANALYTICS----------
# HIRING TRENDS ANALYSIS

SELECT 
	hire_date,
	COUNT(*) AS hires
FROM employee_final_v2 
GROUP BY hire_date 
ORDER BY hires DESC; 

# EMPLOYEE HAIRE BY YEAR

SELECT 
	YEAR(STR_TO_DATE(hire_date, '%Y-%m-%d')) AS hire_year, 
	COUNT(*) AS hires
FROM employee_final_v2 
WHERE hire_date IS NOT NULL
GROUP BY hire_year 
ORDER BY hire_year;

# HIRING BY DEPARTMENT

SELECT  
	d.department_name, 
	COUNT(*) AS hires
FROM employee_final_v2 e
JOIN department_final d
	ON e.department_id = d.department_id 
GROUP BY d.department_name 
ORDER BY hires DESC; 


------- - WINDOW FUNCTIONS ------ 

SELECT 
	first_name,
	last_name,
	salary, 
	
	RANK() OVER (
		ORDER BY CAST(salary AS DECIMAL(10,2)) DESC
	) AS salary_rank
	
FROM employee_final_v2;


# SALARY RANKING

SELECT  
	first_name,
	last_name,
	salary,
	RANK() OVER( 
		ORDER BY CAST(salary AS DECIMAL(10,2)) DESC
	) AS salary_rank
FROM employee_final_v2;


# SALARY RANK WITHIN DEPARTMENT

SELECT 
	department_id,
	first_name,
	last_name,
	salary,
	
	RANK() OVER (
		PARTITION BY department_id 
		ORDER BY CAST(salary AS DECIMAL(10,2)) DESC
	) AS dept_salary_rank

FROM employee_final_v2;


------- COMMON TABLE EXPRESSIONS (CTE) --------------------

WITH department_payroll AS (

	SELECT 
		department_id,
		SUM(CAST(salary AS DECIMAL(10,2))) AS total_payroll
		
	FROM employee_final_v2
	WHERE salary IS NOT NULL
	
	GROUP BY department_id
)

SELECT *
FROM department_payroll
ORDER BY total_payroll DESC; 


------- WORKFORCE COST EFFICIENCY ANALYSIS-----

# CREATE SQL VIEWS

CREATE VIEW vw_department_summary AS 
SELECT 
	d.department_name, 
	COUNT(e.employee_id) AS employee_count,
	ROUND(AVG(CAST(e.salary AS DECIMAL(10,2))),2) AS avg_salary
FROM employee_final_v2 e
JOIN department_final d
	ON e.department_id = d.department_id
GROUP BY d.department_name;

SELECT *
FROM vw_department_summary; 

------- CREATED STORE PROCEDURES -------



CREATE PROCEDURE GetDepartmentEmployees(IN dept_id INT)
BEGIN
	SELECT 
		first_name,
		last_name,
		salary
	FROM employee_final_v2
	WHERE department_id = dept_id; 
END 

CALL GetDepartmentEmployees(101);

-------- TRIGGERS ----------

# AUTOMATICALLY LONG SALARY CHANGES

CREATE TABLE salary_change_log (
	log_id INT AUTO_INCREMENT PRIMARY KEY,
	employee_id VARCHAR(50),
	old_salary DECIMAL(10,2),
	new_salary DECIMAL(10,2),
	change_date DATETIME 
);

# THEN CREATE A TRIGGER

CREATE TRIGGER trg_salary_update

AFTER UPDATE 
ON employee_final_v2

FOR EACH ROW

BEGIN 
	
	IF OLD.salary <> NEW.salary THEN
	
		INSERT INTO salary_change_log (
			employee_id,
			old_salary,
			new_salary,
			change_date
			
		)
		
		VALUES (
			NEW.employee_id,
			OLD.salary,
			NEW.salary,
			NOW()
		);
	END IF;
END


