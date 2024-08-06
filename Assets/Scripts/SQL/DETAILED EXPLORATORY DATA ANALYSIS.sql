/*
A detailed analysis into the database to determine the factors that cause depression and may be lead suicide.
*/

-- Total Student record
SELECT COUNT(*) AS TOTAL_PARTCIPANTS
FROM mental_health_JPN;


--- What percentage of the entry are from international and domestic student
SELECT inter_dom, COUNT(*) AS Total_Count,
		CAST(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM mental_health_JPN)), 0) AS INT) AS Proportion_Percent									
FROM 
	mental_health_JPN
GROUP BY inter_dom;


-- What proportion of Internationational students are prone to suicidal thoughts
SELECT Suicide, COUNT (*) AS Total_Count, 
				CAST(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM mental_health_JPN)),0) AS INT) AS Percentage_Population
FROM 
	mental_health_JPN
WHERE 
	inter_dom = 'inter'
GROUP BY
	Suicide;
/*
What are the possible causes of suicide/Depression in the international students community. 
Could it be due to age, length of stay, Gender, Academic
*/
-- Relationship between Age and International student and Depression
SELECT Age,
		AVG(ToDep) AS AVG_PHQ9_Score
FROM 
	mental_health_JPN
WHERE
	inter_dom = 'inter'
	AND
	Suicide = 'Yes'
GROUP BY 
	Age
ORDER BY
	AVG_PHQ9_Score DESC;

-- Relationship between length of stay and depression
SELECT Stay,
		AVG(ToDep) AS AVG_PHQ9_Score
FROM 
	mental_health_JPN
WHERE 
	inter_dom = 'inter'
	AND
	Suicide = 'Yes'
GROUP BY 
	Stay
ORDER BY 
	AVG_PHQ9_Score DESC;

-- which region are more susceptible to suicide
SELECT Region,
		AVG(ToDep) AS AVG_PHQ9_Score
FROM 
	mental_health_JPN
WHERE 
	inter_dom = 'inter'
	AND
	Suicide = 'Yes'
GROUP BY 
	Region;

-- Relationship between Gender and Depression
SELECT Gender,
		AVG(ToDep) AS AVG_PHQ9_Score
FROM 
	mental_health_JPN
WHERE 
	inter_dom = 'inter'
	AND
	Suicide = 'Yes'
GROUP BY
	Gender;

-- Relationship between Academic level and PHQ9 scores
SELECT Academic,
	AVG(ToDep) AS AVG_PHQ9_SCORE
FROM 
	mental_health_JPN
GROUP BY
	Academic;

/*
Comparison betweeen the Key indices (PHQ9, ToAS, ToSC)
*/
-- Relationship between PHQ9 SCORE, CULTURATIVE STRESS, AND SOCIAL CONNECTEDNESS
SELECT Stay, 
		AVG(ToDep) AS AVG_PHQ9_Score,
		AVG(ToAS) AS AVG_Culturative_stress,
		AVG(ToSC) AS AVG_Social_connectedness
FROM 
	mental_health_JPN
WHERE 
	inter_dom = 'inter'
	AND 
	Suicide = 'Yes'
GROUP BY
	   Stay;

-- Relationship between GENDER, PHQ9 SCORE, CULTURATIVE STRESS, AND SOCIAL CONNECTEDNESS
SELECT Gender, 
		AVG(ToDep) AS AVG_PHQ9_Score,
		AVG(ToAS) AS AVG_Culturative_stress,
		AVG(ToSC) AS AVG_Social_connectedness
FROM 
	mental_health_JPN
WHERE 
	inter_dom = 'inter'
	AND 
	Suicide = 'YES'
GROUP BY
	   Gender;

--- Relationship between Age and Key Metrics
SELECT Age, 
		AVG(ToDep) AS AVG_PHQ9_Score,
		AVG(ToAS) AS AVG_Culturative_stress,
		AVG(ToSC) AS AVG_Social_connectedness
FROM 
	mental_health_JPN
WHERE 
	inter_dom = 'inter'
	AND 
	Suicide = 'YES'
GROUP BY
	   Age
ORDER BY AVG_PHQ9_Score DESC;

-- Relationship betweeen KEY METRICS AND DEPRESSION 
SELECT PHQ9_DESCRIPTOR,
	AVG(ToDep) AS AVG_PHQ9_Score,
	AVG(ToAS) AS AVG_Culturative_stress,
	AVG(ToSC) AS AVG_Social_connectedness
FROM 
	mental_health_JPN
WHERE 
	inter_dom = 'inter'
AND
	Suicide = 'Yes'
GROUP BY 
	PHQ9_DESCRIPTOR;


SELECT * 
FROM mental_health_JPN;

-- CREATE VIEW FOR POWERBI
CREATE VIEW view_mental_health_japan AS
SELECT
	inter_dom, 
	Region, 
	Gender, 
	Age,
	Stay,
	Suicide,
	ToDep,
	ToSC,
	ToAS,
	AgeGroup, 
	PHQ9_DESCRIPTOR
FROM mental_health_JPN;

Select *
from view_mental_health_japan;