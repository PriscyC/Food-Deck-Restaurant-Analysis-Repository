--- Walmart Sales Data Analysis ---

--- Create Database ---
create database if not exists WalmartSales;

--- Create table ---
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

--- -------------------------------------Data Transformation---------------------------------------
select * from sales;
--- Add the time_of_day column---
SELECT time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

--- Convert 'Date' to DATE format
--- Creating a new column Time of Day---
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

--- Inserting data into the column created---
UPDATE sales
SET time_of_day = (
CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);

--- Add day_name column---
SELECT date,
 DAYNAME(date)
from sales;

--- Creating a new column Day Name---
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

--- Inserting data into the column created---
UPDATE sales
SET day_name = DAYNAME(date);

--- Add month_name column
SELECT date,
	MONTHNAME(date)
FROM sales;

--- Creating a new column Month Name---
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

--- Inserting data into the column created---
UPDATE sales
SET month_name = MONTHNAME(date);

use walmartsales;
--- Convert 'Total' to DECIMAL format (to ensure financial precision)
ALTER TABLE sales 
MODIFY COLUMN `Total` DECIMAL(10, 2);

--- Optional: Remove unnecessary columns
select * from sales;
ALTER TABLE sales 
DROP COLUMN `gross_margin_pct`;

--- Remove Duplicates---
DELETE FROM sales
WHERE Invoice_ID IN (
  SELECT Invoice_ID 
  FROM (SELECT Invoice_ID, COUNT(*) 
        FROM sales 
        GROUP BY Invoice_ID 
        HAVING COUNT(*) > 1) AS duplicates
);
-- ---------------------------- Generic ------------------------------
--- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

--- Total Sales by City ------
SELECT City, SUM(Total) AS Total_Sales
FROM sales
GROUP BY City
ORDER BY Total_Sales DESC;

--- In which city is each branch? ---
SELECT DISTINCT city, branch
FROM sales;

-- ---------------------------- Product Line Performance -------------------------------
--- which product lines generate the highest revenue.
SELECT `Product_line`, SUM(Total) AS Total_Sales
FROM sales
GROUP BY `Product_line`
ORDER BY Total_Sales DESC;
 
 --- How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM sales;

--- What is the most selling product line--
SELECT product_line, COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

--- Count the number of transactions for each payment method to see which one is most popular.
SELECT Payment, COUNT(*) AS Number_of_Transactions
FROM sales
GROUP BY Payment
ORDER BY Number_of_Transactions DESC;

--- Calculate the average spending per transaction by gender
SELECT Gender, AVG(Total) AS Average_Spending
FROM sales
GROUP BY Gender
ORDER BY Average_Spending DESC;

--- What is the total revenue by month
SELECT month_name AS month,
	ROUND(SUM(total)) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue DESC;

--- What month had the largest COGS (Cost of Goods)? ---
SELECT month_name AS month,
	SUM(cogs) AS largest_cogs
FROM sales
GROUP BY month_name
ORDER BY largest_cogs DESC;

--- What product line had the largest revenue?
SELECT  product_line, ROUND(SUM(total)) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

--- What is the city with the largest revenue? ---
SELECT branch, city, ROUND(SUM(total)) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue DESC;

--- What product line had the largest VAT (Value Added Tax)? ---
SELECT product_line, AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

--- Fetch each product line and add a column to those product 
--- line showing "Good", "Bad". Good if its greater than average sales ---
SELECT AVG(quantity) AS avg_qnty
FROM sales;

SELECT product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

--- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

--- What is the most common product line by gender
SELECT gender, product_line, COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

--- What is the average rating of each product line
SELECT ROUND(AVG(rating), 2) as avg_rating, product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- -------------------------- Customers -------------------------------
--- How many unique customer types does the data have?---
SELECT DISTINCT customer_type
FROM sales;

--- How many unique payment methods does the data have? ---
SELECT DISTINCT payment
FROM sales;

--- What is the most common customer type?--
SELECT customer_type, count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

--- Which customer type buys the most?---
SELECT customer_type, COUNT(*)
FROM sales
GROUP BY customer_type;

--- What is the gender of most of the customers? ---
SELECT gender, COUNT(*) as gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

--- What is the gender distribution per branch?---
SELECT gender, COUNT(*) as gender_count
FROM sales
WHERE branch = "B"
GROUP BY gender
ORDER BY gender_count DESC;

-- Gender per branch is more or less the same hence, I don't think it has
-- an effect of the sales per branch and other factors.

--- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

--- The time of the day does not really affect the rating and the quality of service rendered.---
--- It is more or less the same rating each time of the day.

--- Which time of the day do customers give most ratings per branch?---
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
--- Branch A and C are doing well in ratings, branch B needs to do a 
--- little more to get better ratings.

--- Which day fo the week has the best avg ratings?---
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings,While wednesday has the leasr Avg rating.

-- Which day of the week has the best average ratings per branch?
SELECT day_name, COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- ---------------------------- Sales ---------------------------------
-- Number of sales made in each time of the day per weekday 
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
--- Evenings experience most sales, as the stores are filled during the evening hours---

--- Which of the customer types brings the most revenue?
SELECT customer_type, ROUND(SUM(total)) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

--- Top Cities by Average Customer Rating ---
SELECT City, AVG(Rating) AS Average_Rating
FROM sales
GROUP BY City
ORDER BY Average_Rating DESC;

--- Which city has the largest tax/VAT percent?
SELECT city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type,ROUND(AVG(tax_pct)) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

--- ----------------------------------- Conclusion ---------------------------------------
--- The analysis of Walmart’s sales data cut across three cities—Yangon, Naypyitaw, and Mandalay—has 
--- provided valuable insights into customer preferences, regional sales performance, and spending behaviors.
--- Key findings show that Naypyitaw is the strongest performer in terms of sales,  while product 
--- lines like "Food and Beverages" and "Sports and Travel" lead revenue generation. 
--- The data also revealed a strong preference for digital payment methods, with Ewallet being the 
--- most commonly used, and highlighted that female customers tend to spend more per transaction---
