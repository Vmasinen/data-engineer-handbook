Task 1:

 create type films as (
 			film text,
 			votes integer,
 			rating real,
 			filmid text
 );

 create type quality_class as enum('star','good','average','bad');



 create table actors(
 			actor text,
 			actorid text,
 			year integer,
 			films films[],
 			quality_class quality_class,
 			is_active boolean,
 			primary key(actorid,year)
 );