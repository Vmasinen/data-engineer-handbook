Task 3:
*****************
/*
    - A cumulative query to generate `device_activity_datelist` from `events`
*/

insert into user_devices_cumulated
with yesterday as(
select * 
from user_devices_cumulated 
where date= date('2023-01-01')
),

today as (
select  cast(e.user_id as text) as user_id,
		d.browser_type as browser_type,
		max(date(cast(e.event_time as timestamp))) as device_activity_date
from events e join devices d
on e.device_id = d.device_id 
where  date(cast(e.event_time as timestamp))= date('2023-01-02')
		and e.user_id is not null 
		and d.browser_type is not null
group by e.user_id, d.browser_type
)
		select  coalesce(t.user_id, y.user_id) as user_id,
		coalesce(t.browser_type, y.browser_type) as browser_type,
		Case when y.device_activity_datelist is null then array[t.device_activity_date]
			 when t.device_activity_date is null then y.device_activity_datelist
			 else array[t.device_activity_date] || y.device_activity_datelist  
		End
		as device_activity_datelist,
		coalesce(t.device_activity_date, y.date + Interval '1 Day') as date
from today as t full outer join yesterday as y
on t.user_id = y.user_id 
on conflict(user_id, browser_type, date) do nothing;