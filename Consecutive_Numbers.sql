/* Write your PL/SQL query statement below */
select distinct num ConsecutiveNums from Logs l
where (select count(*) from Logs l2 where l2.id between l.id and l.id + 2 and l.num = l2.num) = 3 or
(select count(*) from Logs l2 where l2.id between l.id - 1 and l.id + 1 and l.num = l2.num) = 3 or
(select count(*) from Logs l2 where l2.id between l.id - 2 and l.id and l.num = l2.num) = 3;
