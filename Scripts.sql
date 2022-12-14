
#Quering and Cleaning age_standardized_suicide_rates  table
SELECT 
    *
FROM
    age_standardized_suicide_rates;
    
DELETE FROM age_standardized_suicide_rates 
WHERE
    Country = 'Country';

#Updating columns
alter table age_standardized_suicide_rates
CHANGE COLUMN `2016` `Rate_in_2016` DECIMAL (3,1) NULL;
alter table age_standardized_suicide_rates
CHANGE COLUMN `2015` `Rate_in_2015` DECIMAL (3,1) NULL;
alter table age_standardized_suicide_rates
CHANGE COLUMN `2010` `Rate_in_2010` DECIMAL(3,1) NULL;
alter table age_standardized_suicide_rates
CHANGE COLUMN `2000` `Rate_in_2000` DECIMAL (3,1) NULL; 

#Confirming the number of distinct/duplicated countries
SELECT 
    COUNT(Country) - COUNT(DISTINCT country)
FROM
    age_standardized_suicide_rates
WHERE
    Sex = ' Both sexes';
    
SELECT 
    COUNT(Country) - COUNT(DISTINCT country)
FROM
    age_standardized_suicide_rates
WHERE
    Sex = ' female';
    
SELECT 
    COUNT(Country) - COUNT(DISTINCT country)
FROM
    age_standardized_suicide_rates
WHERE
    Sex = ' male';

#Querying facilities tables
SELECT 
    *
FROM
    facilities;

#How many countries are in the facilities table 
SELECT 
    COUNT(Country)
FROM
    facilities;
    
#Quering the sucide rate of both sexes for the country with the highest Mental_hospital
SELECT 
    M.Country, YEAR, Mental_hospitals, Rate_in_2016 AS sucide
FROM
    age_standardized_suicide_rates M
         LEFT JOIN
    facilities F ON M.Country = F.Country
WHERE
    Sex = ' Both sexes'
ORDER BY Mental_hospitals DESC;

#What is the average rate of sucide in 2016
SELECT 
    AVG(Rate_in_2016)
FROM
    age_standardized_suicide_rates;

#What is the average mental hospital 
SELECT 
    AVG(Mental_hospitals)
FROM
    facilities;

#What is the sucide rate (for both sexes) of the countries with mental hospitals greater than the average     
SELECT 
    M.Country, YEAR, Mental_hospitals, Rate_in_2016 AS sucide
FROM
    age_standardized_suicide_rates M
        LEFT JOIN
    facilities F ON M.Country = F.Country
WHERE
    Sex = ' Both sexes'
        AND Mental_hospitals > 0.197785
ORDER BY Mental_hospitals;

#What are the countries with sucide rate greater than average (for both sexes)      
SELECT 
    M.Country, YEAR, Mental_hospitals, Rate_in_2016 AS sucide
FROM
    age_standardized_suicide_rates M
        LEFT JOIN
    facilities F ON M.Country = F.Country
WHERE
    Sex = ' Both sexes'
        AND Rate_in_2016 > 9.83607 
ORDER BY Rate_in_2016;

#What is the gender with the highest number of sucide rate?
SELECT 
    Country, Sex, Rate_in_2016
FROM
    age_standardized_suicide_rates
WHERE
    Rate_in_2016 = (SELECT 
            MAX(Rate_in_2016)
        FROM
            age_standardized_suicide_rates);
	#OR to have a broad view
select Country,  Sex , Rate_in_2016
from age_standardized_suicide_rates
order by Rate_in_2016 DESC;

#Quering Mental_hospitals for countries with the highest and lowest Sucide rate for both genders
SELECT 
    M.Country, YEAR, Mental_hospitals, Rate_in_2016 AS sucide
FROM
    age_standardized_suicide_rates M
        LEFT JOIN
    facilities F ON M.Country = F.Country
WHERE
    Sex = ' Both sexes'
        AND (Rate_in_2016 = (SELECT 
            MAX(Rate_in_2016)
        FROM
            age_standardized_suicide_rates
        WHERE
            Sex = ' Both sexes')
        OR Rate_in_2016 = (SELECT 
            MIN(Rate_in_2016)
        FROM
            age_standardized_suicide_rates
        WHERE
            Sex = ' Both sexes'))
ORDER BY Rate_in_2016 DESC;

#What is the maximum sucide rate in each country
With r as (select Country, Sex, Rate_in_2016, dense_rank () over (partition by Country order by Rate_in_2016 DESC) as r  
from age_standardized_suicide_rates)

SELECT Country, Sex, Rate_in_2016 AS sucide
	FROM r 
	WHERE r =1; 

#Countrires with duplicated entries for maximum sucide rate as the expected rows should be 183.
#These are the countries with the same maximum sucide rate for female, male or both sexes  
With r as (select Country, Sex, Rate_in_2016, dense_rank () over (partition by Country order by Rate_in_2016 DESC) as r  
from age_standardized_suicide_rates)

SELECT Country, Sex, Rate_in_2016 AS sucide
	FROM r 
	WHERE r =1
    group by country having count(*)>1;  

#What is the number of countries with maximum sucide rate who are females?
With r as (select Country, Sex, Rate_in_2016, dense_rank () over (partition by Country order by Rate_in_2016 DESC) as r  
from age_standardized_suicide_rates)

SELECT  count(sex)
	FROM r 
	WHERE r =1 and sex = ' female' ; 
    
#What are the countries with maximum sucide rate who are females?
With r as (select Country, Sex, Rate_in_2016, dense_rank () over (partition by Country order by Rate_in_2016 DESC) as r  
from age_standardized_suicide_rates)

SELECT Country, sex, Rate_in_2016 AS sucide
	FROM r 
	WHERE r =1 and sex = ' female' 
    Group by country; 

#What is the number of countries with maximum sucide rate who are males?
With r as (select Country, Sex, Rate_in_2016, dense_rank () over (partition by Country order by Rate_in_2016 DESC) as r  
from age_standardized_suicide_rates)

SELECT  count(sex)
	FROM r 
	WHERE r =1 and sex = ' male'; 
 

#What are the countries with maximum sucide rate who are males?
With r as (select Country, Sex, Rate_in_2016, dense_rank () over (partition by Country order by Rate_in_2016 DESC) as r  
from age_standardized_suicide_rates)

SELECT Country, sex, Rate_in_2016 AS sucide
	FROM r 
	WHERE r =1 and sex = ' male' 
    Group by country; 
  