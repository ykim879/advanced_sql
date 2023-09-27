/* Write your PL/SQL query statement below */
with orders as (select delivery_id, order_date, customer_pref_delivery_date, dense_rank() over (partition by customer_id order by order_date asc) rnk from delivery), first_orders as (select * from orders where rnk = 1 )
select round(sum(case when order_date = customer_pref_delivery_date then 1 else 0 end) / count(*) * 100, 2)immediate_percentage
 from first_orders;
