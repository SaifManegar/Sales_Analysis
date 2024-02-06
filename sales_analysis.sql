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

select * from transactions
where market_code="Mark001";

select * from transactions
where currency="USD";

select a.*,b.* from transactions as a
inner join date as b
on a.order_date=b.date
where b.year=2020 and a.market_code="Mark001"; 

select sum(sales_amount) from transactions as a
inner join date as b
on a.order_date=b.date
where b.year=2020 and a.market_code="Mark001";   

select distinct(product_code), count(product_code) from transactions as a
inner join date as b on a.order_date=b.date 
where b.year=2020 and a.market_code="Mark001"
group by product_code; 

select distinct(a.product_code), c.product_type, count(a.product_code) from transactions as a
inner join date as b on a.order_date=b.date 
inner join products as c on a.product_code = c.product_code
where b.year=2020 and a.market_code="Mark001"
group by a.product_code, c.product_type;

select * from transactions
order by profit_margin_percentage;     