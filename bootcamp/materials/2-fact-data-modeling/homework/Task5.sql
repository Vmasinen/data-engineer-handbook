Task 5:
******************
/*
    - A DDL for `hosts_cumulated` table 
    - a `host_activity_datelist` which logs to see which dates each host is experiencing any activity
*/

 create table hosts_cumulated (
 host text,
 host_activity_datelist Date[], --list of dates where the hosts was active in the past
 date date, --current date for the host
 primary key(host, date)
 );