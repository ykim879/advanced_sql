select score, dense_rank() over (order by score desc) rank
from Scores;
/* Scores table
| id | score |
| -- | ----- |
| 1  | 3.5   |
| 2  | 3.65  |
| 3  | 4     |
| 4  | 3.85  |
| 5  | 4     |
| 6  | 3.65  |
*/
/* result table
| SCORE | RANK |
| ----- | ---- |
| 4     | 1    |
| 4     | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.5   | 4    |
*/
