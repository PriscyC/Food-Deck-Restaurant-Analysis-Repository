--- These SQL queries analyze a taxi service dataset to provide insights for optimizing operations and driving revenue growth.
--- These insights help identify high-performing areas, times, drivers, and conditions, aiding in service optimization and revenue maximization.--- 

select * from taxi_organization_data;
--- Total Revenue by Location *\
SELECT location, ROUND(SUM(total_amount)) AS total_revenue
from taxi_organization_data
GROUP BY location
ORDER BY total_revenue DESC;
--- This query helps identify which location (Uptown, Midtown,Suburbs, etc.) generates the most revenue.

--- Revenue by Day of the Week
SELECT day_of_week, ROUND(SUM(total_amount)) AS total_revenue
FROM taxi_organization_data
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 
'Saturday', 'Sunday');
--- This query returns the total revenue for each day of the week, sorted in order

--- Most Common Payment type
SELECT payment_type, COUNT(*) AS type_count
FROM taxi_organization_data
GROUP BY payment_type
ORDER BY type_count DESC;

--- Top Drivers by Revenue
 SELECT driver_id, ROUND(SUM(total_amount)) as total_revenue
 FROM taxi_organization_data
 GROUP BY driver_id
 ORDER BY total_revenue DESC
 LIMIT 10;
 --- This query shows the top 10 drivers who generate the most revenue.

---  Revenue by Weather Condition
SELECT weather, ROUND(SUM(total_amount)) as total_revenue
FROM taxi_organization_data
GROUP BY weather
ORDER BY total_revenue DESC;
 --- This query helps to identify which weather conditions (Cloudy, Snow, Clear, etc.) are most profitable.

--- Average Trip Distance and Revenue by Location
SELECT location, AVG(trip_distance) AS avg_distance, AVG(total_amount) AS avg_revenue
FROM taxi_organization_data
GROUP BY location
ORDER BY avg_revenue DESC;
--- This query helps explore the average trip distance and revenue by location.

--- Surge Pricing Effect on Revenue
SELECT surge_pricing, ROUND(SUM(total_amount)) AS total_revenue
FROM taxi_organization_data
GROUP BY surge_pricing;
--- This query help understand the impact of surge pricing on revenue.

---  Customer Trip Frequency
SELECT customer_id, COUNT(*) AS trip_count
FROM taxi_organization_data
GROUP BY customer_id
ORDER BY trip_count DESC
LIMIT 10;
--- This query returns the top 10 customers by the number of trips they took.

--- Calculate revenue generated per trip
SELECT COUNT(*) AS total_trips, SUM(total_amount) AS total_revenue,
    SUM(total_amount) / COUNT(*) AS revenue_per_trip
FROM taxi_organization_data;
--- This query returns the total revenue generated per trip.

--- Revenue Growth Over Time: Analyze revenue growth trends over time (daily, weekly, or monthly).
SELECT MONTHNAME(pickup_datetime) AS month, ROUND(SUM(total_amount)) AS total_revenue
FROM taxi_organization_data
GROUP BY month
ORDER BY month DESC;
--- This query returns the total revenue generated for each month.

--- Most frequented pickup and drop-off locations by traffic.
SELECT location,traffic, COUNT(*) AS pickup_count_dropoff_count
FROM taxi_organization_data
GROUP BY location, traffic
ORDER BY pickup_count_dropoff_count DESC
limit 10;

--- Analyze the number of trips made at different hours to find peak times.
SELECT EXTRACT(HOUR FROM pickup_datetime) AS trip_hour,COUNT(*) AS trip_count
FROM taxi_organization_data
GROUP BY trip_hour
ORDER BY trip_hour DESC
limit 10;

--- Revenue Distribution by Latitude and Longitude
SELECT ROUND(pickup_latitude, 2) AS latitude, ROUND(dropoff_longitude, 2) AS longitude, 
ROUND(SUM(total_amount)) AS total_revenue
FROM  taxi_organization_data
GROUP BY ROUND(pickup_latitude, 2), ROUND(dropoff_longitude, 2)
ORDER BY total_revenue DESC
LIMIT 10;
--- This query returns latitude and longitude data to analyze routes taken by drivers and identify opportunities for optimization.

