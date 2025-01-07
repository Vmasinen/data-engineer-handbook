Task 6:
*****************

/*
    - The incremental query to generate `host_activity_datelist`
*/

insert into hosts_cumulated

with yesterday as (
select host,
	   host_activity_datelist,
	   date
from hosts_cumulated
where date = '2022-12-31'
),

today as (
select distinct host,
		date(event_time) as date
from events
where date(event_time) = '2023-01-01'  and host is not null
)

select  coalesce(t.host, y.host),
		case when y.host_activity_datelist is Null then array[t.date]
			 when t.date is null then y.host_activity_datelist
			 else  array[t.date] || y.host_activity_datelist
		end as 	host_activity_datelist,
		coalesce(t.date, y.date+1)
from today as t full outer join yesterday as y
on t.host = y.host