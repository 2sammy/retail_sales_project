CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,	
	sale_time TIME,	
	customer_id INT,
	gender VARCHAR(16),	
	age	INT,
	category VARCHAR(16),	
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
)

DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR 
cogs IS NULL
OR
total_sale IS NULL

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR 
cogs IS NULL
OR
total_sale IS NULL


-- data exploration
-- how many sales do we have
-- total sales
SELECT 
COUNT(*) as total_sale
FROM retail_sales

-- how many unique customers do we have
SELECT 
COUNT  (distinct customer_id) as total_customers
from retail_sales

-- how many unique categories are there
SELECT 
 distinct category as total_categories
from retail_sales

-- Data Analysis & Business key problems and answers

-- Write a SQL to retreive all columns for sales made on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Write a SQL to retreive all transactions where 
--the category is clothing and the quantiy sold is ore than 30
-- in the on the of nov 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
AND 
TO_CHAR(sale_date,'YYYY-MM')= '2022-11' 
AND 
quantiy >=4

-- Write a SQL to retreive all transactions where 
--the category is beauty and the quantiy sold is ore than 3
-- in the on the of oct 2022
SELECT *
FROM retail_sales
WHERE category = 'Beauty' 
AND 
TO_CHAR(sale_date,'YYYY-MM')= '2022-10' 
AND 
quantiy >=3

-- Calculate total sales for each category and total orders
SELECT category,
COUNT(*) AS total_orders,
SUM(total_sale) AS Total_sales
FROM retail_sales
GROUP BY category

-- find average age of customers who purchased items from beauty category
SELECT 
category,
ROUND(AVG(age), 2) AS average_age,
SUM(total_sale) AS Total_sales
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category

-- transactions where the total sales is greater than 1000
SELECT *
FROM retail_sales
where 
total_sale > 1000

---find the total number of transactions made by each gender in each category
SELECT 
	COUNT(*) AS total_transactions,
	gender,
	category
FROM retail_sales
GROUP
BY 
gender,
category

-- calculate the average sale for each month.
SELECT 
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
AVG(total_sale) AS avarage_sale
FROM retail_sales
GROUP BY 1,2


-- Find the best selling month each year
SELECT
year,
month,
avg
FROM(
SELECT 
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)
ORDER BY AVG(total_sale) DESC ) AS rank,
AVG(total_sale)
FROM retail_sales
GROUP BY 1,2
--ORDER BY 1,3 
) AS t1
WHERE rank = 1

--find the top 5 customers based on the highest total sales
SELECT 
customer_id,
SUM(total_sale) AS sales
FROM retail_sales
group by 1
order by 2 desc
limit 5

-- number of unique customers who purchased items from each category

SELECT 
count( distinct customer_id),
category
FROM retail_sales
group by category

-- create each shift and number of orders (eg morning<12, afternoon between 12 and 17, evening > )
WITH hourly_sale AS(
SELECT *,
	CASE
	WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END AS shift
	
FROM retail_sales
)
SELECT
COUNT(*) as total_orders,
shift
FROM hourly_sale
group by shift