-- US Household Income Data Analysis
-- The queries explore and analyze household income data
-- First, I get and review the full dataset to set a baseline
-- Next, I identify states with the largest land and water areas
-- I then combine and compare data from the household income and statistics tables
-- To ensure accuracy, I check for discrepancies and remove records with zero income
-- I analyze income data to find states with the highest and lowest average incomes
-- Additional queries look at specific data types and summarize statistics based on record counts
-- Finally, I calculate average incomes by city for a detailed view of income distribution

-- Select All Data
-- Purpose: Get all rows and columns from the household income table for initial review
SELECT *
FROM us_project.us_household_income
;

-- Top 10 States by Land Area
-- Purpose: Find the top 10 states with the largest land areas
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

-- Top 10 States by Water Area
-- Purpose: Find the top 10 states with the largest water areas
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

-- Display Full Data for Household Income
SELECT *
FROM us_project.us_household_income
;

-- Display Full Data for Household Income Statistics
SELECT *
FROM us_project.us_household_income_statistics
;

-- Join Household Income and Statistics
-- Purpose: Combine data from household income and statistics tables where IDs match
SELECT *
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
ON u.id = us.id
;

-- Right Join to Find Missing Records
-- Purpose: Find records in the statistics table that don’t have matching entries in the income table
SELECT *
FROM us_project.us_household_income u
RIGHT JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE u.id IS NULL
;

-- Incorrect Use of INNER JOIN
-- Purpose: The query is incorrect because INNER JOIN cannot return NULL values for matching IDs
SELECT *
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE u.id IS NULL
;

-- Filter Non-Zero Means
-- Purpose: Get records where the average income is not zero
SELECT *
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
;

-- Detailed Join with Non-Zero Mean
-- Purpose: Get detailed records where the average income is not zero
SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
;

-- Bottom 5 States by Average Income
-- Purpose: Find the 5 states with the lowest average income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 -- Column 2 
LIMIT 5
;

-- Top 10 States by Average Income
-- Purpose: Find the 10 states with the highest average income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC -- Column 2 
LIMIT 10
;

-- Bottom 10 States by Average Income
-- Purpose: Find the 10 states with the lowest average income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 ASC -- Column 2 
LIMIT 10
;

-- Community Type Records
-- Purpose: Get records where the type is 'Community'
SELECT *
FROM us_project.us_household_income
WHERE Type = 'Community'
;

-- Statistics by Type
-- Purpose: Get statistics for each type with more than 100 entries, sorted by average median income
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC -- Column 4
LIMIT 20
;

-- City-Level Average Income
-- Purpose: Find the average income by city, sorted from highest to lowest
SELECT u.State_Name, City, ROUND(AVG(Mean),1) AS `Mean Avg`
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC
;