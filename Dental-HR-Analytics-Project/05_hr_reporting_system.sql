USE dental_company;

------- WORKFORCE OVERVIEW VIEW --------

# EXCECUTIVE HR SUMMARY

SELECT *
FROM vw_department_summary;

# COMPENSATION ANALYTICS VIEW

CREATE VIEW vw_salary_analysis AS  

SELECT 
	job_id, 
	
	COUNT(*) AS employee_count, 
	
	ROUND(
		AVG(CAST(salary as DECIMAL(10,2))), 
		2
	) AS avg_salary, 
	
	ROUND(
		MAX(CAST(salary AS DECIMAL(10,2))),
		2
	) AS max_salary,
	
	ROUND( 
		MIN(CAST(salary AS DECIMAL(10,2))),
		2
	) AS min_salary
	
FROM employee_final_v2 
WHERE salary IS NOT NULL
GROUP BY job_id;

# TEST IT ##

SELECT *
FROM vw_salary_analysis;


------ Data Quality Reporting View ------

CREATE VIEW vw_data_quality AS 

SELECT  

	SUM( 
		CASE
			WHEN salary IS NULL 
			THEN 1 
			ELSE 0 
		END
	) AS missing_salary,
	
	SUM(
		CASE
			WHEN department_id IS NULL  
			THEN 1 
			ELSE 0 
		END
	) AS missing_deparment,
	
	SUM(
		CASE
			WHEN manager_id IS NULL
			THEN 1
			ELSE 0
		END
	) AS missing_manager
FROM employee_final_v2;



## TEST IT ##

SELECT *
FROM vw_data_quality;


------- OPERATIONAL DATA QUALITY MONITORING ------

# HIRING TRENDS VIEW

CREATE VIEW vw_hiring_trends AS

SELECT 
	hire_date,
	COUNT(*) AS hires
FROM employee_final_v2 
GROUP BY hire_date
ORDER BY hires DESC;


# TEST IT

SELECT *
FROM  vw_hiring_trends;

# DEPARTMENT BUDGET REPORTING

CREATE VIEW vw_department_budget AS

SELECT
    d.department_name,

    d.budget_amount,

    COUNT(e.employee_id) AS employee_count,

    ROUND(
        d.budget_amount / COUNT(e.employee_id),
        2
    ) AS budget_per_employee

FROM department_final d

LEFT JOIN employee_final_v2 e
    ON d.department_id = e.department_id

GROUP BY
    d.department_name,
    d.budget_amount;

# TEST IT 

SELECT * 
FROM vw_department_budget; 

