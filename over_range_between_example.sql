with visits as (
  select visited_on, sum(amount) amount from Customer 
  group by visited_on
  order by visited_on asc
), final as (
  select visited_on,
  sum(amount) over (order by visited_on RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND INTERVAL '0' DAY FOLLOWING ) amount
  from visits
) select to_char(visited_on, 'YYYY-MM-DD') visited_on, amount, round(amount / 7, 2) average_amount from final where visited_on >= (select min(visited_on) from final) + interval '6' day;
