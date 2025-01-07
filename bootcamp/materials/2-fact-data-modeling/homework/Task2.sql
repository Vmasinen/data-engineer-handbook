Task 2:
*****************
/*
- A DDL for an `user_devices_cumulated` table that has:
  - a `device_activity_datelist` which tracks a users active days by `browser_type`
  - data type here should look similar to `MAP<STRING, ARRAY[DATE]>`
    - or you could have `browser_type` as a column with multiple rows for each user (either way works, just be consistent!)
*/
create table user_devices_cumulated (
user_id text,
browser_type text,
device_activity_datelist Date[], --list of dates where the device was active in the past
date date --current date for the device
primary key(user_id,browser_type,date)
);