with manager as (
    select managerId from Employee 
    group by managerId having count(*) >= 5 )
select name from employee inner join manager on manager.managerId = employee.id;
