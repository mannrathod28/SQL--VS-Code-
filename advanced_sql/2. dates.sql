-- ::DATE
SELECT 
    job_title_short as title,
    job_location as location, 
    job_posted_date::DATE AS date
FROM job_postings_fact;     

-- AT TIME ZONE 
SELECT 
    job_title_short as title,
    job_location as location, 
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date
FROM job_postings_fact
LIMIT 5; 

-- EXTRACT
SELECT 
    job_title_short as title,
    job_location as location, 
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM job_postings_fact
LIMIT 5; 

-- TREND ANALYSIS 
SELECT
    count(job_id) as job_count,
    EXTRACT(MONTH FROM job_posted_date) as month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month 
ORDER BY job_count DESC;

-- PRACTICE PROBLEM -> Create Tables from Other Tables
-- ❓ Question:
-- Create three tables:
-- Jan 2023 jobs , Feb 2023 jobs, Mar 2023 jobs
-- Hints: Use CREATE TABLE table_name AS syntax to create your table
-- Look at a way to filter out only specific months (EXTRACT)

CREATE TABLE Jan_2023_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE Feb_2023_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE Mar_2023_jobs AS 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT job_posted_date
from Mar_2023_jobs