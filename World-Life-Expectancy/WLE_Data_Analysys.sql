-- View all data
SELECT * 
FROM world_life_expectancy;

-- Life expectancy increase over 15 years
SELECT Country, 
    MIN(`life expectancy`), 
    MAX(`life expectancy`),
    ROUND(MAX(`life expectancy`) - MIN(`life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`life expectancy`) <> 0
AND MAX(`life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC;

-- Avg life expectancy and GDP (high to low)
SELECT Country,
    ROUND(AVG(`life expectancy`), 1) AS life_expectancy, 
    ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_expectancy > 0 
AND GDP > 0
ORDER BY life_expectancy DESC;

-- Avg life expectancy and GDP (low to high)
SELECT Country,
    ROUND(AVG(`life expectancy`), 1) AS life_expectancy, 
    ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_expectancy > 0 
AND GDP > 0
ORDER BY life_expectancy ASC;

-- Sort all data by GDP
SELECT *
FROM world_life_expectancy
ORDER BY GDP;

-- Flag high GDP countries
SELECT 
    Country,
    CASE
        WHEN GDP >= 15000 THEN 1 
        ELSE 0
    END AS High_GDP_Count
FROM world_life_expectancy;

-- Avg life expectancy for high/low GDP
SELECT 
    SUM(CASE WHEN GDP >= 15000 THEN 1 ELSE NULL END) AS High_GDP_Count,
    ROUND(AVG(CASE WHEN GDP >= 15000 THEN `life expectancy` END), 1) AS Avg_High_GDP_Life_Expectancy,
	SUM(CASE WHEN GDP <= 15000 THEN 1 ELSE NULL END) AS Low_GDP_Count,
    ROUND(AVG(CASE WHEN GDP <= 15000 THEN `life expectancy` END), 1) AS Avg_Low_GDP_Life_Expectancy
FROM world_life_expectancy;

-- View all data
SELECT *
FROM world_life_expectancy;

-- Avg life expectancy by status
SELECT Status,
	COUNT(DISTINCT Country),
	ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status;

-- View all data
SELECT *
FROM world_life_expectancy;

-- Avg life expectancy and BMI
SELECT Country,
    ROUND(AVG(`life expectancy`), 1) AS life_expectancy, 
    ROUND(AVG(BMI), 1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING ROUND(AVG(`life expectancy`), 1) > 1 
AND ROUND(AVG(BMI), 1) > 1
ORDER BY life_expectancy DESC;

-- View all data
SELECT *
FROM world_life_expectancy;

-- Rolling adult mortality for 'United' countries
SELECT Country,
       Year,
       `life expectancy`,
       `Adult Mortality`,
       (SELECT SUM(`Adult Mortality`)
        FROM world_life_expectancy AS w2
        WHERE w2.Country = w1.Country
          AND w2.Year <= w1.Year) AS Rolling_Total
FROM world_life_expectancy AS w1
WHERE Country LIKE '%United%';