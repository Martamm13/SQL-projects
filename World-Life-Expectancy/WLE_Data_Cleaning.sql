-- View all data
SELECT * 
FROM world_life_expectancy;

-- Find duplicate entries
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

-- Show duplicate rows
SELECT * 
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
) AS Row_Table
WHERE Row_Num > 1;

-- Delete duplicate rows
DELETE FROM world_life_expectancy
WHERE Row_ID IN (
    SELECT Row_ID
    FROM (
        SELECT Row_ID, 
        CONCAT(Country, Year),
        ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
        FROM world_life_expectancy
    ) AS Row_Table
    WHERE Row_Num > 1
);

-- Find empty status
SELECT * 
FROM world_life_expectancy
WHERE Status = '';

-- Show unique status values
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> '';

-- Countries marked as 'Developing'
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

-- Update empty status to 'Developing'
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status = 'Developing';

-- Show USA records
SELECT * 
FROM world_life_expectancy
WHERE Country = 'United States of America';

-- Update empty status to 'Developed'
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status = 'Developed';

-- Find NULL statuses
SELECT * 
FROM world_life_expectancy
WHERE Status IS NULL;

-- View updated data
SELECT * 
FROM world_life_expectancy;

-- View all data (with optional filter)
SELECT * 
FROM world_life_expectancy;
#WHERE `Life expectancy` = '';

-- Show country, year, and life expectancy
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy;
#WHERE `Life expectancy` = '';

-- Join table by consecutive years
SELECT 
    t1.Country, t1.Year, t1.`Life expectancy`, 
    t2.Country, t2.Year, t2.`Life expectancy`
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
	AND t1.Year = t2.Year - 1;

-- Estimate missing life expectancy
SELECT 
    t1.Country, t1.Year, t1.`life expectancy`, 
    t2.Country, t2.Year, t2.`life expectancy`, 
    t3.Country, t3.Year, t3.`life expectancy`,
	ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
	AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
	AND t1.Year = t3.Year + 1
WHERE t1.`life expectancy` = '';

-- Fill missing life expectancy
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
	AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
	AND t1.Year = t3.Year + 1
SET t1.`life expectancy` = ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
WHERE t1.`life expectancy` = '';

-- Verify missing life expectancy
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = '';