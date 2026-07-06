-- SQL Retail Sales Analysis 
CREATE DATABASE project_1;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			( 
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(25),	
				quantity INT,
				price_per_unit	FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

SELECT *
FROM retail_sales
LIMIT 10;

SELECT COUNT(*)
FROM retail_sales;

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;       

SELECT *
FROM retail_sales
WHERE age IS NULL;  

-- Data Cleaning

SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL
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
    price_per_unit IS NULL
    OR 
    cogs IS NULL
    OR 
    total_sale IS NULL;
    
DELETE FROM retail_sales -- Deleting Rows with NULL values
WHERE 
	transactions_id IS NULL
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
    price_per_unit IS NULL
    OR 
    cogs IS NULL
    OR 
    total_sale IS NULL;
    
-- Data Exploraton

-- How many sales we have
SELECT COUNT(*) AS total_sales 
FROM retail_sales;

-- How many uniqe customers we have
SELECT COUNT(DISTINCT customer_id) as total_customers
FROM retail_sales;

-- How many uniqe category we have
SELECT DISTINCT category 
FROM retail_sales;
 
 
-- Data Analysis & Business Key Problems and answer

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing'
    AND
    quantity >= 4
    AND 
    sale_date LIKE '2022-11%';
    
-- Another option
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing'
    AND
    quantity >= 4
    AND 
    sale_date BETWEEN '2022-11-01' AND '2022-11-30';
    
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, 
		SUM(total_sale) AS net_sales,
        COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT category, ROUND(AVG(age),2) AS avg_age
FROM retail_sales
GROUP BY category
HAVING category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, gender, COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1,2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT `year`, `month`, avg_sales
FROM
(
SELECT 
	YEAR(sale_date) AS year, 
	month(sale_date) AS month, 
	ROUND(AVG(total_sale),2) AS avg_sales,
	RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS `rank`
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE `rank` = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id, SUM(total_sale) AS highest_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT customer_id) AS cnt_unique_customers
FROM retail_sales
GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning < 12, Afternoon Between 12 & 17, Evening >17)

SELECT
CASE
 WHEN DATE_FORMAT(sale_time, '%H') < 12 THEN 'Morning'
 WHEN DATE_FORMAT(sale_time, '%H') BETWEEN 12 AND 17 THEN 'Afternoon'
 WHEN DATE_FORMAT(sale_time, '%H') > 17 THEN 'Evening'
END AS shifts,
COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY 1
ORDER BY 1;

-- With CTE format

WITH hourly_sales
AS 
(
SELECT
CASE
 WHEN DATE_FORMAT(sale_time, '%H') < 12 THEN 'Morning'
 WHEN DATE_FORMAT(sale_time, '%H') BETWEEN 12 AND 17 THEN 'Afternoon'
 WHEN DATE_FORMAT(sale_time, '%H') > 17 THEN 'Evening'
END AS shifts
FROM retail_sales
)
SELECT 
	shifts, 
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shifts;

-- End of Project