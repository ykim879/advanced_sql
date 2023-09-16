/* Write your PL/SQL query statement below */
with more_than_100 as (
    select * from Stadium where people >= 100
) select id, to_char(visit_date, 'YYYY-MM-DD') visit_date, people from more_than_100 s where (
    select count(*) from more_than_100 s2 where s2.id between s.id and s.id + 2
) >= 3 or (select count(*) from more_than_100 s2 where s2.id between s.id -2 and s.id) >= 3
or (select count(*) from more_than_100 s2 where s2.id between s.id - 1 and s.id + 1) >= 3;
-- beats 100%
