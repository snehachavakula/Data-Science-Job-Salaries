select * from portfolio_projects.dbo.ds_salaries$

--updating employment type
ALTER TABLE portfolio_projects.dbo.ds_salaries$
ADD [new_employment_type] FLOAT;

UPDATE portfolio_projects.dbo.ds_salaries$
SET [new_employment_type] = CASE WHEN employment_type = 'FT' THEN 'Full-Time'
    WHEN employment_type = 'FL' THEN 'Freelance'
    WHEN employment_type = 'CT' THEN 'Contract'
    WHEN employment_type = 'PT' THEN 'Part-Time'
    ELSE employment_type END
--update remote ratio
ALTER TABLE portfolio_projects.dbo.ds_salaries$
ADD [new_remote_ratio] nvarchar(255);

UPDATE portfolio_projects.dbo.ds_salaries$
SET [new_remote_ratio] = CASE WHEN remote_ratio = 0 THEN 'In-Office'
    WHEN remote_ratio = 50 THEN 'Hybrid'
    WHEN remote_ratio = 100 THEN 'Fully Remote'
    ELSE CAST(remote_ratio AS nvarchar(255))
	END

--update experience_level
ALTER TABLE portfolio_projects.dbo.ds_salaries$
ADD [new_experience_level] nvarchar(255);

UPDATE portfolio_projects.dbo.ds_salaries$
SET [new_experience_level] = CASE WHEN experience_level = 'EN' THEN 'Entry Level'
    WHEN experience_level = 'EX' THEN 'Executive Level'
    WHEN experience_level = 'MI' THEN 'Mid Level'
	WHEN experience_level = 'SE' THEN 'Senior Level'
    ELSE experience_level END

--dropping columns
ALTER TABLE portfolio_projects.dbo.ds_salaries$
DROP COLUMN salary

ALTER TABLE portfolio_projects.dbo.ds_salaries$
DROP COLUMN salary_currency, F1

ALTER TABLE portfolio_projects.dbo.ds_salaries$
DROP COLUMN employment_type, experience_level, remote_ratio


--Top 10 Highest Paying Job Profile
select top 10 job_title, AVG(salary_in_usd) as avg_salary
from portfolio_projects.dbo.ds_salaries$
GROUP BY job_title
order by AVG(salary_in_usd) desc

select top 10 job_title, MAX(salary_in_usd) as salary
from portfolio_projects.dbo.ds_salaries$
GROUP BY job_title
order by max(salary_in_usd) desc


-- no of jobs variation over company size
select company_size, COUNT(job_title) as job_count 
from portfolio_projects.dbo.ds_salaries$
group by company_size

--Top 5 high demand jobs in data science
select job_title, count(*)
from portfolio_projects.dbo.ds_salaries$
group by job_title
order by count(*) desc

-- job count over the years
select work_year, count(*)
from portfolio_projects.dbo.ds_salaries$
group by work_year
order by count(*) desc

--Average salaries over the years
select work_year, avg(salary_in_usd) as avg_salary
from portfolio_projects.dbo.ds_salaries$
group by work_year

--Average Salaries Based On Their Employment Types 
select new_employment_type, avg(salary_in_usd) as avg_salary
from portfolio_projects.dbo.ds_salaries$
group by new_employment_type

-- Average saaries based on experience level
select new_experience_level, avg(salary_in_usd) as avg_salary
from portfolio_projects.dbo.ds_salaries$
group by new_experience_level

-- job count based on experience level
select new_experience_level, count(*)
from portfolio_projects.dbo.ds_salaries$
group by new_experience_level

--Which Company Type Are More Flexibile Towards Remote Jobs
select company_size, remote_ratio, count(remote_ratio)
from portfolio_projects.dbo.ds_salaries$
group by company_size, remote_ratio
order by company_size

-- Top 10 company locations with higher salaries
select TOP 10 company_location, AVG(salary_in_usd) as avg_salary
from portfolio_projects.dbo.ds_salaries$
GROUP BY company_location
order by AVG(salary_in_usd) desc

--Which are the Highest Paying Jobs Profile In India 
select job_title, company_location, avg(salary_in_usd) as avg_salary
from portfolio_projects.dbo.ds_salaries$
where company_location = 'IN'
group by job_title, company_location
order by avg_salary desc

--Top-5 high paying Jobs Over The Years In Data science
SELECT work_year, job_title, salary_in_usd
FROM (
  SELECT work_year, job_title, salary_in_usd,
         ROW_NUMBER() OVER (PARTITION BY work_year ORDER BY salary_in_usd DESC) as rank
  FROM portfolio_projects.dbo.ds_salaries$
) ranked
WHERE rank <= 5
ORDER BY work_year, rank

-- Most popular jobs over the years
SELECT work_year, job_title, job_count
FROM (
  SELECT work_year, job_title, count(*) AS job_count ,
         ROW_NUMBER() OVER (PARTITION BY work_year ORDER BY count(*) DESC) as rank
  FROM portfolio_projects.dbo.ds_salaries$
  GROUP BY job_title, work_year
) ranked
WHERE rank <= 5
ORDER BY work_year desc, rank



