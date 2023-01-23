use cyclic_bike_share;

-- DATA PREPARATION

-- CREATE TABLE FOR EACH MONTH
CREATE TABLE agu22(
ride_id char(255),
rideable_type char(50),
started_at datetime,
ended_at datetime,
start_station_name char(100),
start_station_id char(100),
end_station_name char(100),
end_station_id char(100),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual char(50) );

-- CREATE TABLE FOR COMBINED TABLE
CREATE TABLE full_yearv01 (
ride_id char(255),
rideable_type char(50),
started_at datetime,
ended_at datetime,
start_station_name char(100),
start_station_id char(100),
end_station_name char(100),
end_station_id char(100),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual char(50) );

-- INSERT VALUE TO MAIN TABLE (full_yearv01) for all months
INSERT INTO cyclic_bike_share.full_yearv01(ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual)
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.jan22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.feb22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.mar22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.apr22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.mei22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.jun22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.jul22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.agu22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.sept22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.oct22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.nov22)
UNION ALL
(SELECT ride_id, rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat ,start_lng,end_lat,end_lng ,member_casual
FROM cyclic_bike_share.des22) ;

-- DATA CONDITIONING AND CLEANING

ALTER TABLE cyclic_bike_share.full_yearv01
DROP COLUMN start_lat,
DROP COLUMN start_lng,
DROP COLUMN end_lat,
DROP COLUMN end_lng;

DELETE FROM cyclic_bike_share.full_yearv01
Where 
(ride_id IS NULL OR  ride_id = '') or
(rideable_type IS NULL OR rideable_type = '') OR
(started_at IS NULL OR started_at = 0) OR
(ended_at IS NULL OR ended_at = 0) OR
(start_station_name IS NULL OR start_station_name = '') OR
(start_station_id IS NULL OR start_station_id = '') OR
(end_station_name IS NULL OR end_station_name = '') OR
(end_station_id IS NULL OR end_station_id = '') OR
(member_casual IS NULL OR member_casual = '') ;

Select Count(DISTINCT(ride_id)) AS uniq,
Count(ride_id) AS total
From cyclic_bike_share.full_yearv01;

DELETE F1 FROM cyclic_bike_share.full_yearv01 AS F1  
INNER JOIN cyclic_bike_share.full_yearv01 AS F2   
WHERE F1.ride_id < F2.ride_id AND F1.ride_id = F2.ride_id; 

ALTER TABLE cyclic_bike_share.full_yearv01
ADD date_ymd char(20),
ADD y_year char(20),
ADD m_month char (20),
ADD day_of_week char (20),
ADD ride_length int,
ADD day_of_week_num int;

UPDATE cyclic_bike_share.full_yearv01
SET date_ymd = CAST(started_at AS date),
y_year = date_format(started_at,'%Y'),
m_month = date_format (started_at,'%M'),
day_of_week = date_format(started_at,'%W'),
ride_length = timestampdiff(second,started_at,ended_at),
day_of_week_num = weekday(started_at) + 1;

ALTER TABLE cyclic_bike_share.full_yearv01
ADD month_num int;

UPDATE cyclic_bike_share.full_yearv01
SET month_num = month(started_at);

DELETE FROM cyclic_bike_share.full_yearv01
WHERE ride_length IS NULL OR
ride_length = 0 OR
ride_length < 0 OR
ride_length > 86400 ;


-- DATA ANALYZING

-- NUMBER FOR EACH TYPE OF CUSTOMERS
SELECT 
COUNT(case when member_casual ='member' then 1 else NULL END) AS num_of_member,
COUNT(case when member_casual='casual' then 1 else NULL END) AS num_of_casual,
Count(*) AS num_of_customers
FROM cyclic_bike_share.full_yearv01 ;


-- AVERAGE, MIN, MAX RIDE LENGTH FOR EACH TYPE OF CUSTOMERS
SELECT
member_casual,
AVG(ride_length) AS avg_ride_second,
MIN(ride_length) AS min_ride_second,
MAX(ride_length) AS max_ride_second
FROM cyclic_bike_share.full_yearv01
GROUP BY member_casual ;

-- TRAFFIC PER DAY
SELECT
Count(case when member_casual = 'member' then 1 else NULL END) AS num_of_member,
Count(case when member_casual = 'casual' then 1 else NULL END) AS num_of_casual,
Count(*) AS num_of_customers,
date_ymd AS date_d
From cyclic_bike_share.full_yearv01
Group BY date_ymd
ORDER BY date_ymd ;

-- NUMBER OF CUSTOMERS IN DAY
CREATE TABLE num_of_customers_in_day
SELECT
Count(case when member_casual = 'member' then 1 else NULL END) AS num_of_member,
Count(case when member_casual = 'casual' then 1 else NULL END) AS num_of_casual,
Count(*) AS num_of_customers,
day_of_week
From cyclic_bike_share.full_yearv01
Group BY day_of_week, day_of_week_num
ORDER BY day_of_week_num ;

-- NUMBER OF CUSTOMERS IN MONTH
CREATE TABLE num_of_customers_in_month AS
SELECT
Count(case when member_casual = 'member' then 1 else NULL END) AS num_of_member,
Count(case when member_casual = 'casual' then 1 else NULL END) AS num_of_casual,
Count(*) AS num_of_customers,
m_month
From cyclic_bike_share.full_yearv01
Group BY m_month, month_num
ORDER BY month_num ;














 
