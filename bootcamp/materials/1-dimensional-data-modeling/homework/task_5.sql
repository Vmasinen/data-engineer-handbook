
with historical_scd as (
select  actor,
		actorid,
		quality_class,
		is_active,
		start_date,
		end_date
from actors_history_scd
where current_year = 2020 and end_date < 2020
),

last_season_scd as (
select *
from actors_history_scd
where current_year = 2020 and end_date = 2020
), 

current_year_data as (
select *
from actors 
where year = 2021
),

unchanged_records as(
select  cy.actor, 
		cy.actorid,
		cy.quality_class,
		cy.is_active,
		ls.start_date,
		cy.year as end_date
from current_year_data cy join last_season_scd ls
on cy.actorid = ls.actorid
where cy.quality_class = ls.quality_class and
   cy.is_active = ls.is_active
),

changed_records as(
select  cy.actor, 
		cy.actorid,
		unnest(array[
				row(
					ls.quality_class,
					ls.is_active,
					ls.start_date,
					ls.end_date)::scd_type2,
				row(
					cy.quality_class,
					cy.is_active,
					cy.year,
					2021 )::scd_type2
				])::scd_type2 as records
from current_year_data cy left join last_season_scd ls
on cy.actorid = ls.actorid
where cy.quality_class <> ls.quality_class or
   cy.is_active <> ls.is_active
),



unnested_changed_records as(
select  actor,
		actorid,
		(records::scd_type2).quality_class,
		(records::scd_type2).is_active,
		(records::scd_type2).start_date,
		(records::scd_type2).end_date
from changed_records
),

new_records as (
select  cy.actor, 
		cy.actorid,
		cy.quality_class,
		cy.is_active,
		cy.year as start_date,
		 2021 as end_date
from current_year_data cy left join last_season_scd ls
on cy.actorid = ls.actorid 
where ls.actorid is null
)

select * from new_records
union all
select * from unnested_changed_records
union all
select * from unchanged_records
union all
select * from historical_scd