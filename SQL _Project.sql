create database project;
use project;
select * from artist;
select* from museum;
select * from work;
select * from product_size;
--  Q1) Are there museuems without any paintings?
select *
from museum m
LEFT JOIN work w
ON m.museum_id = w.museum_id
Where w.work_id is NULL;

-- Q2)How many paintings have an asking price of more than their regular price? 
select count(*) as total
from product_size
WHERE sale_price > regular_price;

-- Q3) Identify the paintings whose asking price is less than 50% of its regular price 
select * from product_size
where sale_price <(0.5* regular_price);

-- Q4)Which canva size costs the most?
select* from canvas_size; 
select c.label, p.regular_price from canvas_size c
join product_size p 
on c.size_id = p.size_id
group by 1,2
having max(2)
order by 2 desc
limit 1;

-- Q6  Identify the museums with invalid city information in the given dataset
SELECT *
FROM museum
WHERE city REGEXP '^[0-9]';

-- Q7  Fetch the top 10 most famous painting subject
 select distinct subject, count(*) from subject s
join work w on s.work_id=w.work_id
group by subject
order by count(*) desc
limit 10;
 
-- Q8 Identify the museums which are open on both Sunday and Monday. Display museum name, city 
SELECT m.name, m.city, m.state, m.country
FROM museum_hours mh
JOIN museum m ON mh.museum_id = m.museum_id
WHERE day IN ('Sunday', 'Monday')
GROUP BY m.name, m.city, m.state, m.country
HAVING COUNT( day) = 2
ORDER BY m.name;

-- Q9 How many museums are open every single day?
select count(*) from
(SELECT museum_id,COUNT(museum_id)
FROM museum_hours
GROUP BY museum_id
HAVING COUNT(day) =7) a; 

-- Q10 Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
select m.museum_id, m.name,
count(*) as no_of_painting
FROM museum m
JOIN work w
ON m.museum_id = w.museum_id
group by m.museum_id, m.name
order by count(*) desc
Limit 5; 

-- Q11 Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
select a.full_name, a.nationality, count(*) as no_of_painting
FROM artist a
JOIN work w
ON a.artist_id = w.artist_id
group by a.full_name, a.nationality
order by count(*) desc
limit 5; 

-- Q12 Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
select a.full_name, a.style, count(*) as no_of_pain
from artist a
JOIN work w ON a.artist_id= w.artist_id
JOIN museum m ON m.museum_id = w.museum_id
group by a.full_name, a.style
order by count(*) 
limit 5;

-- Q13 Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day? 

select m.name,m.state, mh.day, mh.open-mh.close as long_e
from museum_hours mh
JOIN museum m
ON mh.museum_id = m.museum_id
order by mh.open-mh.close desc
limit 1;

-- Q14 Which museum has the most no of most popular painting style?
select m.name, w.style, count(*) as no_of_paint
from museum m
JOIN work w
on m.museum_id = w.museum_id
group by m.name, w.style
order by count(*) desc
limit 1;

-- Q15 Identify the artists whose paintings are displayed in multiple countries?
select a.full_name, a.style, count(*) as no_of_pain
from artist a
JOIN work w ON a.artist_id= w.artist_id
JOIN museum m ON m.museum_id = w.museum_id
group by a.full_name, a.style
order by count(*) desc; 

-- Q16 Display the country and city with most number of museums?

with cte_country as
(select country, count(1),
rank() over(order by count(1)desc)as rnk
from museum 
group by country) 



-- Q20 20) A Which country has the 5th highest no of paintings?*/

select m.country, count(*) as no_of_pain
from artist a
JOIN work w ON a.artist_id= w.artist_id
JOIN museum m ON m.museum_id = w.museum_id
group by m.country
order by count(*) desc
LIMIT 1
OFFSET 4; 	

-- 21) A Which are the 3 most popular and 3 least popular painting styles?

(select style, count(*) as no_of_paintings, 'Most Popular' as remarks
from work
group by style
order by count(*) desc
limit 3)

UNION

(select style, count(*) as no_of_paintings, 'Least Popular' as remarks
from work
group by style
order by count(*) asc
limit 3); 

-- Q22 22)A Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality?

select a.full_name, a.nationality, count(*) as no_of_paintings
from work w
join artist a on a.artist_id=w.artist_id
join subject s on s.work_id=w.work_id
join museum m on m.museum_id=w.museum_id
where m.country <> 'USA' AND s.subject = 'Portraits'
group by a.full_name, a.nationality
order by count(*) desc
limit 1; 




