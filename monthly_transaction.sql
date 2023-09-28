/* Write your PL/SQL query statement below */
with trans as (select id, country, to_char(trans_date, 'YYYY-MM') month, 
case when state = 'approved' then 1 else 0 end state,
amount,  case when state = 'approved' then amount else 0 end approved_total_amount
from Transactions)
select month, country, count(id) trans_count, sum(state) approved_count,
sum(amount) trans_total_amount, sum(approved_total_amount) approved_total_amount
from trans
group by country, month;
