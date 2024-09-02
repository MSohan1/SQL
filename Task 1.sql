SELECT * FROM studentscores.`studentscores`;

-- id, first_name, last_name, email, gender, part_time_job, absence_days, extracurricular_activities, 
-- weekly_self_study_hours, career_aspiration, math_score, history_score, physics_score, chemistry_score,
-- biology_score, english_score, geography_score

-- 1)Calculate the average math_score for each career_aspiration. Order the results by the average score in descending order.

SELECT career_aspiration, AVG(math_score) AS average_math_score
FROM studentscores
GROUP BY career_aspiration
ORDER BY average_math_score DESC;

-- 2)Find the career_aspirations that have an average english_score greater than 75. Display the career aspiration and the average score.

SELECT career_aspiration, AVG(english_score) AS average_english_score
FROM studentscores
GROUP BY career_aspiration
HAVING AVG(english_score) > 75;

-- 3)Identify students who have a math_score higher than the school's average math score. List their first_name, last_name, and math_score.

-- First, calculate the school's average math score
WITH school_avg AS (
    SELECT AVG(math_score) AS avg_math_score
    FROM studentscores
)

-- Then, find students with a math_score higher than the average
SELECT first_name, last_name, math_score
FROM studentscores, school_avg
WHERE math_score > school_avg.avg_math_score;

SELECT first_name, last_name, career_aspiration, physics_score,
       RANK() OVER (PARTITION BY career_aspiration ORDER BY physics_score DESC) AS rank FROM studentscores;



-- 5) For each student, create a new column full_name by concatenating first_name and last_name with a space in between. Show the full_name and email columns where the email contains the string "academy".
SELECT CONCAT(first_name, ' ', last_name) AS full_name, email
FROM studentscores
WHERE email LIKE '%academy%';

-- 6)Calculate the lowest (FLOOR), highest (CEIL), and average (ROUND to two decimal places) chemistry_score for each career aspirant. Display the career aspirants , lowest score, highest score, and average score.

SELECT career_aspiration,
       FLOOR(MIN(chemistry_score)) AS lowest_score,
       CEIL(MAX(chemistry_score)) AS highest_score,
       ROUND(AVG(chemistry_score), 2) AS average_score
FROM studentscores
GROUP BY career_aspiration;

-- 7)Find career aspirations where the average history_score is above 85 and at least 5 students aspire to that career. List the career_aspiration and the average score.
SELECT career_aspiration, AVG(history_score) AS average_history_score
FROM studentscores
GROUP BY career_aspiration
HAVING AVG(history_score) > 85
   AND COUNT(*) >= 5;

-- 8)Identify students who score above average in both biology and chemistry, compared to the school's average for those subjects. Display their id, first_name, last_name, biology_score, and chemistry_score.

WITH avg_scores AS (
    SELECT 
        AVG(biology_score) AS avg_biology_score,
        AVG(chemistry_score) AS avg_chemistry_score
    FROM studentscores
)

SELECT id, first_name, last_name, biology_score, chemistry_score
FROM studentscores, avg_scores
WHERE biology_score > avg_scores.avg_biology_score
  AND chemistry_score > avg_scores.avg_chemistry_score;

-- 9)Calculate the percentage of absence days for each student relative to the total absence days recorded for all students. Display the id, first_name, last_name, and the calculated percentage, rounded to two decimal places. Order the results by the percentage in descending ord

WITH total_absence AS (
    SELECT SUM(absence_days) AS total_days
    FROM studentscores
)

SELECT id, first_name, last_name,
       ROUND((absence_days / total_days) * 100, 2) AS percentage_absence
FROM studentscores, total_absence
ORDER BY percentage_absence DESC;

-- 10)Identify students who have scores above 80 in at least three out of the six subjects: math, history, physics, chemistry, biology, and English. Display their id, first_name, last_name, and the count of subjects where they scored above 80.
SELECT id, first_name, last_name,
       (CASE WHEN math_score > 80 THEN 1 ELSE 0 END +
        CASE WHEN history_score > 80 THEN 1 ELSE 0 END +
        CASE WHEN physics_score > 80 THEN 1 ELSE 0 END +
        CASE WHEN chemistry_score > 80 THEN 1 ELSE 0 END +
        CASE WHEN biology_score > 80 THEN 1 ELSE 0 END +
        CASE WHEN english_score > 80 THEN 1 ELSE 0 END) AS num_subjects_above_80
FROM studentscores
HAVING num_subjects_above_80 >= 3;
