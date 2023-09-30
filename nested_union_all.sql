(select name results from
(select name from movieRating u1
  inner join users u2 on u1.user_id = u2.user_id 
  group by u2.user_id, name
  order by count(movie_id) desc, name asc)
where rownum = 1)
union all
select results from (select title results, avg(rating) ratings from MovieRating mr
inner join Movies m on mr.movie_id = m.movie_id
where to_char(created_at, 'YYYY-MM') = '2020-02'
group by m.movie_id, title
order by ratings desc, title asc)
where rownum = 1;
