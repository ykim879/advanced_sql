# SQL Documentation
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
