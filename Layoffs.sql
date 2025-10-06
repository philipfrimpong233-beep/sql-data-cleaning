-- View all data
SELECT 
* 
FROM world_layoffs.layoffs
;

-- Find duplicates
SELECT 
*,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions
) 
FROM world_layoffs.layoffs
;

-- Remove duplicates
WITH cte AS(
SELECT 
*,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions
) AS row_num
FROM world_layoffs.layoffs
) 
SELECT *
FROM
cte
WHERE
row_num = 1
;

-- Create staging table
CREATE TABLE `layoffs_staging` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert deduplicated data into staging table
INSERT INTO layoffs_staging
(
WITH cte AS(
SELECT 
*,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions
) AS row_num
FROM world_layoffs.layoffs
) 
SELECT *
FROM
cte
WHERE
row_num = 1
);

-- View data in staging table
SELECT 
* 
FROM 
world_layoffs.layoffs_staging;

-- Drop row_num column from staging table as it's no longer needed
ALTER TABLE layoffs_staging
DROP COLUMN row_num
;

-- Data Cleaning
-- View distinct company names
SELECT DISTINCT company
FROM 
world_layoffs.layoffs_staging
ORDER BY 1;

-- Trim whitespace from company names
SELECT company,
TRIM(company)
FROM 
layoffs_staging
;

-- Disable safe updates to allow updates without WHERE clause
SET SQL_SAFE_UPDATES = 0;

-- Perform the update to trim whitespace
UPDATE layoffs_staging
SET company = TRIM(company);

-- View distinct country names
SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1;

-- Standardize country names
UPDATE layoffs_staging
SET 
country = 'United States'
WHERE
country LIKE 'United States%';

-- View distinct industry names
SELECT DISTINCT industry
FROM layoffs_staging
ORDER BY 1;

-- Standardize industry names
UPDATE layoffs_staging
SET 
industry = 'Crypto'
WHERE
industry LIKE 'Crypto%';

-- Find rows with NULL or empty industry
SELECT 
* 
FROM 
world_layoffs.layoffs_staging
WHERE
industry IS NULL OR 
industry LIKE '';

-- Find potential matches to fill in missing industry data
SELECT 
* 
FROM 
world_layoffs.layoffs_staging T1
JOIN
layoffs_staging T2
ON 
T1.company = T2.company AND
T1.location = T2.location
WHERE
(T1.industry IS NULL OR 
T1.industry LIKE '') AND
T2.industry IS NOT NULL;

-- Set empty industry values to NULL
UPDATE layoffs_staging
SET
industry = null 
WHERE
industry LIKE '';

-- Update missing industry values based on the matches found
UPDATE layoffs_staging T1
JOIN
layoffs_staging T2
ON 
T1.company = T2.company AND
T1.location = T2.location
SET
T1.industry = T2.industry
WHERE
(T1.industry IS NULL) AND
T2.industry IS NOT NULL;

-- This company has no matches to fill in missing industry data
SELECT 
* 
FROM 
world_layoffs.layoffs_staging
WHERE
company LIKE 'Bally%';

-- Setting the date column to proper DATE format
UPDATE layoffs_staging
SET `date` = STR_TO_DATE (`date`,'%m/%d/%Y')
;

-- Modify the date column to be of type DATE
ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;

-- Find rows with NULL values in both total_laid_off and percentage_laid_off
SELECT *
FROM 
world_layoffs.layoffs_staging
WHERE
total_laid_off IS NULL AND
percentage_laid_off IS NULL;

-- Delete rows with NULL values in both total_laid_off and percentage_laid_off as they provide no useful information
DELETE
FROM 
world_layoffs.layoffs_staging
WHERE
total_laid_off IS NULL AND
percentage_laid_off IS NULL;
