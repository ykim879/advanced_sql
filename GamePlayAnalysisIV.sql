/* Write your PL/SQL query statement below */
with consecutive as (
    select '1' as id, count(*) as child from Activity a
    where a.event_date =  (
        select min(event_date) + Interval '1' day from Activity a2 where a2.player_id = a.player_id
        )
), total_players as (
    select '1' as id, count(*) as parent from (select distinct player_id from activity))
select round(child / parent, 2) as fraction from consecutive c inner join total_players t on c.id = t.id;
