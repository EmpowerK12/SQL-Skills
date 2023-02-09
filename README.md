# SQL-Skills
A repository for sample SQL code everyone can learn from!

# Table of Contents

- [Introduction](#introduction)
- [Uniqueness](#uniqueness)
- [Joins In Depth](#joins-in-depth)
- [Modularity](#modularity)
- [Constraints](#constraints)
- [Window Functions](#window-functions)
- [Common Dangers](#common-dangers)
- [Pivot](#pivot)
- [Insert Update](#insert-update)
- [Helpful Functions](#helpful-functions)
- [System Tables](#system-tables)
- [Random Things](#random-things)

# Introduction
## Who should use this?
**This is not intended for people just learning the basics.**  Here are some things we put into "the basics."
 - Select
 - Inner Join
 - Left Join
 - Group By
 - Where
 - Order by
 - Aggregation Functions
 - Insert
 - Update
 - Like
 - Googling to figure stuff out

**This is also not a comprehensive resource for intermediate and advanced SQL.**  It is mostly a checklist of important skills and topics and some resources to go along with it.  It is created by our community as we think of skills that would be helpful for everyone to learn.  

We include really important ideas about uniqueness and keys, but we also throw in some fun/silly stuff like converting time zones and comparing sounds that you may never use.  

## Document Organization
Below we have a list of topics that you may be interested in with some explanation where we found time to write it.  There is also a set of folders that have sample SQL files that may illustrate a topic.  If you contribute to this repository with sample SQL code, please include sample data in line so that anyone can run the code without having access to a specific database.


# Uniqueness
Understanding uniqueness is the most important part of SQL coding and yet it is the least talked about in intro courses or web pages. It is so important because every time you do a join you risk adding duplicates if you don't understand what makes both tables you are joining unique.

**Every SQL user needs to have a very strong ability to look at a table and understand which columns naturally make a composite key.**  For example, when looking at a table of assessment data, are you able to figure out which set of columns should logically make every row unique? HINT: You shouldn't start by looking at the data, which can throw you off.  You should think about what we *want* to make each row unique. (can someone else better explain this skill???)

| Year | Season | Student ID | Subject | Scale Score | Percentile | ... |
| --- | --- | --- | --- | --- | --- | --- |
| 2023 | Fall | 1 | Math | 200 | 75 |  |
| 2023 | Fall | 2 | Math | 190 | 74 |  |

If you don't quickly see that Year, Season, Student ID, and Subject are the logical composite key, then you should practice this skill more.  

**Primary keys** and **foreign keys** are tools we create to make understanding uniqueness easier and faster, but they shouldn't be a crutch if you don't have the skill above - understanding what should logically make a table unique.  We're not going to get into PKs and FKs here since they are effectively intro SQL ideas.

## Commenting Joins
One of the best ways to make your code legible and to practice thinking about uniqueness is commenting your joins.  Here is an example

```SQL
  SELECT *
  FROM studentSection ss
  JOIN section sec on sec.sectionID=ss.sectionID --unique on PK/FK
  JOIN student s on s.studentID=ss.studentID --unique on PK/FK
  JOIN v_sectionScheduleMain sched on sched.sectionID=sec.sectionID and rn=1 --unique because sched is forced unique on sectionID using row_number
```
## Forcing Uniqueness
The two most common ways to force unqiueness are... 
 1. group by
 2. row_number()

I'm not going to explain how to use them here, but someone should feel free to add that. If you are reading this doc you should already know how to use group by.  You can find resources on how to create row numbers that reset for a set of columns (partition by) that you want to force uniqueness on.  Then you just pick the row where row_number (aliased frequently as rn) = 1.

# Joins In Depth
 - Cross join (aka joining on 1=1)

# Modularity
Making code modular reduces errors and improves readability and usability.  Two common ways we do that is by creating **views** and **temp tables**.  We also use **variables** so that you don't need to change strings all over your file when you update it.  We're not going to cover the basics of making views and temp tables here, but we'll mention some helpful things to know about them.

## Views

## Temp Tables
  1. Helpful code to drop your temp tables: `drop table if exists #yourTempTable`
  2. sldjfslkd
  
## Variables

# Constraints
 1. Not null
 2. Unique
 3. Primary Key
 4. Foreign Key
 5. Check
 6. Default
 7. Create Index

# Window Functions
 - Aggregate over(partition by…. Order by…)
 - Lag()/Lead()
 - Running totals
 - rows unbounded preceding

# Common Dangers
## Removing Nulls with `not in` or `<>`
## DateDiff
If you use datediff to compare years, it will literally subtract the years.  So 1/1/2023 is one year different from 12/31/2022.

```SQL
declare @endDate date = '1/1/2023'
declare @startDate date = '12/31/2022'

select datediff(year,@startDate,@endDate) as [YearDiffWrong]
```
# Pivot
I still don't really understand how to do this, so I'm not explaining it here, but it is very helpful and it deserves a place on this checklist.

# Insert Update
## Where Not Exists

# Helpful Functions
## String_Agg
## String_Split
## Coalesce
## Except


# System Tables

# Random Things
## 1=1
## Age
To calculate age you need to use this funny formula because of the problems with datediff mentioned above.
```SQL
declare @testDate dateTime;
set @testDate = cast('1/17/2016' as datetime);

select (CONVERT(decimal(12,4),CONVERT(char(8),@testDate,112))-CONVERT(char(8),GETDATE(),112))/10000;

```
## Time Zones
## Case Sensitive Compare
## Sound Comparison - SoundEx
## Computed Columns
