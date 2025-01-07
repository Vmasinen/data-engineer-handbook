Task 7:
******************
/*
    - A monthly, reduced fact table DDL `host_activity_reduced`
    - month
    - host
    - hit_array - think COUNT(1)
    - unique_visitors array -  think COUNT(DISTINCT user_id)
*/
create table host_activity_reduced(
host text,
month date,
hit_array integer[],
unique_visitors integer[],
primary key(host, month)
);