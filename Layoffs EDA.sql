SELECT
company,total_laid_off,percentage_laid_off,`date`,funds_raised_millions
FROM
layoffs_staging
ORDER BY
total_laid_off DESC;

SELECT 
MAX(total_laid_off) Max_of_total_laid_off, MAX(percentage_laid_off)
FROM
layoffs_staging;


SELECT
MIN(`date`),MAX(`date`)
FROM
layoffs_staging;


SELECT 
company,location,industry,total_laid_off,percentage_laid_off
FROM 
layoffs_staging
WHERE 
percentage_laid_off = 1;


SELECT 
company, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY company
ORDER BY Sum_of_total_laid_off DESC;


SELECT 
company,total_laid_off,SUM(total_laid_off) OVER (PARTITION BY company) Sum_of_total_laid_off,ROW_NUMBER() OVER(
PARTITION BY company) Number_of_layoffs
FROM
layoffs_staging
GROUP BY company,total_laid_off
ORDER BY Sum_of_total_laid_off DESC;


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

SELECT 
industry, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY industry
ORDER BY Sum_of_total_laid_off DESC;

SELECT 
country, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY country
ORDER BY Sum_of_total_laid_off DESC;


SELECT 
stage, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY stage
ORDER BY Sum_of_total_laid_off DESC;

SELECT
SUBSTRING(`date`,1,7) `MONTH`,SUM(total_laid_off)
FROM
layoffs_staging
GROUP BY `MONTH`
ORDER BY `MONTH`
;

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

SELECT 
company, YEAR(`date`) `YEAR`, SUM(total_laid_off) Sum_of_total_laid_off
FROM
layoffs_staging
GROUP BY company, `YEAR`
ORDER BY Sum_of_total_laid_off DESC;


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


SELECT 
company,total_laid_off,percentage_laid_off, ROUND(total_laid_off/percentage_laid_off) estimated_employees
FROM
layoffs_staging
WHERE 
total_laid_off IS NOT NULL AND 
percentage_laid_off IS NOT NULL
GROUP BY company,total_laid_off,percentage_laid_off
HAVING estimated_employees IS NOT NULL
ORDER BY estimated_employees DESC;

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
