use pizza_analysis;
select * from pizza_sales;
describe pizza_sales;
-- chage the data types text to date 
SET sql_safe_updates=0;
UPDATE pizza_sales
 SET order_date = CASE
	WHEN order_date LIKE '%/%'THEN date_format(str_to_date(order_date,'%m/%d/%Y'),'%Y-%m-%d')
	WHEN order_date LIKE  '%-%'THEN date_format(str_to_date(order_date,'%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;
alter table pizza_sales 
modify column order_date DATE;
select order_date from pizza_sales;
-- Total revanue
select round(sum(total_price),2) as total_revanue from pizza_sales;

-- Average order value 
select count(distinct order_id) from pizza_sales;
select round(sum(total_price)/count(distinct order_id),2) as avg_order_value from pizza_sales;

-- Total pizza sold
select sum(quantity) as Total_pizza_sale from pizza_sales;

-- Total order placed
select count(distinct order_id) as total_order_placed from pizza_sales;

-- average Pizza per order
select cast(cast(sum(quantity) as decimal(10,2)) /
cast( count(distinct order_id)as decimal(10,2))as decimal(10,2)) as average_pizza from pizza_sales ;

-- Daily Trend for total order:

select date_format(order_date,'%W') as order_days,count(distinct order_id) as total_order from pizza_sales
group by date_format(order_date,'%W');

-- monthly trend for total order

select date_format(order_date,'%M') as order_month,count(distinct order_id) as total_order from pizza_sales
group by date_format(order_date,'%M')
order by total_order desc;

-- percentage of sale by pizza catagory
select pizza_category,sum(total_price),round(sum(total_price)*100/ 
(select sum(total_price) from pizza_sales
 where month(order_date) =1 ),2)as per_of_sale 
from pizza_sales
where month(order_date) =1 
group by pizza_category ;

-- Percentage of Sales by Pizza size
select pizza_size ,sum(total_price),sum(total_price)*100/
(select sum(total_price) from pizza_sales) as perc_sales 
from pizza_sales
group by pizza_size
order by perc_sales desc ;
select * from pizza_sales;

-- Total pizza sold by pizza catagory
SELECT 
    pizza_name, SUM(total_price) AS total_revanue
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY total_revanue DESC
LIMIT 5;

-- top 5 worst pizza 
select  pizza_name ,sum(total_price)as total_revanue 
from pizza_sales
group by pizza_name
order by total_revanue asc limit 5 ;

-- top 5  quantity of Pizza sold 

select  pizza_name ,sum(quantity)as total_quantity 
from pizza_sales
group by pizza_name
order by total_quantity desc limit 5 ;

 -- total order pizza sold 
 select  pizza_name ,count(distinct order_id)as  total_order 
from pizza_sales
group by pizza_name
order by total_order desc limit 5  ;