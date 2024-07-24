-- Write your PostgreSQL query statement below
select sell_date, count(distinct product) num_sold, string_agg(distinct product, ',') products
from activities group by sell_date order by sell_date;
