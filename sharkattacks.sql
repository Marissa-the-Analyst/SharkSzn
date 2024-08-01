DROP TABLE attacks;

SELECT * FROM attacks;

-- 1. Remove Duplicates
-- 2. Standardize Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns or Rows

# Creating a staging table to prevent source data issues
CREATE TABLE attacks_staging
LIKE attacks;

# Inserting data from source data into staging table
INSERT attacks_staging
SELECT * 
FROM attacks;

SELECT *,
ROW_NUMBER() OVER(partition by `Case Number`, `Date`, Location, Injury, Sex) AS row_num
FROM attacks_staging;

# building a cte to filter on where Rows are > 1 (to find duplicates)

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(partition by `Case Number`, `Date`, Location, Injury, Sex) AS row_num
FROM attacks_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;

# this is a duplicate
SELECT *
FROM attacks_staging
WHERE `Case Number` = '1923.00.00.a'
;

# To remove, create another table with row_num, delete rows that are equal to 2
CREATE TABLE `attacks_staging2` (
  `Case Number` text,
  `Date` text,
  `Year` text,
  `Type` text,
  `Country` text,
  `Area` text,
  `Location` text,
  `Activity` text,
  `Name` text,
  `Sex` text,
  `Age` text,
  `Injury` text,
  `Fatal (Y/N)` text,
  `Time` text,
  `Species` text,
  `original order` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# Inserting data from attacks_staging

INSERT INTO attacks_staging2
SELECT *,
ROW_NUMBER() OVER(partition by `Case Number`, `Date`, Location, Injury, Sex) AS row_num
FROM attacks_staging
;

SELECT *
FROM attacks_staging2
WHERE row_num > 1;

DELETE
FROM attacks_staging2
WHERE row_num > 1;

SELECT *
FROM attacks_staging2;

-- Standardizing Data

# Trimming whitespace from Date

SELECT `Date`, (TRIM(`Date`))
FROM attacks_staging2;

UPDATE attacks_staging2
SET `Date` = (TRIM(`Date`));

SELECT `Date`, (TRIM(LEADING ' ' FROM ' 1951.12.15.R'))
FROM attacks_staging2;
# RIP attacks_staging2, accidentally updated all dates to '1951.12.15.R'
# Recreating table

CREATE TABLE `attacks_staging3` (
  `Case Number` text,
  `Date` text,
  `Year` text,
  `Type` text,
  `Country` text,
  `Area` text,
  `Location` text,
  `Activity` text,
  `Name` text,
  `Sex` text,
  `Age` text,
  `Injury` text,
  `Fatal (Y/N)` text,
  `Time` text,
  `Species` text,
  `original order` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# Inserting data from attacks_staging again

INSERT INTO attacks_staging3
SELECT *,
ROW_NUMBER() OVER(partition by `Case Number`, `Date`, Location, Injury, Sex) AS row_num
FROM attacks_staging
;

DELETE
FROM attacks_staging3
WHERE row_num > 1;

# Trimming whitespace from Date again

SELECT `Date`, (TRIM(`Date`))
FROM attacks_staging3;

UPDATE attacks_staging3
SET `Date` = (TRIM(`Date`));

# Trimmed troublesome whitespace/newline from 1951.12.15.R
SELECT `Date`, (TRIM(TRIM(BOTH '\n' FROM(TRIM(BOTH '\r' FROM `Date`))))) 
FROM attacks_staging3;

UPDATE attacks_staging3
SET `Date` = (TRIM(TRIM(BOTH '\n' FROM(TRIM(BOTH '\r' FROM `Date`)))));

# Identifying potential mis-standardization across countries/ looks fine
SELECT DISTINCT Country
FROM attacks_staging3
ORDER BY Country ASC;

# Identified some untrimmed countries
SELECT Country, TRIM(Country)
FROM attacks_staging3;

UPDATE attacks_staging3
SET Country = (TRIM(Country));

# Identifying potential standardization in Type
SELECT DISTINCT `Type`
FROM attacks_staging3
ORDER BY `Type` ASC;

# Boat, Boating, Boatomg
SELECT *
FROM attacks_staging3
WHERE `Type` LIKE 'Boatomg';

# Correcting Boat, Boating, Boatomg -> Boating
UPDATE attacks_staging3
SET `Type` = 'Boating'
WHERE `Type` LIKE 'Boat%';

SELECT *
FROM attacks_staging3;

# Identifying potential standardization in Area in USA
SELECT DISTINCT Area
FROM attacks_staging3
WHERE Country = 'USA'
ORDER BY Area ASC;

# Identified Area needs Trim
UPDATE attacks_staging3
SET Area = (TRIM(Area));

# North & South Carolinas -> needs to be removed

# Checking Location for standardization, plan to remove location not relevant to overall analysis
SELECT DISTINCT Location
FROM attacks_staging3
WHERE Country = 'USA';

# Checked Activity, Name, Age, Injury, Time
# Checking Sex for standardization
SELECT DISTINCT Sex
FROM attacks_staging3
WHERE Country = 'USA'
ORDER BY Sex ASC;

# Trimming Sex
UPDATE attacks_staging3
SET Sex = (TRIM(Sex));

# Correcting 'lli' to M
UPDATE attacks_staging3
SET Sex = 'M'
WHERE Sex = 'lli';

# Trimming Species
UPDATE attacks_staging3
SET Species = (TRIM(Species));

SELECT *
FROM attacks_staging3
WHERE Country = 'USA'
;

SELECT * 
FROM attacks_staging3
WHERE Species = "Invalid"
AND Country = "USA";

# Standardizing Species by Shark
SELECT DISTINCT Species
FROM attacks_staging3
WHERE Species LIKE '%shark%'
;

SELECT DISTINCT Species
FROM attacks_staging3
WHERE Species LIKE '%catsharks%'
;

UPDATE attacks_staging3
SET Species = 'Not Shark'
WHERE Species LIKE 'Invalid'
;

# Adjusting Date to reflect seasons than dates
SELECT `Date`
FROM attacks_staging3
WHERE `Date` LIKE "%Jun%"
OR `Date` LIKE "%Jul%"
OR `Date` LIKE "%Aug%";

UPDATE attacks_staging3
SET `Date` = "Spring"
WHERE `Date` LIKE "%Ap%";

SELECT `Date`
FROM attacks_staging3
ORDER BY `Date` ASC;

ALTER TABLE attacks_staging3
RENAME COLUMN `Date` to Season;

select *
FROM attacks_staging3
WHERE Country = 'USA';
# Remove row where north & south carolina

-- Nulls and blank values

# Removing countries that are not USA
SELECT *
FROM attacks_staging3
WHERE Country != 'USA';

DELETE
FROM attacks_staging3
WHERE Country != 'USA';

# Looking at Sex/ remove Nulls from Sex
select *
FROM attacks_staging3
WHERE Sex = ""
OR Sex IS NULL;

DELETE
FROM attacks_staging3
WHERE Sex = ""
OR Sex IS NULL;

# Looking at Area/ remove Nulls from Area
select *
FROM attacks_staging3
WHERE Area = ''
OR Area IS NULL
;

DELETE
FROM attacks_staging3
WHERE Area = ''
OR Area IS NULL;

# Looking at Fatal/ remove Nulls from Fatal
select *
FROM attacks_staging3
WHERE `Fatal (Y/N)` = ''
OR `Fatal (Y/N)` IS NULL
;

DELETE
FROM attacks_staging3
WHERE `Fatal (Y/N)` = ''
OR `Fatal (Y/N)` IS NULL
;

# Looking at Species/ add to unknown
select *
FROM attacks_staging3
WHERE Species = ''
OR Species IS NULL;

UPDATE attacks_staging3
SET Species = "Unknown"
WHERE Species = ''
OR Species IS NULL;

# Correcting standardization in Fatal
select distinct `Fatal (Y/N)`
from attacks_staging3;

select * 
from attacks_staging3
WHERE `Fatal (Y/N)` = 'UNKNOWN';

DELETE
FROM attacks_staging3
WHERE `Fatal (Y/N)` = 'UNKNOWN'
;

# Reducing dimensionality
ALTER TABLE attacks_staging3
DROP column row_num;

ALTER TABLE attacks_staging3
DROP column `Time`;

ALTER TABLE attacks_staging3
DROP column Age;

ALTER TABLE attacks_staging3
DROP column `Name`;

ALTER TABLE attacks_staging3
DROP column Location;

select * 
from attacks_staging3;

# Removing 'North & South Carolina'
select distinct `Area`
FROM attacks_staging3;

DELETE
FROM attacks_staging3
WHERE `Area` = 'North & South Carolina'
;

# Standardization of Season
select * 
from attacks_staging3
WHERE Season != 'Fall'
AND Season != 'Spring'
AND Season != 'Summer'
AND Season != 'Winter';

UPDATE attacks_staging3
SET Season = "Fall"
WHERE Season = "Fall 2008"
;

DELETE
FROM attacks_staging3
WHERE Season != 'Fall'
AND Season != 'Spring'
AND Season != 'Summer'
AND Season != 'Winter';

# Checking standardization in species
select distinct Species
from attacks_staging3;

SELECT *
FROM attacks_staging3
WHERE Species = ' ';

UPDATE attacks_staging3
SET Species = "Unknown"
WHERE Species = ' '
;

SELECT *
FROM attacks_staging3
WHERE `Fatal (Y/N)` = "N"
AND Area = "California";