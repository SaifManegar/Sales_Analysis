use sales;

select * from customers;
select * from date;
select * from markets;
select * from products;
select * from transactions;

select b.product_name, sum(a.sales_qty) as total_sales_quantity, sum(a.sales_amount) as total_sales_amount
from transactions as a 
inner join products as b
on a.product_code=b.product_code
group by b.product_name;

-- What is the total sales revenue for each customer?
select b.customer_code, sum(a.sales_amount) as total_sales_amount
from transactions as a
inner join customers as b
on a.customer_code=b.customer_code
group by b.customer_code
order by total_sales_amount desc;

-- What is the total sales revenue for each market?
select row_number() over (order by sum(a.sales_amount) asc) as row_num, b.markets_code, b.markets_name, sum(a.sales_amount) as total_sales_amount
from transactions as a
inner join markets as b
on a.market_code=b.markets_code
group by b.markets_code
order by total_sales_amount;

-- How many unique customers are there in the database?
select count(distinct(customer_code)) as total_unique_customer from customers;

-- What is the distribution of customers by customer type?
select distinct(customer_type), count(customer_code) from customers
group by customer_type;

-- Who are the top 10 customers in terms of sales revenue?
select a.customer_code, a.customers_name, sum(b.sales_amount) as total_sales
from transactions as a
inner join customers as b
on a.customer_code=b.customer_code
group by a.customer
order by b.sales_amount desc
limit 10;

-- How many markets are represented in the database?
select count(distinct(markets_code)) as total_markets from markets;

-- What is the distribution of markets by zone?
select distinct(zone), count(markets_code) total_market_present_in_zone from markets
group by zone;

-- what is the sales revenue for different markets?
select b.markets_name, round(sum(profit_margin),1) as sales_revenue 
from transactions as a
inner join markets as b
on a.market_code=b.markets_code
group by b.markets_name
order by sales_revenue desc;

-- Which market generates the highest sales revenue?
select b.markets_name, round(sum(profit_margin),1) as highest_sales_revenue 
from transactions as a
inner join markets as b
on a.market_code=b.markets_code
group by b.markets_name
order by sales_revenue desc
limit 1;

-- How many unique products are there in the database?
select count(distinct(product_name)) from products;

-- What is the distribution of products by product type?
select product_type, count(product_code) as number_of_products from products
group by product_type;

-- Which product generates the highest sales revenue?
select b.product_name, round(sum(a.profit_margin),1) as highest_sales_revenue, b.product_type
from transactions as a
inner join products as b
on a.product_code=b.product_code
group by b.product_name
order by highest_sales_revenue desc
limit 1;

-- What is the trend in sales quantity and sales amount over time
select order_date, sum(sales_qty) as total_sales_quantity, sum(sales_amount) as total_sales_amount
from transactions
group by order_date
order by order_date;

-- Are there any seasonal patterns in sales?
select month(order_date) as months, sum(sales_qty) as total_sales_quantity, sum(sales_amount) as total_sales_amount
from transactions
group by months
order by months;

select * from customers;
select * from date;
select * from markets;
select * from products;
select * from transactions;

-- How many different currencies are used in transactions?
select distinct(currency) from transactions;

-- What is the total sales revenue when transactions are converted to a common currency (e.g., USD)?
select distinct(currency) as currency, sum(profit_margin) as sales_revenue
from transactions
group by currency;

-- Are there any significant differences in sales amounts when transactions are converted to a common currency?
select distinct(currency),
       SUM(CASE WHEN currency = 'USD' THEN sales_amount
                WHEN currency = 'INR' THEN sales_amount * 0.012
                ELSE sales_amount END) AS total_sales_amt
from transactions
group by currency;

-- Can you segment customers based on their purchasing behavior (e.g., high-value customers, frequent buyers)?
select customer_code, sum(sales_amount) as total_sales_amount, 
case 
when sum(sales_amount) >= 5000000 THEN 'High Value' 
when sum(sales_amount) >= 3000000 THEN 'Medium Value'
else 'Low Value'
end as customer_segment
from transactions
group by customer_code;

-- How does sales performance differ across different markets and zones?
select b.markets_name, sum(a.sales_amount)
from transactions as a
join markets as b
on a.market_code = b.markets_code
group by b.markets_name;

select b.zone, sum(a.sales_amount)
from transactions as a
join markets as b
on a.market_code = b.markets_code
group by b.zone;

