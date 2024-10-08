-- World Life Expectancy Project (Data Cleaning)
-- The following SQL script is designed to clean and preprocess the world life expectancy dataset
-- It includes steps to identify and remove duplicate records, update missing status values, and fill in missing life expectancy values
-- Each query is explained with comments for clarity

-- Get all data
-- Purpose: Get all records from the world_life_expectancy table for a first look
SELECT * 
FROM world_life_expectancy
;

-- Identify duplicate records
-- Purpose: Find duplicate records based on the combination of Country and Year
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

-- Find duplicate rows
-- Purpose: Assign a row number to each record and select those with row numbers greater than 1 to identify duplicates
SELECT * 
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) AS Row_Table
WHERE Row_Num >1
;

-- Delete duplicate records
-- Purpose: Remove duplicate records based on the combination of Country and Year
DELETE FROM world_life_expectancy
WHERE
	Row_ID IN (
    SELECT Row_ID
    FROM (
        SELECT Row_ID, 
        CONCAT(Country, Year),
        ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
        FROM world_life_expectancy
        ) AS Row_Table
    WHERE Row_Num >1
    )
;

-- Retrieve empty status records
-- Purpose: Find records where the Status field is empty
SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

-- Get unique status values
-- Purpose: Get all non-empty Status values
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

-- Get unique countries with 'Developing' status
-- Purpose: Find all countries where the Status is 'Developing'
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

-- Update empty status to 'Developing'
-- Purpose: Set empty Status fields to 'Developing' based on other records from the same country
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
SET T1.Status = 'Developing'
WHERE T1.Status = ''
AND T2.Status <> ''
AND T2.Status = 'Developing'
; 

-- Get records for the USA
-- Purpose: Find records for the United States of America
SELECT * 
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

-- Update empty status to 'Developed'
-- Purpose: Change empty Status fields to 'Developed' using other records from the same country
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
SET T1.Status = 'Developed'
WHERE T1.Status = ''
AND T2.Status <> ''
AND T2.Status = 'Developed'
; 

-- Get records with NULL status
-- Purpose: Find records where the Status field is NULL
SELECT * 
FROM world_life_expectancy
WHERE Status IS NULL
;

-- Get all data again
-- Purpose: Retrieve all records from the world_life_expectancy table for a new look
SELECT * 
FROM world_life_expectancy
;

-- Get all data (with commented filter)
-- Purpose: Retrieve all records from the world_life_expectancy table, with a commented filter for empty 'Life expectancy'
SELECT * 
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;

-- Get specific fields (with commented filter)
-- Purpose: Retrieve Country, Year, and 'Life expectancy' from the world_life_expectancy table, with a commented filter for empty 'Life expectancy'
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;

-- Join table with itself
-- Purpose: Get life expectancy values for consecutive years for the same country
SELECT 
    t1.Country, t1.Year, t1.`Life expectancy`, 
    t2.Country, t2.Year, t2.`Life expectancy`
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
ON 
    t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
;

-- Calculate average life expectancy
-- Purpose: Compute the average life expectancy for a year using the previous and next years' values for records with missing life expectancy
SELECT 
    t1.Country, t1.Year, t1.`life expectancy`, 
    t2.Country, t2.Year, t2.`life expectancy`, 
    t3.Country, t3.Year, t3.`life expectancy`,
	ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON 
    t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON 
    t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`life expectancy` = ''
;

-- Update missing life expectancy values
-- Purpose: Fill in missing values using the average of the previous and next years
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`life expectancy` = ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
WHERE t1.`life expectancy` = ''
;

-- Verify missing life expectancy values
-- Purpose: Get Country, Year, and 'Life expectancy' where 'Life expectancy' is still missing
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;