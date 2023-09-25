# Oracle SQL Documentation
**order**: select -> from -> join -> on -> where -> group by -> order by
## Pseudo Columns
These are columns that not indicated on table manually but automatcially registered on the system.
### Pseudo Columns with "connect by clause"
connect by clause is useful when we want to view table as tree structure. Therefore, the table which represent hierarical view, the following is very useful pseudo column to know
#### level
this column represent level of the tree. **you must include "start with" and "connnect by" clause to use it.
#### connect_by_isleaf
this represent if the row is leaf or not. It returns 1 if it is leaf and 0 otherwise.
#### connect_by_iscycle
this represents if current row has a child which is also ancestor. it returns 1 if it is 0 if not.
##### Example
This example uses level and connect_by_isleaf, to see if it the row is inner, leaf or root.
Tree table: p_id represents parent node
| id | p_id |
| -- | ---- |
| 1  | null |
| 2  | 1    |
| 3  | 1    |
| 4  | 2    |
| 5  | 2    |

diagram:

![image](https://github.com/ykim879/advanced_sql/assets/59812671/fd48a270-38f9-4fe9-a590-00a85cece977)

query:

``` sql
select id, case 
    when level = 1 then 'Root'
    when connect_by_isleaf = 1 then 'Leaf'
    else 'Inner'
end as type
from Tree
start with id = (select id from Tree where p_id is null)
connect by prior id = p_id;
```
output: 
| ID | TYPE  |
| -- | ----- |
| 1  | Root  |
| 2  | Inner |
| 4  | Leaf  |
| 5  | Leaf  |
| 3  | Leaf  |
### ROWNUM (Use it for top N reporting)
order of the row in table.
#### top N reporting with rownum
``` sql
select * from (
    select * from employees order by employee_id
) where rownum < N
```
### Sequence
generate unique sequential values
- curval: current value of sequence
- nextval: increments and returns the value
use case:
- select list without distinct group by and order by
- insert with values (typically for pk)
- set clause of updates
### Version Query Pseudo Columns
- versions_starttim/endtime: time stamp of first/last version
- versions_startscn/end_scn: scn of first/last version
- versions_xid
### ORA_ROWSCN
see when the row is last updated (cannot use in on view)
### Others
- column_value: return XMLTableType of column value
- object_id: object identifier (pk)
- row_id: address of the row
- smldata: access underlying lob/ object relational column
---
## Operations
### 0. Operators precedence (the order of the operators)
The order is highest to lowest:
1. unary operators (+,-)  hierarchical operators (prior, connect_by_root)
2. *, /
3. addition, subtraction, concatenation (||)
4. others
### 1. Set Operation
1. Union: union return values of two queries and return all distinct rows
2. Union All: union return values of two queries without duplicates
3. Intersect: retun all distict rows on both query
4. Minus: return selected on first but not on second query
### 2. Multiset Operation
do multiset operation on two nested tables either with "all", "distinct", or nothing operation. "all" alwasy include duplicates while distinct eliminates them
#### 2.1 Multiset Execept
![image](https://github.com/ykim879/advanced_sql/assets/59812671/20397c16-d917-4629-9547-f2c8095040d9)
``` sql
select id, set1_name multiset except distinct/all set2_name column_name from table
```
return set value in fist set but not on second set. to handle duplicates we use:
1. all: for m,n, first set for m and second set for n, duplicates will have (m-n) occurences if m>n, 0, otherwise.
2. distinct: eliminates all duplicates
#### 2.2 Multiset Intersect
![image](https://github.com/ykim879/advanced_sql/assets/59812671/9dd43ad4-fdde-4d4d-b4cb-a91350b30d70)
``` sql
select id, set1 multiset intersect distinct set2 column_name from table
```
retun values are common in two input nested tables. for duplicates:
1. all: return min (m, n) times
2. distict: eliminates all duplicates
#### 2.3 Multiset Union
return union values all with duplicates distict without duplicates
### 3. Hierarchical Operators
These operators are only valid if it is hierarchical queries.
#### 3.1 Prior
Piror causes comes with equal side as prior id = parent_column. the example is below
``` sql
select id, case 
    when level = 1 then 'Root'
    when connect_by_isleaf = 1 then 'Leaf'
    else 'Inner'
end as type
from Tree
start with id = (select id from Tree where p_id is null)
connect by prior id = p_id;
```
Above, if id2's p_id column is id1 then id1 is parent of id2 and level of id2 will be 2 while level of id1 will be 1.
#### 3.2 Connect_By_Root
returns the root data of the row. It cannot be specified in the START WITH clause or the CONNECT BY clause of a hierarchical query. Below, it returns the department number of each row's heirarical deparment which is established by connect by prior clause.
``` sql
SELECT CONNECT_BY_ROOT DEPTNAME AS ROOT, DEPTNAME
     FROM DEPARTMENT 
     START WITH DEPTNO IN ('B01','C01','D01','E01')
     CONNECT BY PRIOR DEPTNO = ADMRDEPT
```
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

