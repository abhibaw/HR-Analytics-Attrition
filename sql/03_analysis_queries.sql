Select * from employees;

-- 1. Overall attrition rate
SELECT 
    ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employees;

-- 2. Attrition rate by department
Select Department,
	COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) as attrition_pct
FROM employees
Group by Department
order by attrition_pct DESC;

-- 3 Attrition by jobrole and overtime (Window function for rank)
Select JobRole, OverTime,
	COUNT(*) As total,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) As attritions,
    RANK() OVER(Order by SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)*1.0/COUNT(*) DESC) AS risk_rank
from employees
group by JobRole, OverTime;

-- 4. Average tenure of employees who left vs stayed
SELECT Attrition,
	ROUND(AVG(YearsAtCompany), 2) AS avg_tenure,
    ROUND(AVG(MonthlyIncome),2) As avg_income
From employees
group by Attrition;

-- 5. salary hike vs attrition (CTE Example)
WITH hike_buckets AS (
    SELECT *,
        CASE 
            WHEN PercentSalaryHike < 15 THEN 'Low Hike'
            WHEN PercentSalaryHike BETWEEN 15 AND 20 THEN 'Medium Hike'
            ELSE 'High Hike'
        END AS hike_category
    FROM employees
)
SELECT hike_category, 
       COUNT(*) AS total,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS left_count,
       ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_pct
FROM hike_buckets
GROUP BY hike_category;

-- Top 5 Highest Paid Employees
SELECT EmployeeNumber,
       JobRole,
       MonthlyIncome
FROM employees
ORDER BY MonthlyIncome DESC
LIMIT 5;

-- Attrition by Gender
SELECT Gender,
       COUNT(*) AS total,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(
           SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
           2
       ) AS attrition_rate
FROM employees
GROUP BY Gender;

-- Department Salary Ranking (Window Function)
SELECT
    Department,
    JobRole,
    MonthlyIncome,
    DENSE_RANK() OVER (
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS salary_rank
FROM employees;

