with maxSeat as (
  select max(id) id from seat
), seats as (
  select case when mod(id, 2) = 0 then id - 1
    when id = (select id from maxSeat) then id
    else id + 1 end id, student from seat
) select * from seats order by id;
