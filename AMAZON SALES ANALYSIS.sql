Capstone project hitesh sehrawat 
CREATE database capstone_project;
use  capstone_project;

set sql_safe_updates = 0;

-- objective=
-- it involves sales analysis, product analysis, customer analysis from the given dataset.

select * from sales;
 
 alter table sales
 add column timeofday varchar(20) after time ;
 
 UPDATE capstone_project.sales
 SET timeofday =
 case
 when hour(time(concat(date, ' ', time))) between 6 and 11 then 'morning'
 when hour(time(concat(date, ' ', time))) between 12 and 17 then 'afternoon'
 when hour (time(concat(date, ' ' , time))) between 18 and 23 then 'evening'
 ELSE 'Night'
 end;
 select timeofday from sales;
 
 alter table sales
 add column dayname varchar(50);
 
 UPDATE capstone_project.sales
 SET dayname = DAYNAME(date);
 
 select dayname from sales;
 
 alter table sales
 add column monthname varchar (20);
 
UPDATE capstone_project.sales
SET monthname = MONTHNAME(date);
select monthname from sales;

select * from sales;

-- exploratory data analysis--
-- 1. what is the count of distinct cities in the dataset?--
select city,count(DISTINCT city) as distinct_city_count 
from sales
group by city;

-- /insights
-- the business operates in 3 distinct cities. i.e, yangon, mandalay, naypyitaw
-- if the business wants to expands to new location, this analysis will help in it.

-- 2. For each branch, what is the corresponding city?
select distinct Branch, city from sales;

-- /insights
-- this query helps map each branch to its respective city
-- if the dataset contains duplicate records, they wont be counted multiple times.
-- helps in regional sales analysis and allowing business to compare performance between the branches 

-- 3 What is the count of distinct product lines in the dataset?
select `product line`,COUNT(distinct `product line`) as distinct_product_lines 
from sales
group by 1;

-- /insights
-- It shows how diverse your product offerings are.
-- it Helps in understanding how your products are categorized, which can assist in market analysis.

-- 4 Which payment method occurs most frequently?
select Payment, count(*) 
FROM sales
group by Payment
order by count(*) 
desc limit 1;

-- /insights
-- 1 it helps in  identifying the preferred payment method of your customers.
-- 2 With knowledge of the preferred payment method, you can tailor marketing strategies 
-- and promotions to encourage the use of the most popular payment option.

-- 5 Which product line has the highest sales?
SELECT `product line`, SUM(cogs) AS total_sales
FROM sales
GROUP BY `product line`
ORDER BY total_sales DESC
LIMIT 1;

-- /INSIGHTS
-- 1 It helps understand which product line requires the most financial resources in terms of production or procurement,
--  indicating areas where cost management might be essential.
-- 2 IT can guide decisions about resource allocation, ensuring that investments
--  and efforts are directed toward the most impactful product lines.
-- 3  IT can help optimize inventory strategies, ensuring that production and storage costs are managed effectively.


SELECT `product line`, SUM(cogs) AS total_sales
FROM sales
GROUP BY `product line`
ORDER BY total_sales ;

-- 6 How much revenue is generated each month?
SELECT monthname , sum(total) as monthly_revenue from sales
group by monthname 
order by monthly_revenue desc;
 
 -- /insights
 -- 1 This helps in understanding seasonal trends or identifying months with exceptional performance.
 -- 2 The insights can assist in making informed business decisions such as planning sales strategies, managing inventory,
 -- and scheduling promotions to optimize revenue generation.
 
 -- 7 In which month did the cost of goods sold reach its peak?
 select monthname, sum(cogs) as total_cogs from sales
 group by monthname
 order by total_cogs desc;
 
 -- /insights
 -- 1 This analysis can lead to better cost management and optimization strategies.
 
 -- 8 Which product line generated the highest revenue?
 select `product line`, sum(total) as total_revenue
 from sales 
 group by `product line`
 order by total_revenue desc;
 
 -- /insights
 -- 1 it can helps identify which product lines are contributing the most to the overall revenue and which ones are lagging.
 -- 2 This can help in making data-driven decisions about discontinuing or revamping underperforming product lines.
 
 -- 9 In which city was the highest revenue recorded?
 select city, sum(total) as total_revenue
 from sales
 group by city
 order by total_revenue desc ;
 
 -- /insights
 -- 1 naypyitaw has recorded the highest revenue while the lowest revenue is recorded in mandalay.
 
 -- 10 Which product line incurred the highest Value Added Tax?
 select `product line` , sum(`tax 5%`) as total_vat
 from sales
 group by `product line`
 order by total_vat DESC limit 1;
 
 -- /INSIGHTS
 -- 1High VAT amounts usually correlate with higher sales volumes or higher-priced items. By analyzing the product lines with the highest VAT,
 -- you can identify which product lines are performing well in terms of sales.
 
 -- 11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
 
 select `product line`, total,
 case
 when total > avg(total) over() then "good"
 else "bad"
 end as sales_review from sales; 
 
 select avg(total) from sales;
 
 -- / insights
 -- it will help in analysing which product line is doing good and bad in the market 
 
 -- 12 Identify the branch that exceeded the average number of products sold? 
 select Branch, sum(quantity)as products_sold from sales 
 group by Branch
 having sum(quantity)> (select avg(products_sold)
 from (select sum(quantity) as products_sold from sales group by Branch) as branch_total);
 
 -- /insights
 -- it helped in  identify how many products, on average, each branch has sold.
 
 -- 13 Which product line is most frequently associated with each gender?
