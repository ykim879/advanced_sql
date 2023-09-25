/* Write your PL/SQL query statement below */
with orders19 as (
  select order_id, buyer_id from Orders where to_char(order_date) like '2019%'
) select user_id buyer_id, to_char(join_date, 'YYYY-MM-DD') join_date, count(order_id) orders_in_2019
from Users left outer join orders19 on buyer_id = user_id
group by user_id, join_date;
