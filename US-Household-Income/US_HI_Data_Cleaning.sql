-- US Household Income Data Cleaning
-- Queries are used to clean and check the household income data
-- First, I get and review the full datasets to set a baseline
-- Then, I fix issues like mismatched column names, duplicate records, and inconsistencies
-- Updates and checks ensure the data is accurate and consistent across the dataset

-- Select All Data from Household Income Table
-- Purpose: Get all rows and columns from the household income table for initial review
SELECT * 
FROM us_project.us_household_income
;

-- Select All Data from Household Income Statistics Table
-- Purpose: Get all the data from the table to review it initially
SELECT *
FROM us_project.us_household_income_statistics
;

-- Rename Column to Fix Display Problems
-- Purpose: Change the column name to correct issues with how text is shown in the table
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

-- Verify Column Rename
-- Purpose: Check the updated column names in the household income statistics table
SELECT *
FROM us_project.us_household_income_statistics
;

-- Count Records in Household Income Table
-- Purpose: Count the total number of records in the household income table
SELECT COUNT(id)
FROM us_project.us_household_income
;

-- Count Records in Household Income Statistics Table
-- Purpose: Count the total number of records in the household income statistics table
SELECT COUNT(id)
FROM us_project.us_household_income_statistics
;

-- Identify Duplicates in Household Income Table
-- Purpose: Find duplicate records in the household income table based on the ID column
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

-- Display Duplicate Records
-- Purpose: Display records with duplicate IDs in the household income table
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
-- Purpose: Remove duplicate records from the household income table based on the ID column
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
-- Purpose: Verify that there are no remaining duplicate records in the household income statistics table
SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

-- Display All Records from Household Income Table
-- Purpose: Show all rows and columns from the table after cleaning
SELECT *
FROM us_project.us_household_income
;

-- Check State Names for Case Sensitivity Issues
-- Purpose: Find any duplicates or errors in state names from different letter cases
SELECT State_Name, COUNT(State_Name)
FROM us_project.us_household_income
GROUP BY State_Name
;

-- Display Distinct State Names
-- Purpose: List unique state names to identify any inconsistencies
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

-- Correct Misspelled State Names
-- Purpose: Update incorrect state names to their correct values
UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- Display Unique State Names After Corrections
-- Purpose: Verify the state names after fixing any misspellings
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

-- Display Unique State Abbreviations
-- Purpose: List all different state abbreviations to check for inconsistencies
SELECT DISTINCT State_ab
FROM us_project.us_household_income
ORDER BY 1
;

-- Display All Records Ordered by ID
-- Purpose: Show all rows and columns from the table, sorted by ID
SELECT *
FROM us_project.us_household_income
ORDER BY 1
;

-- Check Records with Empty Places
-- Purpose: Find records with an empty Place field
SELECT *
FROM us_project.us_household_income
WHERE Place = ''
ORDER BY 1
;

-- Check Records with Specific County
-- Purpose: Get records for a specific county to check the data
SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

-- Update Place Name for Specific County and City
-- Purpose: Fix the Place field for records that match specific criteria
UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

-- Count Records by Type
-- Purpose: Count the number of records for each Type value
SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
-- ORDER BY 1
;

-- Correct Type Name
-- Purpose: Update incorrect type names to their correct values
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

-- Display All Records After Type Correction
-- Purpose: Show all rows and columns from the table after fixing type names
SELECT *
FROM us_household_income
;

-- Check for Missing or Zero Values in Land and Water Areas
-- Purpose: Identify records with missing or zero values for water areas
SELECT ALAND, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

-- Identify Records with Zero Values for Both Land and Water Areas
-- Purpose: Find records where both land and water areas are zero or missing
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
;

-- Identify Records with Zero or Missing Water Areas
-- Purpose: Find distinct records where water area values are zero or missing
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

-- Identify Records with Zero or Missing Land Areas
-- Purpose: Find distinct records where land area values are zero or missing
SELECT DISTINCT ALand, AWater
FROM us_project.us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL