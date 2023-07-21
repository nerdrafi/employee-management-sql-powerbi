-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
	SELECT gender, COUNT(*) AS total_employees
	FROM HumanResources
	WHERE age >= 18 AND termdate_fixed IS NULL
	GROUP BY gender
	ORDER BY total_employees DESC;


-- 2. What is the race/ethnicity breakdown of employees in the company?
	SELECT race, COUNT(*) AS total_employees
	FROM HumanResources
	WHERE age >= 18 AND termdate_fixed IS NULL
	GROUP BY race
	ORDER BY total_employees DESC;

-- 3. What is the age distribution of employees in the company?
	SELECT
	MIN(age) AS youngest,
	MAX(age) AS Oldest
	FROM HumanResources
	WHERE age >= 18 AND termdate_fixed IS NULL

	SELECT
    CASE
        WHEN age >= 18 AND age < 24 THEN '18-24'
        WHEN age >= 25 AND age < 34 THEN '25-34'
        WHEN age >= 35 AND age < 44 THEN '35-44'
        WHEN age >= 45 AND age < 54 THEN '45-54'
        WHEN age >= 55 AND age < 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS total_employees
	FROM HumanResources
	WHERE age >= 18 AND termdate_fixed IS NULL
	GROUP BY  
		CASE
			WHEN age >= 18 AND age < 24 THEN '18-24'
			WHEN age >= 25 AND age < 34 THEN '25-34'
			WHEN age >= 35 AND age < 44 THEN '35-44'
			WHEN age >= 45 AND age < 54 THEN '45-54'
			WHEN age >= 55 AND age < 64 THEN '55-64'
			ELSE '65+'
    END
	ORDER BY age_group;


	SELECT
    CASE
        WHEN age >= 18 AND age < 24 THEN '18-24'
        WHEN age >= 25 AND age < 34 THEN '25-34'
        WHEN age >= 35 AND age < 44 THEN '35-44'
        WHEN age >= 45 AND age < 54 THEN '45-54'
        WHEN age >= 55 AND age < 64 THEN '55-64'
        ELSE '65+'
    END AS age_group, gender,
    COUNT(*) AS total_employees
	FROM HumanResources
	WHERE age >= 18 AND termdate_fixed IS NULL
	GROUP BY  
		CASE
			WHEN age >= 18 AND age < 24 THEN '18-24'
			WHEN age >= 25 AND age < 34 THEN '25-34'
			WHEN age >= 35 AND age < 44 THEN '35-44'
			WHEN age >= 45 AND age < 54 THEN '45-54'
			WHEN age >= 55 AND age < 64 THEN '55-64'
			ELSE '65+'
    END, gender
	ORDER BY age_group, gender;


-- 4. How many employees work at headquarters versus remote locations?
	SELECT
		location,
		COUNT(*) AS total_employees
	FROM HumanResources
	WHERE age >= 18 AND termdate IS NULL
	GROUP BY location;



-- 5. What is the average length of employment for employees who have been terminated?.
	SELECT
		AVG(DATEDIFF(DAY, actual_hire_date, termdate_fixed))/365 AS average_year_length_of_employment
	FROM HumanResources
	WHERE termdate_fixed IS NOT NULL;


-- 6. How does the gender distribution vary across departments and job titles?
	SELECT
		department,
		gender,
		COUNT(*) AS total_employees
	FROM HumanResources
	WHERE age >= 18 AND termdate_fixed IS NULL
	GROUP BY department, gender
	ORDER BY department;





-- 7. What is the distribution of job titles across the company?
	SELECT jobtitle, COUNT(*) AS total_employees
	FROM HumanResources
	WHERE age >= 18 AND termdate_fixed IS NULL
	GROUP BY jobtitle
	ORDER BY jobtitle DESC;



-- 8. Which department has the highest turnover rate?

	SELECT
		department,
		COUNT(*) AS total_employees,
		SUM(CASE WHEN termdate_fixed IS NOT NULL THEN 1 ELSE 0 END) AS total_terminated,
		SUM(CASE WHEN termdate_fixed IS NOT NULL THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT) AS turnover_rate
	FROM HumanResources
	GROUP BY department
	ORDER BY turnover_rate DESC;


-- 9. What is the distribution of employees across locations by city and state?
	SELECT
		location_state,
		COUNT(*) AS total_employees
	FROM HumanResources
	GROUP BY location_state
	ORDER BY total_employees DESC;


-- 10. How has the company's employee count changed over time based on hire and term dates?
	SELECT
    [year],
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((CAST(hires - terminations AS FLOAT) / hires) * 100, 2) AS net_change_percentage
	FROM (
		SELECT
			YEAR(actual_hire_date) AS [year],
			COUNT(*) AS hires,
			SUM(CASE WHEN termdate_fixed IS NOT NULL AND termdate_fixed <= GETDATE() THEN 1 ELSE 0 END) AS terminations
		FROM HumanResources
		WHERE age >= 18
		GROUP BY YEAR(actual_hire_date)
	) AS subquery
	ORDER BY [year] ASC;


-- 11. What is the tenure distribution for each department?
	SELECT
    department,
    ROUND(AVG(DATEDIFF(DAY, actual_hire_date, termdate_fixed) / 365), 0) AS avg_tenure
	FROM HumanResources
	WHERE termdate_fixed <= GETDATE() AND termdate IS NOT NULL AND age >= 18
	GROUP BY department;