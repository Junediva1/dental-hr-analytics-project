# Dental Company Workforce Analytics & Audit Reporting System

## Project Overview
This project simulates a large multi-location dental organization using realistic HR and workforce data in MySQL. The goal of the project was to design, clean, validate, and analyze messy enterprise-style employee and department datasets while building reporting and audit-monitoring systems.
The project focuses heavily on:
•	relational database design
•	data cleaning
•	data quality auditing
•	workforce analytics
•	SQL reporting architecture
•	enterprise-style ETL workflows
The datasets intentionally included messy real-world data problems such as:
•	duplicate records
•	missing salary information
•	invalid department assignments
•	broken manager relationships
•	inconsistent formatting
•	future hire dates
•	NULL values
This project was designed to simulate the type of operational HR and workforce data challenges analysts encounter in enterprise environments.
## Business Problem
Large organizations often struggle with:
•	incomplete workforce data
•	inconsistent employee records
•	invalid relationships between systems
•	poor reporting quality
•	operational data integrity issues
The objective of this project was to: 1. Import raw messy CSV datasets into MySQL 2. Create staging and cleaning workflows 3. Validate relational integrity 4. Build production-ready reporting tables 5. Develop workforce analytics queries 6. Create a SQL-based audit monitoring system

## Technologies Used
Technologies Used
•	MySQL
•	DBeaver / MySQL Workbench
•	SQL
•	CSV datasets
•	Relational database modeling

## Database Structure
Raw Staging Tables
employees
Raw imported employee dataset containing intentionally messy HR data.
departments
Raw imported department dataset containing duplicate and inconsistent department records.

## Key Features 
Cleaning Tables
# clean_employees
Initial employee cleaning layer used to:
•	trim spaces
•	standardize formatting
•	remove duplicate rows
•	prepare for validation
# clean_departments
Initial department cleaning layer used for:
•	deduplication
•	formatting cleanup
•	standardization
# Production Tables
# employee_final
Production-ready employee transformation table.
# employee_final_v2
Validated workforce analytics table used for reporting and business analysis.
# department_final
Deduplicated and validated department dimension table.# SQL Concepts Used
# Relational Database Design
•	Primary keys
•	Foreign keys
•	Referential integrity
•	Self-referencing relationships
# Data Cleaning
•	TRIM()
•	NULL handling
•	CASE statements
•	CAST()
•	DISTINCT
•	Deduplication
# Data Validation
•	Invalid relationship checks
•	Duplicate detection
•	Missing value auditing
•	Data type standardization
# SQL Reporting
•	Views
•	Aggregations
•	GROUP BY
•	ORDER BY
•	Workforce metrics
•	Compensation analysis
Audit Monitoring
•	Audit log tables
•	Issue tracking
•	Severity classification
•	Data quality reporting
## Workforce Analytics Reporting System
The project includes a SQL-based HR reporting system using reusable SQL views.
# Reporting Views
# vw_department_summary
Provides:
•	employee counts by department
•	average salaries
•	highest salaries
•	lowest salaries
# vw_salary_analysis
Provides:
•	compensation analysis by role
•	salary ranges
•	average compensation
# vw_data_quality
Monitors:
•	missing salaries
•	missing departments
•	missing managers
# vw_hiring_trends
Tracks workforce hiring activity.
# vw_department_budget
Analyzes:
•	department budgets
•	budget allocation
•	budget per employee
# Audit Monitoring System
An employee audit logging system was created to monitor workforce data quality issues.
# employee_audit_log
Tracks:
•	missing salary information
•	invalid departments
•	duplicate employees
•	future hire dates
•	data quality issues
# Audit Features
•	issue severity tracking
•	issue descriptions
•	audit dates
•	audit statuses
•	operational reporting
# Example Business Questions Answered
# Workforce Analytics
Which departments have the largest workforce?
Which departments have the highest payroll?
Which roles have the highest average salaries?
What are the hiring trends over time?
# Data Quality Analytics
How many employees are missing salary information?
Which departments contain incomplete workforce records?
Are duplicate employee records present?
Are invalid relationships present in the data?
# Operational Reporting
Which departments require data remediation?
What are the most common workforce data issues?
Which audit issues are highest severity?
# Example SQL Features Used
CREATE TABLE
CREATE VIEW
INSERT INTO
CASE statements
Aggregate functions
JOINs
GROUP BY
ORDER BY
Subqueries
Data validation logic
Reporting architecture
# Key Takeaways
This project demonstrates practical SQL skills in:
enterprise database workflows
workforce analytics
data governance
audit monitoring
data quality management
operational reporting
relational database design
The project reflects realistic enterprise-style analytics work rather than simple beginner SQL exercises using perfectly clean datasets.
# Future Enhancements
Potential future improvements include:
stored procedures
triggers
advanced window functions
indexing and performance optimization
automated ETL workflows
dashboard integration
additional audit rules
organizational hierarchy analysis


# Author
Michelle Houston
SQL Workforce Analytics & Data Quality Project
