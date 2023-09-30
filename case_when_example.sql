with stock as (
  select stock_name, case when operation = 'Buy' then -1 * price else price end price
  from stocks
) select stock_name, sum(price) capital_gain_loss 
from stock
group by stock_name;
