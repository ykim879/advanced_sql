with categories as (
  select income
  from accounts
)  select  'Low Salary' as category ,count(*) accounts_count from categories
     where income <20000
     union
   select 'Average Salary' as category ,count(*) accounts_count from categories
     where income >=20000 and income <=50000
     union
  select 'High Salary' as category ,count(*) accounts_count from categories
     where income >50000;