-- Can you identify any underperforming markets that may need attention or improvement?
select b.markets_name, sum(a.sales_amount) as total_sales,
case
when sum(a.sales_amount) > (select avg(sales_amount) from transactions) 
then 'Outperform'
else 'Need Improvement'
end as performance
from transactions as a
join markets as b
on a.market_code = b.markets_code
group by b.markets_name
order by total_sales asc;

-- How does sales performance vary across different product types?
select sum(a.sales_amount), b.product_type 
from transactions as a
join products as b 
on a.product_code=b.product_code
group by b.product_type;

-- Are there any products that consistently outperform or underperform compared to others?
select b.product_name, avg(a.sales_amount) as avg_sales_amount,
case
when sum(a.sales_amount) > (select avg(sales_amount) from transactions) 
then 'Outperform'
else 'Underperform'
end as performance
from transactions as a
join products as b
on a.product_code = b.product_code
group by b.product_name;

-- What is the average profit margin percentage for each product type?
select b.product_type, round(avg(a.profit_margin_percentage),2) as avg_profit_margin_percentage
from transactions as a 
inner join products as b
on a.product_code=b.product_code
group by b.product_type;

-- Which product types are the most profitable?
select b.product_type, round(avg(a.profit_margin)) as avg_profit
from transactions as a 
inner join products as b
on a.product_code=b.product_code
group by b.product_type
order by b.product_type desc
limit 1;

-- What is the retention rate of customers over time?
with retained_customers as (
    select distinct customer_code
    from transactions
    where date(order_date) between '2019-01-01' and '2020-06-30' 
),
previous_period_customers as (
    select distinct customer_code
    from transactions
    where date(order_date) between '2017-06-01' and '2018-12-31' 
)
select count(rc.customer_code) as retained_customers, count(pc.customer_code) as previous_period_customers,
round(count(rc.customer_code) / count(pc.customer_code) * 100) as retention_percentage
from retained_customers as rc
join previous_period_customers as pc 
on rc.customer_code = pc.customer_code;

-- Can you identify any factors that influence customer retention or churn?
select b.product_name, avg(a.sales_amount) as avg_sales_amount, count(distinct customer_code) as num_customers,
case 
when avg(sales_amount) > (select avg(sales_amount) from transactions) 
then 'high_revenue'
else 'low_revenue'
end as revenue_category,
case when count(distinct customer_code) > (select count(distinct customer_code))
then 'active_customers'
else 'inactive_customers'
end as customer_activity
from transactions as a
inner join products as b
on a.product_code=b.product_code
inner join date as c
on a.order_date=c.date
group by b.product_name;

-- How sensitive are sales quantities to changes in sales prices
select avg(sales_qty) as avg_sales_quantity, avg(sales_amount) as avg_sales_price,
(sum((sales_qty - avg_sales_qty) * (sales_amount - avg_sales_amount)) / 
(sqrt(sum(power(sales_qty - avg_sales_qty, 2))) * sqrt(sum(power(sales_amount - avg_sales_amount, 2))))) as correlation
from transactions,
(select avg(sales_qty) as avg_sales_qty, avg(sales_amount) as avg_sales_amount from transactions) as subquery;

-- Can you identify any price points that maximize sales revenue?
select sales_amount as sales_amt, sum(sales_amount) as total_revenue
from transactions
group by sales_amount
order by total_revenue desc
limit 10; 

-- Are there any factors (e.g., seasonality, market trends) that may impact future sales performance?
select extract(month from order_date) as sales_month, avg(sales_amount) as avg_sales_amount from transactions
group by sales_month
order by sales_month;

-- What is the total cost price for each product?
select b.product_name as product_name, sum(a.cost_price) 
from transactions as a
inner join products as b
using(product_code)
group by b.product_name
order by b.product_name desc;

-- How does the cost price compare to the sales amount and profit margin for each product?
select b.product_name as product_name, round(sum(a.cost_price)) as cost_price, 
round(sum(a.profit_margin)) as profit_margin, round(sum(a.sales_amount)) as sales_amt
from transactions as a
inner join products as b
using(product_code)
group by b.product_name
order by sales_amt asc;

-- What is the total sales quantity and sales amount in each market?
select c.markets_name as market,  sum(a.sales_qty) as total_sales_amt, sum(a.sales_amount) as total_sales_amt
from transactions as a
inner join markets as c
on a.market_code = c.markets_code
group by market
order by sum(a.sales_amount) desc;