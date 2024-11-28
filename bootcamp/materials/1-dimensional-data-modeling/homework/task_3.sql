Task 3:

 create table actors_history_scd (
 actor text,
 actorid text,
 quality_class quality_class,
 is_active boolean,
 start_date integer,
 end_date integer,
 current_year integer, can be treated as date partition in big data world
 primary key(actorid,start_date,end_date)
 );

 create type scd_type2 as (
 quality_class quality_class,
 is_active boolean,
 start_date integer,
 end_date integer
 );