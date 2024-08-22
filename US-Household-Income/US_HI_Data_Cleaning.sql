-- US Household Income Data Cleaning
-- The queries are designed to clean and validate the household income data.
-- The initial queries retrieve and examine the full datasets to establish a baseline.
-- I then address issues such as column name mismatches, duplicate records, and data inconsistencies.
-- Specific updates and checks are performed to ensure data accuracy and consistency across the dataset.

-- Select All Data from Household Income Table
-- Purpose: Retrieve all rows and columns from the household income table for initial examination.
SELECT * 
FROM us_project.us_household_income
;

-- Select All Data from Household Income Statistics Table
-- Purpose: Retrieve all rows and columns from the household income statistics table for initial examination.
SELECT *
FROM us_project.us_household_income_statistics
;

-- Rename Column to Fix Encoding Issue
-- Purpose: Rename the column to correct encoding issues in the household income statistics table.
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

-- Verify Column Rename
-- Purpose: Check the updated column names in the household income statistics table.
SELECT *
FROM us_project.us_household_income_statistics
;

-- Count Records in Household Income Table
-- Purpose: Count the total number of records in the household income table.
SELECT COUNT(id)
FROM us_project.us_household_income
;

-- Count Records in Household Income Statistics Table
-- Purpose: Count the total number of records in the household income statistics table.
SELECT COUNT(id)
FROM us_project.us_household_income_statistics
;

-- Identify Duplicates in Household Income Table
-- Purpose: Find duplicate records in the household income table based on the ID column.
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

-- Display Duplicate Records
-- Purpose: Display records with duplicate IDs in the household income table.
SELECT *
FROM (
    SELECT row_id,
           id,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
    FROM us_project.us_household_income
) subquery_duplicates
WHERE row_num > 1
;

-- Delete Duplicate Records
-- Purpose: Remove duplicate records from the household income table based on the ID column.
DELETE FROM us_project.us_household_income
WHERE row_id IN (
    SELECT row_id
    FROM (
        SELECT row_id,
               id,
               ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
        FROM us_project.us_household_income
    ) subquery_duplicates
    WHERE row_num > 1
);

-- Check for Duplicates After Deletion
-- Purpose: Verify that there are no remaining duplicate records in the household income statistics table.
SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

-- Display All Records from Household Income Table
-- Purpose: Retrieve all rows and columns from the household income table after cleaning.
SELECT *
FROM us_project.us_household_income
;

-- Check State Names for Case Sensitivity Issues
-- Purpose: Identify potential duplicates or inconsistencies in state names due to case sensitivity.
SELECT State_Name, COUNT(State_Name)
FROM us_project.us_household_income
GROUP BY State_Name
;

-- Display Distinct State Names
-- Purpose: List unique state names to identify any inconsistencies.
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

-- Correct Misspelled State Names
-- Purpose: Update incorrect state names to their correct values.
UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- Display Distinct State Names After Corrections
-- Purpose: Verify the state names after correcting misspellings.
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

-- Display Distinct State Abbreviations
-- Purpose: List unique state abbreviations to check for any inconsistencies.
SELECT DISTINCT State_ab
FROM us_project.us_household_income
ORDER BY 1
;

-- Display All Records Ordered by ID
-- Purpose: Retrieve all rows and columns from the household income table, ordered by ID.
SELECT *
FROM us_project.us_household_income
ORDER BY 1
;

-- Check Records with Empty Places
-- Purpose: Find records with an empty Place field.
SELECT *
FROM us_project.us_household_income
WHERE Place = ''
ORDER BY 1
;

-- Check Records with Specific County
-- Purpose: Retrieve records for a specific county to verify data.
SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

-- Update Place Name for Specific County and City
-- Purpose: Correct the Place field for records matching specific criteria.
UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

-- Count Records by Type
-- Purpose: Count the number of records for each Type value.
SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
-- ORDER BY 1
;

-- Correct Type Name
-- Purpose: Update incorrect type names to their correct values.
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

-- Display All Records After Type Correction
-- Purpose: Retrieve all rows and columns from the household income table after updating type names.
SELECT *
FROM us_household_income
;

-- Check for Missing or Zero Values in Land and Water Areas
-- Purpose: Identify records with missing or zero values for water areas.
SELECT ALAND, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

-- Identify Records with Zero Values for Both Land and Water Areas
-- Purpose: Find records where both land and water areas are zero or missing.
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
;

-- Identify Records with Zero or Missing Water Areas
-- Purpose: Find distinct records where water area values are zero or missing.
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

-- Identify Records with Zero or Missing Land Areas
-- Purpose: Find distinct records where land area values are zero or missing.
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL