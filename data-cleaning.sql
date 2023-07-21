--CREATE DATABASE employee;
	USE employee_management;
	select *
	from HumanResources
	order by employee_id


--Fixing hire_date

-- Adding new column named actual_hire_date
	ALTER TABLE HumanResources
	ADD actual_hire_date DATE;

-- Updating the new column with the date part of the existing hire_date column.
	UPDATE HumanResources
	SET actual_hire_date = CAST(hire_date AS DATE);

-- Removing the previous hire_date column
	ALTER TABLE HumanResources
	DROP COLUMN hire_date;


--Fixing birthdate



-- Adding new column named actual_hire_date
	ALTER TABLE HumanResources
	ADD fixed_birthdate DATE;

-- Updating the new column with the date part of the existing birthdate column.
	UPDATE HumanResources
	SET fixed_birthdate = CAST(birthdate AS DATE);

-- Removing the previous hire_date column
	ALTER TABLE HumanResources
	DROP COLUMN birthdate;

--Adding Age
	ALTER TABLE HumanResources
	ADD age INT;

--Fixing the termdate column
	UPDATE HumanResources
	SET termdate_fixed = TRY_CAST(termdate_fixed AS DATE)
	WHERE termdate_fixed IS NOT NULL AND termdate_fixed <> '';

	ALTER TABLE HumanResources
	ALTER COLUMN termdate_fixed DATE;

	UPDATE HumanResources
	SET termdate_fixed = NULL
	WHERE termdate_fixed = '1900-01-01';


-- Updating the "age" column with the calculated age
UPDATE HumanResources
SET age = DATEDIFF(YEAR, fixed_birthdate, GETDATE());

--Checking any mistakes in age (i.e. if there is a birthdate recorded with a future date)

--Method 1
	SELECT age
	FROM HumanResources
	WHERE age < 0;
--Method 2
	SELECT
		MIN(age) AS youngest,
		MAX(age) AS Oldest
	FROM HumanResources;
--Describe the table
	EXEC sp_help 'HumanResources'

