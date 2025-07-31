SELECT
    COUNT(job_id) AS job_count, 
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'local'
        ELSE 'Onsite'
    END location_category 
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category

