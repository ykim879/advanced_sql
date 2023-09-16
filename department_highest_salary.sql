/* Write your PL/SQL query statement below */
with max_salary_table as (select departmentId, max(salary) as max_salary from Employee group by departmentId),
employee_with_max_salary as (select name as employee, salary, e.departmentId from employee e
    inner join max_salary_table m on e.departmentId = m.departmentId and e.salary = m.max_salary)
    select d.name as department, employee, salary
    from employee_with_max_salary e left outer join department d on e.departmentId = d.id;
-- beats 100% memory and runtime
