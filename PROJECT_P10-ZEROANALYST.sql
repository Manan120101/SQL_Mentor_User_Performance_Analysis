-- SQL Mini Project 10/10
-- SQL Mentor User Performance

drop table if exists user_submissions;
	create table user_submissions(
    id serial primary key,
	user_id bigint,
	question_id int,
	points int,
	submitted_at timestamp with time zone,
	username varchar(30)
	);

select * from user_submissions;

-- Q.1--> list all distinct users and their stats(return user_name,total_submission,points earned) ?

select 
  distinct username as user_name,
   count(id) as total_submission,
   sum(points) as points_earned
from user_submissions
group by user_name
order by total_submission desc;

-- Q.2 --> Calculate the daily average points for each user?

--each day
--each user and their daily avg points
-- group by day and user


select
 -- extract(day from submitted_at)as days,
    to_char(submitted_at,'dd-mm')as days,
   username,
   avg(points) as DAILY_Average_points
from user_submissions
group by username,submitted_at
order by username;


--Q.3 --> Find the top 3 users with the most correct submissions for each day.

-- each day
-- most correct submission

with daily_submission
as
(
select 
  to_char(submitted_at,'dd-mm') as daily,
  username,
  sum(case
    when points >0 then 1 else 0
  end) as correct_submission
from user_submissions
group by 1,2
),

users_rank
as
(select
  daily,
  username,
  correct_submission,
  dense_rank() over(partition by daily order by correct_submission desc) as rank
from  daily_submission)

select 
   daily,
   username,
   correct_submission
from users_rank
where rank<=3;
  


--Q.4 --> Find the top 5 users with the highest number of incorrect submission.


select
  username,
  sum(
   case
     when points<0 then 1 else 0
	 end
  )as incorrect_submissions
from user_submissions
group by 1
order by incorrect_submissions desc
limit 5;

--Q.5 --> Find the top 10 performers for each week.

select
 *
 from
(select
  extract (week from submitted_at)as week_number ,
  username,
  sum(points) as total_points_earned,
  dense_rank() over(partition by extract (week from submitted_at) order by sum(points)  desc) as rank
from user_submissions
group by week_number,username
order by week_number
)
where rank<=10;


