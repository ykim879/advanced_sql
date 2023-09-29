/* Write your PL/SQL query statement below */
with persons as (
  select q1.person_id, q1.person_name, q1.weight, q1.turn, q2.weight smaller_weight
  from Queue q1 left outer join queue q2 on q1.turn >= q2.turn
), total as (
  select person_id, person_name, turn, sum(smaller_weight) total_weight 
  from persons group by person_id, person_name, turn
) select person_name from total where turn = (select max(turn) from total where total_weight <= 1000);
