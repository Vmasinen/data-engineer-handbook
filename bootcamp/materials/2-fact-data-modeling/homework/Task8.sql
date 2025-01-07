Task 8:
**************************
/*
    - An incremental query that loads `host_activity_reduced`
    - day-by-day
*/
insert into host_activity_reduced
with daily_aggregates as(
select  host,
		date(event_time) as date,
		count(1) as hit_array,
		count(distinct user_id) as unique_visitors
from events
where user_id is not null and date(event_time) = date('2023-01-02')
group by host, date(event_time)
),

yesterday_array as(
select  host,
		month,
		hit_array,
		unique_visitors
from host_activity_reduced
where month = date('2023-01-01')
)

select  coalesce(ya.host, da.host) as host,
		coalesce(ya.month, date(date_trunc('month',da.date))) as month,
		case when ya.host is not null then ya.hit_array || array[coalesce(da.hit_array,0)]
			 else array_fill(0,Array[coalesce(ya.month-date(date_trunc('month',da.date)),0)]) || array[coalesce(da.hit_array,0)]
			 end as hit_array,
		case when ya.host is not null then ya.unique_visitors || array[coalesce(da.unique_visitors,0)]
			 else array_fill(0,Array[coalesce(ya.month-date(date_trunc('month',da.date)),0)]) || array[coalesce(da.unique_visitors,0)]
			 end as unique_visitors
from daily_aggregates as da full outer join yesterday_array as ya
on da.host = ya.host 
on conflict(host,month)
do
	update set hit_array = EXCLUDED.hit_array,
				unique_visitors = EXCLUDED.unique_visitors;