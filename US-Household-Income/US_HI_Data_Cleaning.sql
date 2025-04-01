-- View all household income data
SELECT * 
FROM us_project.us_household_income;

-- View all income statistics data
SELECT *
FROM us_project.us_household_income_statistics;

-- Fix column name display issue
ALTER TABLE us_project.us_household_income_statistics 
RENAME COLUMN `ï»¿id` TO `id`;

-- Check column names
SELECT *
FROM us_project.us_household_income_statistics;

-- Count records in household income table
SELECT COUNT(id)
FROM us_project.us_household_income;

-- Count records in statistics table
SELECT COUNT(id)
FROM us_project.us_household_income_statistics;

-- Find duplicate IDs
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

-- Show duplicate records
SELECT *
FROM (
    SELECT row_id, id,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
    FROM us_project.us_household_income
) subquery_duplicates
WHERE row_num > 1;

-- Delete duplicate records
DELETE FROM us_project.us_household_income
WHERE row_id IN (
    SELECT row_id
    FROM (
        SELECT row_id, id,
               ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
        FROM us_project.us_household_income
    ) subquery_duplicates
    WHERE row_num > 1
);

-- Check for remaining duplicates
SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;

-- View cleaned income data
SELECT *
FROM us_project.us_household_income;

-- Check for case issues in state names
SELECT State_Name, COUNT(State_Name)
FROM us_project.us_household_income
GROUP BY State_Name;

-- List distinct state names
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1;

-- Fix state name typos
UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- Verify state names after update
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1;

-- Check state abbreviations
SELECT DISTINCT State_ab
FROM us_project.us_household_income
ORDER BY 1;

-- View all records sorted by ID
SELECT *
FROM us_project.us_household_income
ORDER BY 1;

-- Find records with empty Place field
SELECT *
FROM us_project.us_household_income
WHERE Place = ''
ORDER BY 1;

-- Check data for a specific county
SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1;

-- Update Place for matching county and city
UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

-- Count records by Type
SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type;

-- Fix Type value
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- View all records after type fix
SELECT *
FROM us_household_income;

-- Find missing or zero water areas
SELECT ALAND, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL;

-- Find records with zero land and water
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
  AND (ALand = 0 OR ALand = '' OR ALand IS NULL);

-- Find missing or zero water areas
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL;

-- Find missing or zero land areas
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL;