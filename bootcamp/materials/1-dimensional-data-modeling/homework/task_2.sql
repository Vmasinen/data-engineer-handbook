Task 2:

 insert into actors
 with previous_year_actors as (
 select * from actors where year=2020
 ),
 curr_year_actors as (
 select actor,actorid,year, 
 				case when avg(rating) > 8 then 'star'
 					 when avg(rating) > 7 then 'good'
 					 when avg(rating) > 6 then 'average'
 					 else 'bad' 
 				end::quality_class as quality_class,
 				array_agg(row(film,votes,rating,filmid)::films) as films
			
 from actor_films where year=2021
 group by 1,2,3
 )

 select coalesce(c.actor, p.actor) as actor,
 	   coalesce(c.actorid, p.actorid) as actorid,
 	   coalesce(c.year, p.year+1) as year,
 	   case when p.films is null then c.films 
 			when c.films is not null then
 				p.films || c.films
 			else p.films end as films,
 	   coalesce(c.quality_class, p.quality_class) as quality_class,
 	   case when c.year is not null then True else False end as is_active			
 from curr_year_actors as c full outer join  previous_year_actors as p 
 on c.actorid = p.actorid;