use sales;

select * from customers;
select * from date;
select * from markets;
select * from products;
select * from transactions;

#counting the rows
select count(*) from customers;
select count(*) from date;
select count(*) from markets;
select count(*) from products;
select count(*) from transactions;

#bangalore's market transaction data
select * from transactions
where market_code="Mark006";

#chennai's transaction data
select * from transactions
where market_code="Mark001";

#rows with USD transaction
select * from transactions
where currency="USD";

#total sales
select sum(sales_amount) as total_sales_amount 
from transactions;

#total sales, it cost price and margin
select  sum(sales_amount) as total_sales_amount, sum(cost_price) as total_cost_price, sum(profit_margin) as total_profit_margin
from transactions;

#total sales, it cost price and margin across different markets
select markets_name, sum(sales_amount) as total_sales_amount, sum(cost_price) as total_cost_price, sum(profit_margin) as total_profit_margin
from transactions as a
inner join markets as b
on a.market_code=b.markets_code
group by markets_name;

#different products present
select a.product_code, b.product_name
from transactions as a 
inner join products as b
on a.product_code=b.product_code
group by a.product_code;

#different products margin percentage
select b.product_name, a.profit_margin_percentage from transactions as a
join products as b
on a.product_code=b.product_code
order by profit_margin_percentage desc;

#top 10 customer in terms of customer
select a.customer_code, a.customers_name, sum(b.sales_amount) as total_sales
from transactions as a
inner join customers as b
on a.customer_code=b.customer_code
group by a.customer
order by b.sales_amount desc
limit 10;

#top 10 products in terms of profit
select a.product_code, b.product_name, sum(profit_margin) as top_10_profit
from transactions as a 
inner join products as b
on a.product_code=b.product_code
group by a.product_code
order by top_10_profit desc
limit 10;

#Most profit generating product
select a.product_code, b.product_name, sum(profit_margin) as no_1_product
from transactions as a 
inner join products as b
on a.product_code=b.product_code
group by a.product_code
order by no_1_product desc
limit 1;

#top 3 most expensive products
select a.product_code, b.product_name, max(sales_amount) as most_expensive_products
from transactions as a 
inner join products as b
on a.product_code=b.product_code
group by a.product_code
order by most_expensive_products desc
limit 3;

#top sales done in the year 2020 in bhopal's market
select sum(sales_amount) from transactions as a
inner join date as b
on a.order_date=b.date
where b.year=2020 and a.market_code="Mark007"; 

#Fetching all the data of 2020 of Mark001's market
select a.*,b.* from transactions as a
inner join date as b
on a.order_date=b.date
where b.year=2020 and a.market_code="Mark001"; 

#sales done in the year 2020 in different market
select c.markets_name, sum(sales_amount) from transactions as a
inner join date as b on a.order_date=b.date
inner join markets as c on a.market_code=c.markets_code
where b.year=2020
group by c.markets_name
order by c.markets_name desc;

#fetching all the data of product kitkat of chennai's market
select a.*,b.*,c.* from transactions as a
inner join products as b
inner join markets as c
on a.product_code=b.product_code and
a.market_code=c.markets_code
where b.product_name="kitkat" and c.markets_name="Chennai";

#total sales quantity and sales amount for each product
select b.product_name as prod_name, sum(sales_qty) as total_sales_amt, sum(sales_amount) as total_sales_amt
from transactions as a
inner join products as b
on a.product_code = b.product_code
group by prod_name;

#total transaction made on different products in the year 2019
select distinct(a.product_code), c.product_name, count(a.product_code) as total_transaction from transactions as a
inner join date as b on a.order_date=b.date 
inner join products as c on a.product_code=c.product_code
where b.year=2019 
group by product_code
order by total_transaction desc; 

#total transaction made from different markets on products type in the year 2020
select distinct(c.product_type), d.markets_name, count(a.product_code) as total_transaction from transactions as a
inner join date as b on a.order_date=b.date 
inner join products as c on a.product_code = c.product_code
inner join markets as d on a.market_code=d.markets_code
where b.year=2020 
group by c.product_type, d.markets_name
order by d.markets_name;