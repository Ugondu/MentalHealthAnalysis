# Analysing Factors that Cause Mental Health Breakdown in an International Student Population.

![image](https://github.com/user-attachments/assets/9c3a77bc-5871-4d29-b5fe-c75ee81d0cda)


# Table of contents

- [Objective](#objective)
- [Data Source](#data-source)
- [Stages](#stages)
- [Design](#design)
  - [Dashbord Mockup Template](#dashboard-mockup-template)
  - [Tools](#tools)
- [Development](#development)
  - [Pseudocode](#pseudocode)
  - [Data Exploration](#data-exploration)
  - [Data Cleaning](#data-cleaning)
  - [Data Transformation](#data-transformation)
  - [Create SQL View](#create-sql-view)
- [ Visualization](#visualization)
  - [Results](#results)
  - [DAX Measures](#dax-measures)
- [Analysis](#analysis)
  - [Findings](#findings)
  - [Insights](#insights)
- [Recommendations](#recommendations)
- [Conclusion](#conclusion)




# Objective 

- What is the key pain point?

The Head of Data Analytics team wants a detailed report on the determinants of depression and the correlation with Acculturative Stress and Social Connectedness in a population of international students in a higher institution. 



- What is the ideal solution?

This would entail creating a detailed dashboard that provides insights into the possible causes of depression that includes
- Total Students
- Total number of international students
- Students open to suicidal thoughts
- Average Score of PHQ-9 questionnaire
- Regional distribution
- Length of stay
- Distribution by Age group
- Correlation charts



# Data Source

To achieve our aim of providing a detailed analysis, we need dataset that includes
- Student Status ( internation or domestic)
- Stay
- Age
- Suicide ( Yes or No)
- Gender
- Region
- ToDep ( PHQ9 Score)
- ToAS ( Acculturative score)
- ToSC ( Social Connectedness score)


The dataset is sourced from Kaggle in Excel format, [see here to find it.](https://www.kaggle.com/datasets/abdallahprogrammer/students-mental-health)


# Stages


- Design
- Development
- Visualization
- Analysis


# Design

## Dashboard components required
- What should our dashboard caontain based on the requirements provided?

The contents will be dependent on the questions we need the dashboard to answer:

1. What is the total number of students that participated in the survey?
2. What is the total number of international students?
3. What is the total number of domestoc students?
4. What is the average PHQ-9 score of international students with suicidal thoughts?
5. What is average PHQ-9 score of age group of international students with suicidal thoughts?
6. What is the average PHQ-9 score of students by the length of stay in the university?
7. What is the average PHQ-9 score of student by region?
8. Is there a correlation between PHQ9-score and acculturative score?
9. Is there a correlation between PHQ9_score and social connectedness score?
10. What is the relationship between social connectedness and acculturative score?

This will form the basis of our dashboard and may change as the analysis progresses.


## Dashboard mockup template

- What will our final dashboard look like?

Some of the visuals that may be appropiate in answering our questions include:

1. Treemap
2. Scorecards
3. Column chart
4. Bar Chart
5. Scatter plot



![image](https://github.com/user-attachments/assets/2f523571-6cdf-4cef-a81b-281c08cdcb7a)


## Tools

| Tool | Purpose |
| --- | --- |
| Excel | Exploring the data |
| SQL Server | Cleaning, testing, and analyzing the data |
| Power BI | Visualizing the data via interactive dashboards |
| GitHub | Hosting the project documentation and version control |
| Mokkup AI | Designing the wireframe/mockup of the dashboard | 


# Development

## Pseudocode

- To create and end to end solution for our analysis, the steps will entail:

1. Get the dataset
2. Explore the dataset using Excel
3. Load the dataset into SQL server
4. Clean and normalize the data with SQL
5. Visualize the cleaned data using Power BI
6. Generate findings based on the insights
7. Write documentation on GitHub
8. Publish and host findings on GitHub
 

## Data Exploration

The dataset is analysed at this stage to check for errors, inconsistencies, data type error, bugs, corrupted characters, whitespaces, blanks, and null fields.

- Initial observations
1. Presence of null cells
2. Contains columns not relevant to our analysis
3. Some headers were not descriptive for easy understanding


## Data Cleaning
We aim to refine and normalise the dataset using SQL to ensure it is structured and ready for analysis.

- The steps required to clean our dataset include:

1. Remove irrelevant columns from the dataset
2. Create 'AgeGroup' and 'PHQ9 DESCRIPTOR' columns for better analysis
3. Remove null and blank fields.


## Data Transformation


```sql
/*
# 1. Create new columns 'AgeGroup' and 'PHQ9_DESCRIPTOR'
# 2. Update created columns from exisiting columns
*/

-- 1a.
ALTER TABLE mental_health_JPN
ADD AgeGroup VARCHAR(30);

UPDATE mental_health_JPN            
SET AgeGroup = CASE
		WHEN Age BETWEEN 17 AND 24 THEN 'Young Adult'
		WHEN Age BETWEEN 25 AND 32 THEN 'Adult'
	      END;

-- 1b
ALTER TABLE mental_health_JPN
ADD PHQ9_DESCRIPTOR VARCHAR(50);

UPDATE mental_health_JPN            
SET PHQ9_DESCRIPTOR = CASE
			WHEN ToDep BETWEEN 0 AND 4 THEN 'None Minimal'
			WHEN ToDep BETWEEN 5 AND 9 THEN 'Mild'
			WHEN ToDep BETWEEN 10 AND 14 THEN 'Moderate'
			WHEN ToDep BETWEEN 15 AND 19 THEN 'Moderately Severe'
			WHEN ToDep BETWEEN 20 AND 27 THEN 'Severe'
		     END;

```


## Create SQL view

```sql
/*
# 1. create a view to store the transformed dataset
# 2. select the required columns from mental_health_JPN SQL table
*/


-- 1.
CREATE VIEW view_mental_health_japan AS

-- 2.
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

-- 3.
FROM
    mental_health_JPN

```

# Visualization

## Results

- Our final dashboard shows detailed analysis of factors contributing to depression in the population

![image](https://github.com/user-attachments/assets/7c2085ed-13f8-43eb-b49e-13989d3dee05)

## DAX Measures

### 1. Total Students
```sql
Total Students = 
VAR countofStudents = COUNT(view_mental_health_japan[inter_dom])

Return countofStudents

```

### 2. Total International Students
```sql
Total international students = 
Var countOfInternationalStudents = COUNTROWS(FILTER(view_mental_health_japan, view_mental_health_japan[inter_dom] = "Inter"))

Return countOfInternationalStudents

```

### 3. Total Domestic Students
```sql
Domestic Students = 
VAR countOfDomesticStudents = COUNTROWS(FILTER(view_mental_health_japan, view_mental_health_japan[inter_dom] = "Dom"))

Return countOfDomesticStudents

```

### 4. Count of suicidal international students
```sql
IntStudentsandSuicidal = 
VAR countofIntSuicidal = CALCULATE(COUNTROWS(view_mental_health_japan),view_mental_health_japan[inter_dom] = "Inter", view_mental_health_japan[Suicide]="YES")

Return countofIntSuicidal

```

### 5. Average PHQ9 Score
```sql
Average PHQ9 Score = 
VAR AverageofPHQ9 = AVERAGE(view_mental_health_japan[ToDep])

Return AverageofPHQ9

```

### 6. Average PHQ9 Score who are suicidal
```sql
Avg.PHQ9_Suicidal_Int = 
var AvgScore = CALCULATE(AVERAGE(view_mental_health_japan[ToDep]), FILTER(view_mental_health_japan, view_mental_health_japan[inter_dom] = "Inter" && view_mental_health_japan[Suicide] = "YES"))

Return AvgScore

```

# Analysis

## Findings

For this analysis, we are focused on the following questions to generate the insights needed -

These key questions are as follows:
1. What age group of international students is most likely to fall into depression?
2. What duration of stay in the university has the highest average PHQ9 Score?
3. What region has the hoghest average PHQ9 score?
4. Is there a correlation between PHQ9 score and Acculturative stress scores?
5. Is there a correlation between PHQ9 score and social connectedness scores?
6. Is there a correlation between Acculturative stress scores and Social Connectedness?

#### 1. What age group of international students is most likely to fall into depression?

| Rank | Age Group                  | Avg. PHQ9 Score |
|------|----------------------------|-----------------|
| 1    | Young Adults (17-24 years) | 13.6            |
| 2    | Adults (25-32 years)       | 10.0            |


#### 2. What duration of stay in the university has the highest average PHQ9 Score?

| Rank | Length of stay (years) | Avg. PHQ9 Score |
|------|------------------------|-----------------|
| 1    |    3                   | 16.5            | 
| 2    |    1                   | 13.0            |
| 3    |    10                  | 13.0            |
| 4    |    2                   | 12.3            |
| 5    |    4                   | 11.8            |
| 6    |    6                   | 10.0            |

#### 3. What region has the highest average PHQ9 Score?

| Rank |Region                  | Avg. PHQ9 Score |
|------|------------------------|-----------------|
| 1    | East Asia              | 14.30           | 
| 2    | South East Asia        | 13.22           |
| 3    | Japan                  | 13.00           |
| 4    | Others                 | 12.67           |
| 5    | South Asia             | 11.83           |


#### 4. Is there a correlation between PHQ9 score and Acculturative stress scores?

From the insights generated, acculturative stress shows a significant positive relationship with PHQ9 score which is a marker for depression amongst international students.

#### 5. Is there a correlation between PHQ9 score and social connectedness scores?

Our analysis shows that there is a negative association between social connectedness and depression in the population of the international students. 

#### 6. Is there a correlation between Acculturative stress scores and social connectedness?

There is a strong negative relationship between acculturative stress and social connectedness in the population of international students.


# Insights

From our findings, the high prevalence of depression amongst international students when compared to their domeestic counterpart could be due to many factors. This could be due to high levels of acculturative stress that comes with getting used to a new environment, feeling of being alone due to the geographical distance between the students and their relatives, and low access to mental health support system.

The fear of adult responsibilites and duties by individuals who are in the late teens and mid 20s could be a contributing factor to depression as seen in the analysis that higher PHQ9 scores are prevalent in this population. 

Given that most courses offered in the university is between 3 and 4 years, the high PHQ9 socre seen in students with 3 year stay could be associated with the fear of the unknown, difficulties they may face in the labor market which is mentally stressing for most students.

Acculturative stress is the psychological, physical, and social difficulties that individuals may experience when familiarising with a new environment and culture. In relation to PHQ 9 score, our analysis shows a positive correlation between acculturative stress and depression in international students. 

Secondly, there is a negative relationship between social connectedness (Ones opinion of self in relation to other people) and depression in our analysis. This is expected because as the student relate and make friends with more people, the tend to feel less alone reducing the tendency to be depressed. 

Lastly, we observed that as social connectedness increased, the score of acculturative stress decreased, leading to a smoother acculturation process and subsequently reducing the likelihood of depression.


# Recommendations

- To improve the mental health of international students in the university population;

1. Providing appropriate mental and physical support as this is neccessary in students who are not sure of the path to take in their adulthood.
2. Creating a friendly atmosphere to enhance trust among the international students to feel more connected and welcomed.
3. Initiating community based activities for students to increase social connectedness as we have seen that it could be crucial in reducing the likelihood of depression.

# Conclusion

The relationship between acculturative stress, social connectedness, and high PHQ9 score a marker for depression amongst interrnational students shows the importance to implement support programs such as welcome orientation, job interview sessions, and social gatherings and activities to improve the familiarisation of these international students in a new environment and culture.
   






