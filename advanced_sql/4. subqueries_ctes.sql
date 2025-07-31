-- Sub queries inside FROM()
SELECT *
FROM (
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 1
) AS Jan_2023_jobs; 

-- Sub queries inside WHERE()
SELECT 
    company_id,
    name as company_name
FROM company_dim    
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
    ORDER BY company_id
);



-- CTES (Common Table Expressions)
WITH Jan_2023_jobs AS (
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT * 
FROM Jan_2023_jobs; 


/*
Find the companies that have the most job openings.
Get the total number of job postings per company id (job_posting_fact)
Return the total number of jobs with the company name (company_dim)
*/

WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT(*) as total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)

SELECT 
    company_dim.name as company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_dim.company_id = company_job_count.company_id   
ORDER BY total_jobs DESC 

/*
Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill
*/

WITH remote_job_skills AS(
    SELECT
        skill_id,
        COUNT(*) AS skills_count
    FROM skills_job_dim AS skills_to_job    
    INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
    WHERE job_postings.job_work_from_home = TRUE
    GROUP BY skill_id
)

SELECT 
    skills as skill_name, 
    skills_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skills_count DESC 
LIMIT 5; 

-- UNION removes duplicated when combing two result sets of SAME COLUMN AND SAME DATA TYPE 
-- while UNION ALL adds all the rows of two or more data sets completely 

/*
Q. Find job postings from the first quarter that have a salary greater than $70K
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Gets job postings with an average yearly salary > $70,000
*/

SELECT 
    job_title_short, 
    job_location, 
    job_via,
    job_posted_date::DATE,
    salary_year_avg

FROM(
    SELECT * FROM Jan_2023_jobs
    UNION ALL 
    SELECT * FROM Feb_2023_jobs
    UNION ALL
    SELECT * FROM Mar_2023_jobs
)

WHERE salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC

