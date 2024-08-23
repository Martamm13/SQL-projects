-- World Life Expectancy Project (Exploratory Data Analysis)
-- The queries explore and analyze the world life expectancy dataset
-- Initial queries get the full dataset and check life expectancy trends
-- Further analysis looks at GDP and other factors affecting life expectancy

-- Select All Data
-- Purpose: Get all rows and columns from the world_life_expectancy table for a first look
SELECT * 
FROM world_life_expectancy
;

-- Life Expectancy Increase Over 15 Years
-- Purpose: Calculate the increase in life expectancy over 15 years for each country
SELECT Country, 
    MIN(`life expectancy`), 
    MAX(`life expectancy`),
    ROUND(MAX(`life expectancy`) - MIN(`life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY COUNTRY
HAVING MIN(`life expectancy`) <> 0
AND MAX(`life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;

-- Average Life Expectancy and GDP (Descending)
-- Purpose: Find the average life expectancy and GDP for each country, ordered by life expectancy from highest to lowest
SELECT Country,
    ROUND(AVG(`life expectancy`), 1) AS life_expectancy, 
    ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_expectancy > 0 
AND GDP > 0
ORDER BY life_expectancy DESC
;

-- Average Life Expectancy and GDP (Ascending)
-- Purpose: Find the average life expectancy and GDP for each country, ordered by life expectancy from lowest to highest
SELECT Country,
    ROUND(AVG(`life expectancy`), 1) AS life_expectancy, 
    ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_expectancy > 0 
AND GDP > 0
ORDER BY life_expectancy ASC
;

-- Order by GDP
-- Purpose: Get all data from the table and sort it by GDP
SELECT *
FROM world_life_expectancy
ORDER BY GDP
;

-- High GDP Indicator
-- Purpose: Create a flag for countries with GDP >= 15000

SELECT 
    Country,
    CASE
        WHEN GDP >= 15000 THEN 1 
        ELSE 0
    END AS High_GDP_Count
FROM world_life_expectancy
;

-- High and Low GDP Life Expectancy Averages
-- Purpose: Calculate the number of countries and average life expectancy for high and low GDP groups
SELECT 
    SUM(CASE WHEN GDP >= 15000 THEN 1 ELSE NULL END) AS High_GDP_Count,
    ROUND(AVG(CASE WHEN GDP >= 15000 THEN `life expectancy` END), 1) AS Avg_High_GDP_Life_Expectancy,
	SUM(CASE WHEN GDP <= 15000 THEN 1 ELSE NULL END) AS Low_GDP_Count,
    ROUND(AVG(CASE WHEN GDP <= 15000 THEN `life expectancy` END), 1) AS Avg_Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

-- Select All Data
-- Purpose: Get all rows and columns from the world_life_expectancy table
SELECT *
FROM world_life_expectancy
;

-- Status and Life Expectancy
-- Purpose: Count distinct countries and calculate the average life expectancy by status
SELECT Status,
	COUNT(DISTINCT Country),
	ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP by Status
;

-- Select All Data
-- Purpose: Get all rows and columns from the world_life_expectancy table
SELECT *
FROM world_life_expectancy
;

-- Life Expectancy and BMI
-- Purpose: Calculate the average life expectancy and BMI for each country, sorted by life expectancy
SELECT Country,
    ROUND(AVG(`life expectancy`), 1) AS life_expectancy, 
    ROUND(AVG(BMI), 1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING ROUND(AVG(`life expectancy`), 1) > 1 
AND ROUND(AVG(BMI), 1) > 1
ORDER BY life_expectancy DESC
;

-- Select All Data
-- Purpose: Get all rows and columns from the world_life_expectancy table
SELECT *
FROM world_life_expectancy
;

-- Rolling Total of Adult Mortality
-- Purpose: Calculate the rolling total of adult mortality for countries with 'United' in their name
SELECT Country,
       Year,
       `life expectancy`,
       `Adult Mortality`,
       (SELECT SUM(`Adult Mortality`)
        FROM world_life_expectancy AS w2
        WHERE w2.Country = w1.Country
          AND w2.Year <= w1.Year) AS Rolling_Total
FROM world_life_expectancy AS w1
WHERE Country LIKE '%United%'
;