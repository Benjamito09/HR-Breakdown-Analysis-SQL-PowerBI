-- QUESTIONS

-- 1. Gender breakdown of employees?

SELECT gender, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00'
GROUP BY gender;

-- 2. Race/Ethnicity breakdown of employees?

SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00'
GROUP BY race
ORDER BY count(*) DESC;

-- 3. Age distribution of employees?

SELECT
	min(age) AS youngest,
    max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00';

SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
		WHEN age >= 25 AND age <= 34 THEN '25-34'
		WHEN age >= 35 AND age <= 44 THEN '35-44'
		WHEN age >= 45 AND age <= 54 THEN '45-54'
		WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
	count(*) AS count
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00'
GROUP BY age_group
ORDER BY age_group;

SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
		WHEN age >= 25 AND age <= 34 THEN '25-34'
		WHEN age >= 35 AND age <= 44 THEN '35-44'
		WHEN age >= 45 AND age <= 54 THEN '45-54'
		WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
	count(*) AS count
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. Employees working at headquarters versus remote locations?

SELECT location, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00'
GROUP BY location;

-- 5. Average length of employment for previously terminated employees?

SELECT
	round(AVG(datediff(termdate, hire_date))/365,0) AS avg_length_employment
FROM hr
WHERE termdate <= curdate() AND age >= 18 AND termdate !='0000-00-00';

-- 6. Gender distribution across departments and job titles?

SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. Distribution of job titles across the company?

SELECT jobtitle, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Highest turnover rate by department?

SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM (
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate != '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0
END) AS terminated_count
FROM hr
WHERE age >= 18
GROUP BY department
) AS turnover_subquery
ORDER BY termination_rate DESC;

-- 9. Distribution of employees by city and state?

SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate ='0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- 10. Employee count over time based on hire and termination dates?

SELECT year, 
	hires, 
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations)/hires * 100, 2) AS net_change_percent
FROM(
	SELECT 
		YEAR(hire_date) AS year,
        count(*) AS hires,
        SUM(CASE WHEN termdate != '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0
END) AS terminations
FROM hr
WHERE age >= 18
GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY YEAR ASC;

-- 11. Tenure distribution by department?

SELECT department, round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate != '0000-00-00' AND age >= 18
GROUP BY department;
