-- View all income data
SELECT *
FROM us_project.us_household_income;

-- Top 10 states by land area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Top 10 states by water area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

-- View full income data
SELECT *
FROM us_project.us_household_income;

-- View full statistics data
SELECT *
FROM us_project.us_household_income_statistics;

-- Join income and stats tables
SELECT *
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
ON u.id = us.id;

-- Find stats records missing in income table
SELECT *
FROM us_project.us_household_income u
RIGHT JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE u.id IS NULL;

-- Example of incorrect inner join (will return nothing)
SELECT *
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE u.id IS NULL;

-- Filter out zero-income records
SELECT *
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0;

-- View non-zero income details
SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0;

-- Bottom 5 states by avg income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5;

-- Top 10 states by avg income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Bottom 10 states by avg income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 ASC
LIMIT 10;

-- Records of type 'Community'
SELECT *
FROM us_project.us_household_income
WHERE Type = 'Community';

-- Stats by type (100+ entries)
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20;

-- Avg income by city
SELECT u.State_Name, City, ROUND(AVG(Mean),1) AS `Mean Avg`
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY `Mean Avg` DESC;