SELECT gender, `product line`, COUNT(*) AS frequency
FROM sales
GROUP BY gender, `product line`
ORDER BY gender, frequency DESC;

-- /insights
-- The results will help identify trends in purchasing behavior.
 
 -- 14 Calculate the average rating for each product line.
 select `product line` , avg(rating) as `avg rating` from sales 
 group by `product line` ;
 
 -- /insights
 -- 1 this helps you understand how well each product line is perceived by customers.
 -- 2 it can help in  identify the top-performing and underperforming product lines.
 
 
 -- 15 Count the sales occurrences for each time of day on every weekday?
 select distinct dayname, timeofday, count(*) as count_of_sales_occurance from sales
 where dayname not in ("saturday","sunday")
 group by 1,2 
 order by dayname asc;
 
 -- /insights
 -- in all weekdays especially only in afternoon the sales were more.
 
 -- 16 Identify the customer type contributing the highest revenue.
 select `customer type` , sum(total) as total_revenue
 from sales
 group by `customer type` 
 order by total_revenue desc 
 limit 1;
 
 select *from sales;
 
 -- / insights
 -- Knowing which customer type is the highest contributor can help you allocate resources
 -- (such as sales staff, customer service, inventory, etc.) more effectively.
 
 -- 17 Determine the city with the highest VAT percentage?
 select city, round(sum(`tax 5%`)) as highest_vat_percentage from sales
 group by city
 order by highest_vat_percentage desc limit 1;
     
     -- /insights
     -- 1 Understanding which city has the highest VAT percentage allows
     -- you to consider the impact on customer spending in that region.
     
     -- 18 Identify the customer type with the highest VAT payments.
     select `customer type` , sum(`tax 5%`) as highest_vat_paid
     from sales 
     group by `customer type`
     order by highest_vat_paid desc limit 1;
 
 -- /insights
 -- The customer type with the highest VAT payments is likely purchasing larger quantities
 -- or more expensive items, leading to higher tax contributions.
 
 -- 19 What is the count of distinct customer types in the dataset?
 select `customer type`, count(distinct `customer type`) from sales
 group by `customer type`;
 
 -- /insights 
 -- there are 2 distinct type of customers in this dataset 
 
 -- 20 What is the count of distinct payment methods in the dataset?
 select count(distinct payment) from sales;
 
 -- /insights 
 -- there are 3 distinct count of payments methodes in dataset 
 
-- 21 Which customer type occurs most frequently?
select `customer type` , count(`customer type`) as counted_customer_type from sales 
group by `customer type`
order by counted_customer_type desc;

-- /insights 
-- here member customer type occure 501 time so that is the most frequent occured type


-- 22 Identify the customer type with the highest purchase frequency?
select `customer type` , round(sum(total),2) as highest_purchase from sales
group by `customer type` 
order by highest_purchase desc;

-- /insights : the highest purshase is of member customer type i.e, 164223.44
-- there are two customer type here 1.member 2. normal

-- 23 Determine the predominant gender among customers?
select gender , count(*) as gender_count from sales
group by gender 
order by gender_count desc;

-- /insights 
-- the most predominant gender among customer is female with 501 count and the males are 499
-- it helps us to analyse that female 
-- are more actuvely involved in online shopping then males in those particular region .

-- 24Examine the distribution of genders within each branch?
select Branch, gender , count(*) as gender_count from sales 
group by Branch , gender
order by Branch, gender_count desc;

-- /insights 
-- A	Male	179
-- A	Female	161
-- B	Male	170
-- B	Female	162
-- C	Female	178
-- C	Male	150

-- 25 Identify the time of day when customers provide the most ratings?
select timeofday, count(rating)as most_ratings from sales
group by timeofday;

-- /insights 
-- most of the ratings are provided by customers in afternoon.

-- 26 Determine the time of day with the highest customer ratings for each branch?
select distinct Branch, timeofday, count(rating)as most_ratings, rank() over (partition by Branch order by count(rating) desc)
as highest_rank from sales group by 1,2 ;

-- /insights
-- highest avergae rating of all three branches are on afternoon.

-- 27 Identify the day of the week with the highest average ratings?
select dayname, round(avg(rating),3)as highest_ratings from sales 
group by dayname
order by highest_ratings desc;

-- / insights
-- the highest avergae rating is done on monday

-- 28 Determine the day of the week with the highest average ratings for each branch?


-- /insights
-- in branch A AND C HIGHEST RATING WAS GIVEN ON FRIDAY 
-- IN BRANCH B HIGHEST RATING GIVEN ON MONDAY 

-- END OF CAPSTONE PROJECT ------ THANK YOU -----


 
