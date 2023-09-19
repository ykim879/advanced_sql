/* Write your PL/SQL query statement below */
select sum(tiv_2016) as tiv_2016 from (
    select tiv_2016 from Insurance i1 where 
    (select count(*) from Insurance i2 where i2.tiv_2015 = i1.tiv_2015) >= 2
    and
    (select count(*) from Insurance i2 where i2.lat = i1.lat and i2.lon = i1.lon) = 1
);
