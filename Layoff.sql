SELECT * 
FROM world_layoffs.layoffs_staging
;

SELECT company,
MAX(percentage_laid_off),
MAX(total_laid_off)
FROM world_layoffs.layoffs_staging
GROUP BY 1
;

SELECT SUBSTRING(`date`,1,7) AS 'MONTH' ,SUM(total_laid_off) AS sum_laid_off
FROM 
world_layoffs.layoffs_staging
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 ASC;

WITH cte AS 
(
SELECT SUBSTRING(`date`,1,7) AS 'MONTH' ,SUM(total_laid_off) AS sum_laid_off
FROM 
world_layoffs.layoffs_staging
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 ASC
)
SELECT `MONTH`,sum_laid_off, SUM(sum_laid_off) OVER(ORDER BY `MONTH`) AS rolling
FROM cte;

SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company, YEAR(`date`)
ORDER BY company;

WITH T AS (
SELECT company,YEAR(`date`) AS 'YEAR',SUM(total_laid_off) AS Tot_laid
FROM layoffs_staging
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, YEAR(`date`)
ORDER BY company
),R AS (
SELECT *, DENSE_RANK() OVER( PARTITION BY `YEAR` ORDER BY (Tot_laid) DESC) AS Ranking
FROM T
GROUP BY company,`YEAR`
)
SELECT *
FROM R
WHERE Ranking < 6;

