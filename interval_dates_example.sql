select name, price from 
(select name , price, dense_rank() over (order by price desc) as rnk from customers c left join orders o on c.order_id = o.id
where order_date  <= (select min(order_date) + INTERVAL '10' YEAR  from orders)
)
where rnk = 1;
