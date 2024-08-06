/*
1. Drop columns not relevant to our analysis
2. Data cleaning and manipulations
3. Removing duplicates.
*/

SELECT TOP (1000) *
FROM mental_health_japan;

-- Drop columns not relevant to the analysis
/*
We are going to utilise "inter_dom", "Region", "Gender", "Academic", "Age", 
"Stay", "Japanese_cate", "English_cate", "ToDep", "ToSC", "ToAS", "Religion", "Suicide".
*/

-- Create a duplicate copy of the table to ensure we have the raw data
SELECT *
INTO mental_health_japan_copy
FROM mental_health_japan;

SELECT TOP (1000) *
FROM mental_health_japan_copy;

-- To drop the columns that are not relevant to the analysis, create a new table with the variables of interest.
SELECT 
	inter_dom,
	Region,
	Gender,
	Academic,
	Age,
	Stay,
	Japanese_cate,
	English_cate,
	Religion,
	Suicide,
	ToDep,
	ToSC,
	ToAS
INTO mental_health_JPN
FROM mental_health_japan_copy;

SELECT TOP (1000) *
FROM mental_health_JPN;

SELECT Religion, COUNT(Religion) as Count
FROM mental_health_JPN
GROUP BY Religion;

-- We want to replace the 0 and 1 in the Religion and Suicide columns with Yes and No.

ALTER TABLE mental_health_JPN
ALTER COLUMN Religion VARCHAR(10);

UPDATE mental_health_JPN
SET Religion = CASE 
					WHEN Religion = '0' THEN 'NO'
					WHEN Religion = '1' THEN 'YES'
				END
WHERE Religion IN ('0', '1');

-- Carry out same operation on Suicide column

ALTER TABLE mental_health_JPN
ALTER COLUMN Suicide VARCHAR(10);

UPDATE mental_health_JPN
SET Suicide = CASE 
					WHEN Suicide = '0' THEN 'NO'
					WHEN Suicide = '1' THEN 'YES'
				END
WHERE Suicide IN ('0', '1');
-- To verify the alteration and update
SELECT	TOP (10) *
FROM 
mental_health_JPN;

/*
Given the max and min age, we create a column of AgeGroup.
Find the maximum and minimum age
*/
SELECT MAX(Age) as Max, MIN(Age) as Min
FROM mental_health_JPN;

ALTER TABLE mental_health_JPN
ADD AgeGroup VARCHAR(30);

UPDATE mental_health_JPN
SET AgeGroup = CASE
					WHEN Age BETWEEN 17 AND 24 THEN 'Young Adult'
					WHEN Age BETWEEN 25 AND 32 THEN 'Adult'
				END;

-- VERIFY THE CHANGES
SELECT TOP (10) *
FROM mental_health_JPN;

SELECT COUNT(*), Academic
FROM mental_health_JPN
GROUP BY ACADEMIC;

--- DELETE THE NULL FIELDS IN THE DATASET
DELETE 
FROM 
	mental_health_JPN
WHERE 
	inter_dom IS NULL
		OR Region IS NULL
		OR Gender IS NULL
		OR Academic IS NULL
		OR AGE IS NULL
		OR STAY IS NULL
		OR Japanese_cate IS NULL
		OR English_cate IS NULL
		OR Religion IS NULL
		OR Suicide IS NULL
		OR ToDep IS NULL
		OR ToSC IS NULL
		OR ToAS IS NULL;
-- VERIFY THE NULL VALUES ARE DROPPED
SELECT TOP (100) *
	FROM mental_health_JPN;

-- Add a descriptor column for the PHQ9 Scores
ALTER TABLE mental_health_JPN
ADD PHQ9_DESCRIPTOR VARCHAR(50);

-- POPULATE THE PHQ9_DESCRIPTOR COLUMN
UPDATE mental_health_JPN
SET PHQ9_DESCRIPTOR = CASE
						WHEN ToDep BETWEEN 0 AND 4 THEN 'None Minimal'
						WHEN ToDep BETWEEN 5 AND 9 THEN 'Mild'
						WHEN ToDep BETWEEN 10 AND 14 THEN 'Moderate'
						WHEN ToDep BETWEEN 15 AND 19 THEN 'Moderately Severe'
						WHEN ToDep BETWEEN 20 AND 27 THEN 'Severe'
					END;
-- VERIFY THE CHANGES 
SELECT TOP(100) *
FROM mental_health_JPN;