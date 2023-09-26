with orders as (
  select product_id, new_price, dense_rank() over (partition by product_id order by change_date desc) as rnk 
  from products
  where change_date <= date '2019-08-16'
), orders_f as (
  select product_id, new_price from orders
  where rnk = 1
) select p1.product_id, nvl(p.new_price, 10) price from (select distinct product_id from Products) p1 
  left outer join orders_f p
  on p1.product_id = p.product_id;

/*
Products:
| product_id | new_price | change_date |
| ---------- | --------- | ----------- |
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |

result:
| PRODUCT_ID | PRICE |
| ---------- | ----- |
| 1          | 35    |
| 2          | 50    |
| 3          | 10    |
*/
