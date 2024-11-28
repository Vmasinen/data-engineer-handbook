Task 4:

 script to insert the historical data into actors_history_scd table

 insert into actors_history_scd
 with with_previous as (
 select actor,
 	   actorid,
 	   quality_class,
 	   is_active,
 	   lag(quality_class, 1) over (partition by actor order by year) as previous_quality_class,
 	   lag(is_active, 1) over (partition by actor order by year) as previous_is_active,
 	   year as current_year
 from actors
 where year <= 2020
 ),

 with_indicators as (
 select *,
 		case when quality_class <> previous_quality_class then 1
 			 when is_active <> previous_is_active then 1
 			 else 0
 		end as change_indicator
 from with_previous
 ),

 with_streaks as (
 select *,
 		sum(change_indicator) over (partition by actor order by current_year) as streaks
 from with_indicators
 )

 select actor,
 		actorid,
 		quality_class,
 		is_active,
 		min(current_year) as start_date,
 		max(current_year) as end_date,
 		2020 as current_year
 from with_streaks
 group by actor, actorid, streaks, quality_class, is_active
 order by actor, actorid, streaks;
