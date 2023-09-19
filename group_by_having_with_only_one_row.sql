/* Write your PL/SQL query statement below */
select * from (select id, sum(c) as num from (
        (select requester_id id, count(*) as c from RequestAccepted group by requester_id)
        union all
        (select accepter_id id, count(*) as c from RequestAccepted group by accepter_id)
    )
    group by id
    order by num desc)
    where rownum = 1;
