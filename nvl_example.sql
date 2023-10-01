with confirmed as (
  select user_id, sum(case when action = 'confirmed' then 1 else 0 end) confirmed, 
  count(*) total
  from Confirmations group by user_id
) select u.user_id, nvl(round(confirmed/total, 2), 0) confirmation_rate
  from signups u left outer join confirmed cr on u.user_id = cr.user_id;
