Task 4:
*****************
/*
    - A `datelist_int` generation query. 
    Convert the `device_activity_datelist` column into a `datelist_int` column 
*/
with user_devices as (
select  user_id,
		browser_type,
		device_activity_datelist,
		date
from user_devices_cumulated 
where date= date('2023-01-31')
),

series_date as (
select generate_series(date('2023-01-01'), date('2023-01-31'), interval '1 day') as date_series
)
select  user_id,
		browser_type,
		date,
		case when device_activity_datelist @> array[date(date_series)] 
			 then pow(2, 32 - (date - date(date_series)))
			 else 0 
			 end as date_list_int
from user_devices cross join series_date;