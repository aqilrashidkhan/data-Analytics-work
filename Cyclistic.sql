-- lets create A database named Cyclistic
-- create table with table name bikeshare_data2021 with all fields,columns of same type as in files and import the files into this table using table data import wizard.  

Use Cyclistic;
select * from bikeshare_data2021;       -- where bikeshare_data2021 is the table name.
select count(*)from bikeshare_data2021; -- total rows in the raw data is 6927930

-- clean data by removing null values, missing values etc to maintain data integrity.

delete from bikeshare_data2021
WHERE ride_id='';                 -- 0 rows removed.

delete from bikeshare_data2021
WHERE rideable_type='';              -- 0 rows removed.

delete from bikeshare_data2021
WHERE started_at is null;            -- 0 rows removed.

delete from bikeshare_data2021
WHERE ended_at is null;              -- 0 rows removed.

delete from bikeshare_data2021
WHERE start_station_name='';         -- 753473 rows removed.

delete from bikeshare_data2021
WHERE start_station_id='';           -- 10361 rows removed.

delete from bikeshare_data2021
WHERE end_station_name='';           -- 3093 rows removed.

delete from bikeshare_data2021
WHERE end_station_id='';             -- 331020 rows removed. 

delete from bikeshare_data2021
WHERE  start_lat ='';                -- 0 rows removed.  

delete from bikeshare_data2021
WHERE start_lng is null;             -- 0 rows removed. 

delete from bikeshare_data2021
WHERE end_lat is null;               -- 0 rows removed.

delete from bikeshare_data2021
WHERE end_lng is null;               -- 0 rows removed.

delete from bikeshare_data2021
WHERE member_casual ='';             -- 0 rows removed.


-- now total rows with that have values for all columns is :- 
select count(*)from bikeshare_data2021;    -- 5829983 rows remain.


-- manipulating data to get the ride length or duration of ride for each row.alter

ALTER table bikeshare_data2021
ADD COLUMN ride_length INT After ended_at; 

ALTER table bikeshare_data2021
ADD COLUMN weekday INT After ride_length; 

update bikeshare_data2021
set ride_length = TIMESTAMPDIFF(second,started_at,ended_at);

update bikeshare_data2021
set weekday =  WEEKDAY(started_at); -- Returns the weekday index for date (0 = Monday, 1 = Tuesday, … 6 = Sunday).

select * from bikeshare_data2021
order by ride_length desc;

-- lets delete those rows from table where start date is greater than end date (false data)
-- and also those rides where duration is less than 60 seconds. Effectively,a ride should last for a minute or more. 

delete from bikeshare_data2021
where ride_length<60; -- deleted 135175 rows of data where ride_length was less than 60 seconds

select * from bikeshare_data2021; -- 5694808 rows returned.

-- now lets delete those rows where a ride duration lasts more than 24 hours (i.e more than 86400 seconds).
delete from bikeshare_data2021
where ride_length >= 86400; -- 63933 rows removed.

select count(*)from bikeshare_data2021 where ride_length =3600;-- one hour ride

--       ********************************* Analysis of the data *****************************************

-- finding number of total number of rides taken for each day of week 
select weekday,count(*)from bikeshare_data2021 
group by weekday
order by weekday;

-- finding number of rides taken for both sets of members on each day of week.
select weekday,member_casual,count(*)from bikeshare_data2021 
group by weekday,member_casual
order by weekday;

-- finding average duration of rides taken for each day of week
select weekday,avg(ride_length) as Average_ride_duration from bikeshare_data2021 
group by weekday
order by weekday;

-- finding average duration of rides taken for by both sets for each day of week
select weekday,member_casual,avg(ride_length) as Average_ride_duration from bikeshare_data2021 
group by weekday,member_casual
order by weekday;

-- finding total number of rides taken for each MONTH.
select MONTHNAME(started_at) as monthname,count(*)as total_rides from bikeshare_data2021
group by monthname
order by monthname asc;

-- finding total number of rides taken by each set of riders for each MONTH.
select member_casual, MONTHNAME(started_at) as monthname,count(*)as total_rides from bikeshare_data2021
group by monthname,member_casual
order by monthname;

-- top 10 starting point stations where rush is high for both
select distinct start_station_name,count(*)as total_number_of_rides_taken from bikeshare_data2021
group by start_station_name
order by total_number_of_rides_taken desc
limit 10;

-- top 10 stat stations for casual riders
select distinct start_station_name,count(*)as total_number_of_rides_taken from bikeshare_data2021
where member_casual='casual'
group by start_station_name
order by total_number_of_rides_taken desc
limit 10;

-- top 10 stat stations for casual riders
select distinct start_station_name,count(*)as total_number_of_rides_taken from bikeshare_data2021
where member_casual='member'
group by start_station_name
order by total_number_of_rides_taken desc
limit 10;

-- busy hours for both sets
select hour(started_at)as busy_hours,count(*)as total_rides_during_this_hour from bikeshare_data2021
group by busy_hours
order by total_rides_during_this_hour desc
limit 8;

-- busy hours for casual members only
select hour(started_at)as busy_hours_for_casual_members,count(*)as total_rides_during_this_hour from bikeshare_data2021
where member_casual='casual'
group by busy_hours_for_casual_members
order by total_rides_during_this_hour desc
limit 8;


-- busy hours for annual members only
select hour(started_at)as busy_hours_for_annual_members,count(*)as total_rides_during_this_hour from bikeshare_data2021
where member_casual='member'
group by busy_hours_for_annual_members
order by total_rides_during_this_hour desc
limit 8;


 