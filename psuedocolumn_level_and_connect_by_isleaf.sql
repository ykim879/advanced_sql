select id, case 
    when level = 1 then 'Root'
    when connect_by_isleaf = 1 then 'Leaf'
    else 'Inner'
end as type
from Tree
start with id = (select id from Tree where p_id is null)
connect by prior id = p_id;
