USE dental_company;

------ AUDIT MONITOR SYSTEM -----

#  CREATE AUDIT LOG TABLE

CREATE TABLE employee_audit_log (

    audit_id INT AUTO_INCREMENT PRIMARY KEY,

    employee_id VARCHAR(50),

    issue_type VARCHAR(100),

    issue_description VARCHAR(255),

    issue_severity VARCHAR(50),

    identified_date DATE,

    status VARCHAR(50)

);

# LOG MISSING SALARY ISSUES

INSERT INTO employee_audit_log (

    employee_id,
    issue_type,
    issue_description,
    issue_severity,
    identified_date,
    status

)

SELECT

    employee_id,

    'Missing Salary',

    'Employee record is missing salary information',

    'High',

    CURDATE(),

    'Open'

FROM employee_final_v2

WHERE salary IS NULL
   OR salary = '';

# LOG INVALID DEPARTMENTS

INSERT INTO employee_audit_log (

    employee_id,
    issue_type,
    issue_description,
    issue_severity,
    identified_date,
    status

)

SELECT

    employee_id,

    'Invalid Department',

    'Employee assigned to invalid or missing department',

    'Medium',

    CURDATE(),

    'Open'

FROM employee_final_v2

WHERE department_id IS NULL;

# LOG FUTURE HIRE DATES

INSERT INTO employee_audit_log (

    employee_id,
    issue_type,
    issue_description,
    issue_severity,
    identified_date,
    status

)

SELECT

    employee_id,

    'Future Hire Date',

    'Employee hire date occurs in the future',

    'Medium',

    CURDATE(),

    'Investigating'

FROM employee_final_v2

WHERE hire_date > CURDATE();

### LOG DUPLICATE EMPLOYEES

INSERT INTO employee_audit_log (

    employee_id,
    issue_type,
    issue_description,
    issue_severity,
    identified_date,
    status

)

SELECT

    employee_id,

    'Duplicate Employee',

    'Potential duplicate employee record detected',

    'High',

    CURDATE(),

    'Open'

FROM employee_final_v2

WHERE CONCAT(first_name, last_name) IN (

    SELECT CONCAT(first_name, last_name)

    FROM employee_final_v2

    GROUP BY first_name, last_name

    HAVING COUNT(*) > 1
);

## VIEW AUDIT RESULTS

SELECT *
FROM employee_audit_log;


# CREATE AUDIT SUMMARY REPORT

SELECT 
	issue_type, 
	COUNT(*) AS issue_count
FROM employee_audit_log
GROUP BY issue_type 
ORDER BY issue_count DESC; 

# CREATE AUDIT VEW

CREATE VIEW vw_audit_summary AS 

SELECT 
	issue_type,
	issue_severity,
	COUNT(*) AS issue_count 
FROM employee_audit_log 
GROUP BY 
	issue_type,
	issue_severity;

# TEST IT

SELECT *
FROM vw_audit_summary;