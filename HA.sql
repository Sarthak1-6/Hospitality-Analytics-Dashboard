create database Hospitality_Analyst;
use Hospitality_Analyst;
create table dim_hotels(property_id int,property_name varchar(50),category varchar(20),city varchar(15));
select * from dim_hotels;
create table dim_rooms(room_id varchar(20),room_class varchar(15));
select * from dim_rooms;
create table dim_date(c_date varchar(10),month_year varchar(10),weekno varchar(15),day_type varchar(15));
select * from dim_date;
create table fact_aggregated_bookings(property_id int,check_in_date varchar(15),room_category varchar(15),successful_bookings int,capacity int);
select * from fact_aggregated_bookings;
create table fact_bookings(booking_id varchar(25),property_id int,booking_date varchar(20),check_in_date varchar(20),checkout_date varchar(20),no_guests int,room_category varchar(20),booking_platform varchar(20),ratings_given varchar(5),booking_status varchar(20),revenue_generated int,revenue_realized int);
select * from fact_bookings;
select 
sum(revenue_realized) as total_revenue
from fact_bookings;

select
count(booking_id) as total_bookings
from fact_bookings;

SELECT
SUM(capacity) AS total_capacity
FROM fact_aggregated_bookings;

SELECT
SUM(successful_bookings)AS SUCCESSFUL_BOOKINGS
FROM fact_aggregated_bookings;

SELECT
        ROUND(
              SUM(successful_bookings) *100/ SUM(capacity),
              2
              ) AS occupancy_percentage
        FROM fact_aggregated_bookings;
        
SELECT
	   booking_status,COUNT(booking_id)
       AS total_bookings
       FROM fact_bookings
       GROUP BY booking_status;
       
       
	SELECT
	booking_status,
      ROUND(
            COUNT(BOOKING_ID) * 100.0
            / SUM(COUNT(BOOKING_ID)) OVER (),
            2) AS BOOKING_percentage
            FROM fact_bookings
            GROUP BY booking_status;
            
	  SELECT
      booking_status,
      ROUND(
            COUNT(BOOKING_ID) * 100.0
            / SUM(COUNT(BOOKING_ID)) OVER (),
            2) AS BOOKING_percentage
            FROM fact_bookings
            GROUP BY booking_status;



	SELECT
	   D.ROOM_CLASS,sum(f.revenue_realized)as revenue
       FROM fact_bookings f
       JOIN dim_rooms d on f.room_category=d.room_id
       group by D.ROOM_CLASS
       order by revenue desc;
       
       SELECT
         d.room_class,
         ROUND(
               COUNT(f.booking_id) * 100.0 /
               SUM(COUNT(BOOKING_ID)) OVER (),
               2) AS booking_percentage
               FROM fact_bookings f
               JOIN dim_rooms d
                 ON f.room_category = d.room_id
                GROUP BY d.room_class
                ORDER BY booking_percentage DESC;
       
       SELECT ROUND(SUM(revenue_realized) /
           COUNT(booking_id),2) AS ADR
           FROM fact_bookings;
           
     SELECT
         ROUND(AVG(ratings_given), 2) AS average_rating
         FROM fact_bookings
         WHERE ratings_given>0;
         
  # MONTHLY WISE REVENUE

   SELECT MONTHNAME(D.new_date)AS MONTHNAME,SUM(F.revenue_realized)
   FROM fact_bookings F
   JOIN dim_date D on D.new_date=F.new_CHECK_IN_DATE
   GROUP BY monthname
   ORDER BY monthname DESC;

 # TOTAL BOOKING BY WEEKDAY/WEEKEND

   Select d.day_type,count(f.booking_id)AS TOTAL_BOOKINGS
   from fact_bookings f
   left join dim_date d on f.new_check_in_date = d.new_date
   group by d.day_type
   ORDER BY TOTAL_BOOKINGS DESC;


 # WEEKDAY/WEEKEND REVENUE

   select d.day_type,count(f.booking_id)AS TOTAL_REVENUE
   from fact_bookings f
   left join dim_date d on f.new_check_in_date = d.new_date
   group by d.day_type
   ORDER BY TOTAL_REVENUE DESC;
   
   -- alter datatype --
ALTER TABLE dim_date
ADD COLUMN new_date DATE;
-- update date --
UPDATE dim_date
SET new_date = STR_TO_DATE(c_date, '%d-%b-%Y');
-- delete column --
alter table dim_date
drop column c_date;
select * from dim_date;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE fact_aggregated_bookings
ADD COLUMN new_check_in_date DATE;
UPDATE fact_aggregated_bookings
SET new_check_in_date = STR_TO_DATE(check_in_date, '%d-%b-%Y');
alter table fact_aggregated_bookings
drop column check_in_date;
select * from fact_aggregated_bookings;

ALTER TABLE fact_bookings
ADD COLUMN new_check_in_date DATE;
UPDATE fact_bookings
SET new_check_in_date = STR_TO_DATE(check_in_date, '%Y-%m-%d');
alter table fact_bookings
drop column check_in_date;

ALTER TABLE fact_bookings
ADD COLUMN new_booking_date DATE;
UPDATE fact_bookings
SET new_booking_date = STR_TO_DATE(booking_date, '%Y-%m-%d');
alter table fact_bookings
drop column booking_date;




