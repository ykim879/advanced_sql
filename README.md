# Oracle SQL Documentation
**order**: select -> from -> join -> on -> where -> group by -> order by
## LISTAGG: Create the list column from specific grouping ordered
ListAGG applies on single-set aggregation and group-set aggregation.
### Single-Set
if it is listAgg wihtout groupby operation, it outputs single row aggregating all rows. Example below:

<html>
  <head>
    SELECT LISTAGG(last_name, '; ')
         WITHIN GROUP (ORDER BY hire_date, last_name) "Emp_list",
       MIN(hire_date) "Earliest"
    FROM employees
    WHERE department_id = 30;
  </head>

Emp_list                                                     Earliest
------------------------------------------------------------ ---------
Raphaely; Khoo; Tobias; Baida; Himuro; Colmenares            07-DEC-02
</html>

### Group-set
If the operationg follows by groupby operation, it returns an output row for each group defined by the GROUP BY clause. Example blow: 

<html>
  SELECT department_id "Dept.",
       LISTAGG(last_name, '; ') WITHIN GROUP (ORDER BY hire_date) "Employees"
  FROM employees
  GROUP BY department_id
  ORDER BY department_id;

Dept. Employees
------ ------------------------------------------------------------
    10 Whalen
    20 Hartstein; Fay
    30 Raphaely; Khoo; Tobias; Baida; Himuro; Colmenares
    40 Mavris
    50 Kaufling; Ladwig; Rajs; Sarchand; Bell; Mallin; Weiss; Davie
       s; Marlow; Bull; Everett; Fripp; Chung; Nayer; Dilly; Bissot
       ; Vollman; Stiles; Atkinson; Taylor; Seo; Fleaur; Matos; Pat
       el; Walsh; Feeney; Dellinger; McCain; Vargas; Gates; Rogers;
        Mikkilineni; Landry; Cabrio; Jones; Olson; OConnell; Sulliv
       an; Mourgos; Gee; Perkins; Grant; Geoni; Philtanker; Markle
    60 Austin; Hunold; Pataballa; Lorentz; Ernst
    70 Baer
</html>

reference: https://docs.oracle.com/cd/E11882_01/server.112/e41084/functions089.htm#SQLRF30030

---
### row_number() function

![image](https://github.com/ykim879/advanced_sql/assets/59812671/05690fa2-e286-49dc-88b6-0a03a65eeda2)

It assigns a unique number to each row to which it is applied (either each row in the partition or each row returned by the query), in the ordered sequence of rows specified in the order_by_clause.
#### Use case
It cames useful when you want to partition group with unique value of column. Such as:
1) When you want salary ranks of employees has in each department
2) If you want to select top N salary (but if there are duplicates it will still pick one from them) from employes per each department.
#### Example
##### Table
Employee table:
| id | name  | salary | departmentId |
| -- | ----- | ------ | ------------ |
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
##### Query
```sql
select o.*,
       row_number () over (
         partition by departmentId
         order by salary desc
       ) rn
from  Employee o;
```
##### Result
| ID | NAME  | SALARY | DEPARTMENTID | RN |
| -- | ----- | ------ | ------------ | -- |
| 4  | Max   | 90000  | 1            | 1  |
| 6  | Randy | 85000  | 1            | 2  |
| 1  | Joe   | 85000  | 1            | 3  |
| 7  | Will  | 70000  | 1            | 4  |
| 5  | Janet | 69000  | 1            | 5  |
| 2  | Henry | 80000  | 2            | 1  |
| 3  | Sam   | 60000  | 2            | 2  |

## Round function

![image](https://github.com/ykim879/advanced_sql/assets/59812671/22fb7af0-4003-428f-b0fb-1abde824bf4d)

ROUND(number , rounded decimal)
- positve will have n numbars of decimal after the '.'
- negaivive will have n numbers of decimal before the '.'

## to_char: Format date
### Example 
```sql
to_char(date, format)
```
### format option examples
1) YYYY-MM-DD
2) DD/MM/YYYY
3) Month DD, YYYY

## dense_rank()
DENSE_RANK computes the rank of a row in an ordered group of rows and returns the rank as a NUMBER.
### with aggregation
![image](https://github.com/ykim879/advanced_sql/assets/59812671/764aaeaa-d86e-4369-8a6d-1a5cfb9b3b75)
### without aggregation
![image](https://github.com/ykim879/advanced_sql/assets/59812671/587c8a18-49bb-4ca3-8de3-0d57bf892173)
``` sql
SELECT
  SALARY, 
  DENSE_RANK() OVER (ORDER BY SALARY DESC) AS RNK
  FROM
  EMPLOYEE
```
(example code is in the repos)
## ADD DATES
syntax: original date + INTERVAL 'number value to add' unit
``` sql
select order_date + INTERVAL '-10' YEAR  from orders;
```
### unit
1. year
2. month
3. day
4. hour
5. minute
6. second
## CREATE FUNCTION

