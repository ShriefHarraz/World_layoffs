Select *
from layoffs;

---- Make a copy of the dataset----

Create table Layoffs_2
like layoffs;

insert into Layoffs_2
Select *
from layoffs;

select *
from layoffs_2;

--- Clean the Data ----
--- First Step ----
---- Formating and standarlize the Data ----

select company, trim(company)
from layoffs_2
order by 1;

update layoffs_2
set company = trim(company);
------------------------------
Select distinct location
from layoffs_2
where location like 'D%' 
order by 1;


UPDATE layoffs_2
Set location = 'Malmo'
where location like 'mal%' ;

UPDATE layoffs_2
Set location = 'Dusseldorf'
where COMPANY = 'Springlane' ;
-----------------------------------------
select  industry
from layoffs_2
where industry like 'crypto%'
order by 1;

UPDATE layoffs_2
Set industry = 'Crypto'
where industry like 'crypto%' ;
----------------------------------------
select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_2;

update layoffs_2
SET `date` = str_to_date(`date`,'%m/%d/%Y');
-----------------------------------------------

select Distinct country
from layoffs_2
where country like 'United States%'
order by 1;

update layoffs_2
set country = 'United States'
where country like 'United States%';
---------------------------------------------------
--- Second Step ----
---- Dealing with blank and NULL Values ----

Select *
from layoffs_2;

update layoffs_2
set industry = null
where industry = '';

select *
from layoffs_2
where industry is null ;

select *
from layoffs_2
where company = 'carvana';

select lay2.company, lay2.location, lay2.industry, lay3.industry
from layoffs_2 lay2
join layoffs_2 lay3
on lay2.company = lay3.company
and lay2.location = lay3.location
where lay2.industry is null 
and lay3.industry is not null; 

update layoffs_2 lay2
join layoffs_2 lay3
on lay2.company = lay3.company
and lay2.location = lay3.location
set lay2.industry = lay3.industry
where lay2.industry is null 
and lay3.industry is not null;
-----------------------------------------------
Select *
from layoffs_2
where percentage_laid_off is NULL
and total_laid_off is null;


delete 
from layoffs_2
where percentage_laid_off is NULL
and total_laid_off is null;

select *
from layoffs_2;

---------------------------------------------------
--- Third Step ----
---- Remove duplicates ----


select *,
row_number() over ( partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num 
from layoffs_2;

with dup_cte as (
select *,
row_number() over ( partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num2
from layoffs_2)
delete FROM layoffs_2
where company in ( select company from dup_cte where row_num2 > 1);

select *
from dup_cte
where row_num2 >1;

select *
from layoffs_2;
-------------------------------------------------------------------------------
---- Exploratory Data Analysis ----
-------------------------------------------------------------------------
select *
from layoffs_2;

select count(*) total_rows
from layoffs_2; 

--- Q1 Which Industries are most affected by layoffs ---

select industry, sum(total_laid_off) total_laid_off, round(AVG(percentage_laid_off),2) avg_laid_off
from layoffs_2
group by 1
order by 2 DESC;

--- Q2 Which companies are most affected by layoffs ---

select company, sum(total_laid_off) total_laid_off, round(AVG(percentage_laid_off),2) avg_laid_off
from layoffs_2
group by 1
order by 2 DESC;

--- Q3 what the countries that more affected by layoffs ----

select country, sum(total_laid_off) total_laid_off
from layoffs_2
group by 1
order by 2 DESC;

---- Q4 Check which stage is affected more ---

select stage, sum(total_laid_off) total_laid_off, round(AVG(percentage_laid_off),2) avg_laid_off, count(*) num_companies
from layoffs_2
group by 1
order by 2 DESC;

---- Q5 Check the relation between the funds and the layoffs ---

select min(funds_raised_millions), max(funds_raised_millions)
from layoffs_2;

select 
case 
    when funds_raised_millions <50 then 'low_fund'
    when funds_raised_millions between 50 and 100 then 'Med_fund'
    else 'high_fund'
    end fund_range, sum(total_laid_off) total_laid_off, round(AVG(percentage_laid_off),2) avg_laid_off, count(*) num_companies
from layoffs_2
group by 1
order by 2 DESC;

---- Q6 Check which year has more layoffs ---
select 
year(`date`), sum(total_laid_off) total_laid_off, round(AVG(percentage_laid_off),2) avg_laid_off, count(*) num_companies
from layoffs_2
group by 1
order by 1 ;
