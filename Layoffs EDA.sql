-- Exploratory Data Analysis on Layoffs Data
SELECT
company,total_laid_off,percentage_laid_off,`date`,funds_raised_millions
FROM
layoffs_staging
ORDER BY
total_laid_off DESC;


-- Summary statistics for numerical columns
SELECT 
MAX(total_laid_off) Max_of_total_laid_off, MAX(percentage_laid_off)
FROM
layoffs_staging;


-- Range of dates in the dataset
SELECT
MIN(`date`),MAX(`date`)
FROM
layoffs_staging;


-- Check the companies with 100% layoffs
SELECT 
company,location,industry,total_laid_off,percentage_laid_off
FROM 
layoffs_staging
WHERE 
percentage_laid_off = 1;


-- Top companies by total layoffs
SELECT 
company, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY company
ORDER BY Sum_of_total_laid_off DESC;


-- Checking number of layoffs events per company
SELECT 
company,total_laid_off,SUM(total_laid_off) OVER (PARTITION BY company) Sum_of_total_laid_off,ROW_NUMBER() OVER(
PARTITION BY company) Number_of_layoffs
FROM
layoffs_staging
GROUP BY company,total_laid_off
ORDER BY Sum_of_total_laid_off DESC;


-- Companies with more than one layoff event
WITH cte AS(
SELECT 
company,total_laid_off,SUM(total_laid_off) OVER (PARTITION BY company) Sum_of_total_laid_off,ROW_NUMBER() OVER(
PARTITION BY company) Number_of_layoffs
FROM
layoffs_staging
GROUP BY company,total_laid_off
ORDER BY Sum_of_total_laid_off DESC
)
SELECT 
DISTINCT company
FROM
cte 
WHERE
Number_of_layoffs > 1;


-- Top industries by total layoffs
SELECT 
industry, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY industry
ORDER BY Sum_of_total_laid_off DESC;


-- Top countries by total layoffs
SELECT 
country, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY country
ORDER BY Sum_of_total_laid_off DESC;


-- Top stages by total layoffs
SELECT 
stage, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY stage
ORDER BY Sum_of_total_laid_off DESC;


-- Layoffs trend over time (monthly)
SELECT
SUBSTRING(`date`,1,7) `MONTH`,SUM(total_laid_off)
FROM
layoffs_staging
GROUP BY `MONTH`
ORDER BY `MONTH`
;


-- Rolling total of layoffs over time (monthly)
WITH cte AS(
SELECT
SUBSTRING(`date`,1,7) `MONTH`,SUM(total_laid_off) sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY `MONTH`
ORDER BY `MONTH`
)
SELECT 
*,SUM(sum_of_total_laid_off) OVER( ORDER BY `MONTH`) rolling_total
FROM
cte
WHERE
`MONTH` IS NOT NULL;


-- Yearly layoffs by company
SELECT 
company, YEAR(`date`) `YEAR`, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY company, `YEAR`
ORDER BY Sum_of_total_laid_off DESC;


-- Top 10 companies by layoffs each year
WITH cte AS(
SELECT 
company, YEAR(`date`) `YEAR`, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY company, `YEAR`
ORDER BY Sum_of_total_laid_off DESC
),cte2 AS (
SELECT
*, DENSE_RANK() OVER (PARTITION BY `YEAR` ORDER BY Sum_of_total_laid_off DESC) ranking_per_year
FROM cte
WHERE
`YEAR` IS NOT NULL 
)
SELECT
*
FROM 
cte2
WHERE
ranking_per_year < 11;


-- Estimating total number of employees before layoffs
SELECT 
company,total_laid_off,percentage_laid_off, ROUND(total_laid_off/percentage_laid_off) estimated_total_employees
FROM
layoffs_staging
WHERE 
total_laid_off IS NOT NULL AND 
percentage_laid_off IS NOT NULL
GROUP BY company,total_laid_off,percentage_laid_off
HAVING estimated_total_employees IS NOT NULL
ORDER BY estimated_total_employees DESC;


-- Correlation between funds raised and layoffs
SELECT 
company,total_laid_off,percentage_laid_off,YEAR(`date`) years,ROUND((total_laid_off) / (percentage_laid_off)) estimated_employees,funds_raised_millions
FROM
layoffs_staging
WHERE 
total_laid_off IS NOT NULL AND 
percentage_laid_off IS NOT NULL
GROUP BY company,total_laid_off,percentage_laid_off,funds_raised_millions,years
HAVING estimated_employees IS NOT NULL
ORDER BY funds_raised_millions DESC;

