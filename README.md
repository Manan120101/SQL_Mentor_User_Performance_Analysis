# SQL Mentor User Performance Analysis | Project No.10


## Project Overview

This project is designed to help beginners understand SQL querying and performance analysis using real-time data from SQL Mentor datasets. In this project, you will analyze user performance by creating and querying a table of user submissions. The goal is to solve a series of SQL problems to extract meaningful insights from user data.

## Objectives

- Learn how to use SQL for data analysis tasks such as aggregation, filtering, and ranking.
- Understand how to calculate and manipulate data in a real-world dataset.
- Gain hands-on experience with SQL functions like `COUNT`, `SUM`, `AVG`, `EXTRACT()`, and `DENSE_RANK()`.
- Develop skills for performance analysis using SQL by solving different types of data problems related to user performance.

## Project Level: Beginner

This project is designed for beginners who are familiar with the basics of SQL and want to learn how to handle real-world data analysis problems. You'll be working with a small dataset and writing SQL queries to solve different tasks that are commonly encountered in data analytics.

## SQL Mentor User Performance Dataset

The dataset consists of information about user submissions for an online learning platform. Each submission includes:
- **User ID**
- **Question ID**
- **Points Earned**
- **Submission Timestamp**
- **Username**

This data allows you to analyze user performance in terms of correct and incorrect submissions, total points earned, and daily/weekly activity.

## SQL Problems and Questions

Here are the SQL problems that you will solve as part of this project:

### Q1. List All Distinct Users and Their Stats
- **Description**: Return the user name, total submissions, and total points earned by each user.
- **Expected Output**: A list of users with their submission count and total points.

### Q2. Calculate the Daily Average Points for Each User
- **Description**: For each day, calculate the average points earned by each user.
- **Expected Output**: A report showing the average points per user for each day.

### Q3. Find the Top 3 Users with the Most Correct Submissions for Each Day
- **Description**: Identify the top 3 users with the most correct submissions for each day.
- **Expected Output**: A list of users and their correct submissions, ranked daily.

### Q4. Find the Top 5 Users with the Highest Number of Incorrect Submissions
- **Description**: Identify the top 5 users with the highest number of incorrect submissions.
- **Expected Output**: A list of users with the count of incorrect submissions.

### Q5. Find the Top 10 Performers for Each Week
- **Description**: Identify the top 10 users with the highest total points earned each week.
- **Expected Output**: A report showing the top 10 users ranked by total points per week.

## Key SQL Concepts Covered

- **Aggregation**: Using `COUNT`, `SUM`, `AVG` to aggregate data.
- **Date Functions**: Using `EXTRACT()` and `TO_CHAR()` for manipulating dates.
- **Conditional Aggregation**: Using `CASE WHEN` to handle positive and negative submissions.
- **Ranking**: Using `DENSE_RANK()` to rank users based on their performance.
- **Group By**: Aggregating results by groups (e.g., by user, by day, by week).

## SQL Queries Solutions

Below are the solutions for each question in this project:

### Q1: List All Distinct Users and Their Stats
```sql
select 
  distinct username as user_name,
   count(id) as total_submission,
   sum(points) as points_earned
from user_submissions
group by user_name
order by total_submission desc;
```

### Q2: Calculate the Daily Average Points for Each User
```sql
select
 -- extract(day from submitted_at)as days,
    to_char(submitted_at,'dd-mm')as days,
   username,
   avg(points) as DAILY_Average_points
from user_submissions
group by username,submitted_at
order by username;
```

### Q3: Find the Top 3 Users with the Most Correct Submissions for Each Day
```sql

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
  ```

### Q4: Find the Top 5 Users with the Highest Number of Incorrect Submissions
```sql
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
```

### Q5: Find the Top 10 Performers for Each Week
```sql

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
```


## Conclusion

This project provides an excellent opportunity for beginners to apply their SQL knowledge to solve practical data problems. By working through these SQL queries, you'll gain hands-on experience with data aggregation, ranking, date manipulation, and conditional logic.

## Author - MANAN PATHAK
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Stay Updated
LinkedIn: www.linkedin.com/in/manan-pathak-073bb8166
Thank you for your support, and I look forward to connecting with you!
