# SQL-Skills
A repository for sample SQL code everyone can learn from!  This was made for the [DC Education Data Club](https://sites.google.com/view/dcedc/home).  See [disclaimer](#disclaimer) at the bottom of this doc.

# Table of Contents
This is just a manually created table of contents for easy viewing.  However, it may not be fully up to date.  For a complete, auto-generated ToC use the GitHub ToC in the top left corner of this frame.  If you can't find it, here is [info about it](https://github.blog/changelog/2021-04-13-table-of-contents-support-in-markdown-files/).

- [Introduction](#introduction)
- [Uniqueness](#uniqueness)
- [Joins In Depth](#joins-in-depth)
- [Code Quality and Modularity](#code-quality-and-modularity)
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

| Year | Season | Subject | Student ID | Scale Score | Percentile | ... |
| --- | --- | --- | --- | --- | --- | --- |
| 2023 | Fall | Math | 1 | 200 | 75 |  |
| 2023 | Fall | Math | 2 | 190 | 74 |  |

If you are not able to look at the column names, think for a little bit, and figure out that Year, Season, Student ID, and Subject are the logical composite key, then you should practice this skill more.  

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
To better understand joins and be able to do more sophisticated joins (like creating multiple rows intentionally), I find it helpful to think of all joins a cross join (aka joining on 1=1) and then filtering down using the ON clause.  Do others think of their complicated joins in this way?

# Code Quality and Modularity
Making code modular reduces errors and improves readability and usability.  Two common ways we do that is by creating **views** and **temp tables**.  We also use **variables** so that you don't need to change strings all over your file when you update it.  We're not going to cover the basics of making views and temp tables here, but we'll mention some helpful things to know about them.

## Backwards Planning and Pseudo Code
Start with your goal in mind.  You should know the structure of your end tables, especially the uniqueness/effective keys of the tables.  Then work back from there writing in pseudo code to think through all the tables that will go into your analysis and how you should force uniqueness at each step.  They comment all your joins as mentioned above.

## Views
	1. If you have a slow view, try to create views that join on primary keys only to speed it up
	2. If you want to speed things up, try making a view to keep things consistent but then storing it as a temp table at the beginning of your stored procedure
	3. You can create index of base views, but for me (Kenli), I didn't see much performance improvement

## Temp Tables
  1. Helpful code to drop your temp tables: `drop table if exists #yourTempTable`
  2. Sorry, they don't have temp tables in Oracle last I checked.  Maybe they have materialized views?
  
## Variables
Use them.

## Formatting
1. Yes, really use tabs to format. Try to be consistent
2. Has anyone had success with automatic online SQL formatters?
3. Use `/***********************************/ break up your code and make larger comment blocks clear

Do you have any formatting tips to add?

# Constraints
 1. Not null
 2. Unique
 3. Primary Key
 4. Foreign Key
 5. Check (see example code)
 6. Default
 7. Create Index

# Window Functions
[Helpful tutorial](https://mode.com/sql-tutorial/sql-window-functions/#the-usual-suspects-sum-count-and-avg)
 - Aggregate over(partition by…. Order by…)
 - Lag()/Lead()
 - Running totals
 - Rows unbounded preceding

# Common Dangers
## Removing Nulls with `not in` or `<>`
See code

## DateDiff
If you use datediff to compare years, it will literally subtract the years.  So 1/1/2023 is one year different from 12/31/2022.

```SQL
declare @endDate date = '1/1/2023'
declare @startDate date = '12/31/2022'

select datediff(year,@startDate,@endDate) as [YearDiffWrong]
```

## Union Combined with Union All
If you use union and union all in the same query, watch out for how distinct works.  There is sample code to investigate the functionality.

## Nulls in Calculations
Make sure you know how nulls affect calculations. There is test code to look at.

## Row_number with distinct
Distinct won't work if you use row_number first.  Row_number evaluates BEFORE distinct.


# Pivot
I still don't really understand how to do this, so I'm not explaining it here, but it is very helpful and it deserves a place on this checklist.

# Insert Update
See sample code.

## Where Not Exists
It is helpful to learn `WHERE NOT EXISTS`.  It's not much different from using a left join, but it feels more readable.  Same thing with `WHERE EXISTS`.

# Helpful Functions
## String_Agg()
Aggregates strings from multiple rows and puts a delimiter in between.

## String_Split()
Opposite of String_Agg()

## Coalesce()
Look this up immediately if you don't know what it is.

## EXCEPT
Useful to compare the results from before and after a script. Store your target table (e.g. target) in a temp table (e.g. #temp) before your operations and then compare using EXCEPT.  Compare in both directions.

```SQL
--shows everything in your starting table that is no longer there after the edits
SELECT * FROM #temp 
EXCEPT
SELECT * FROM target

--shows everything in your final table that wasn't in your starting table
SELECT * FROM target 
EXCEPT
SELECT * FROM #temp
```


# System Tables

# Random Things
## 1=1
Used to make commenting out lines of a WHERE or ON clause easier.  You HAVE to use it with and, not OR unless you want to get every result back!
```SQL
...
WHERE 1=1
	--and studentID = 1005 --you can comment out the first line without having to remove the and
	and calendarID is not null
	and schoolyear=2015
```

## Age
To calculate age you need to use this funny formula because of the problems with datediff mentioned above.
```SQL
declare @testDate dateTime;
set @testDate = cast('1/17/2016' as datetime);

select (CONVERT(decimal(12,4),CONVERT(char(8),@testDate,112))-CONVERT(char(8),GETDATE(),112))/10000;

```
## Time Zones
See sample code.

## Case Sensitive Compare
See sample code.

## Sound Comparison - SoundEx
See sample code.

## Computed Columns
It can be handy to turn a composite key into a single column key.  For example, for an assessment table, you may want a SchoolYear, AssessmentPeriod, AcademicSubject, USI as a composite key.  But it is annoying to join on all those columns, so you can make an AssessmentStudentID computed column.

```SQL
CREATE TABLE [dbo].[AssessmentStudent](
	[USI] [bigint] NOT NULL,
	[SchoolYear] [int] NOT NULL,
	[AssessmentPeriod] [varchar](10) NOT NULL,
	[AcademicSubject] [varchar](100) NOT NULL,
	[ScoreResult] [int] NULL,
	[Percentile] [int] NULL,
	[AssessmentStudentID]  AS CONVERT([varchar](10),[USI])+'_'+CONVERT([varchar](10),[SchoolYear])+'_'+[AssessmentPeriod] +'_'+ [AcademicSubject], --this is the same data as the Primary Key, and can be used in joins
 CONSTRAINT [PK__AssessmentStudent] PRIMARY KEY CLUSTERED 
(
	[USI] ASC,
	[SchoolYear] ASC,
	[AssessmentPeriod] ASC,
	[AcademicSubject] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[AssessmentObjectiveStudent](
	[USI] [bigint] NOT NULL,
	[SchoolYear] [int] NOT NULL,
	[AssessmentPeriod] [varchar](10) NOT NULL,
	[AcademicSubject] [varchar](100) NOT NULL,
	[Objective] [varchar](20) NOT NULL,
	[ScoreResult] [int] NULL,
	[Percentile] [int] NULL,
	[AssessmentStudentID]  AS CONVERT([varchar](10),[USI])+'_'+CONVERT([varchar](10),[SchoolYear])+'_'+[AssessmentPeriod] +'_'+ [AcademicSubject], --this is the same data as the Primary Key from AssessmentStudent, and can be used in joins
 CONSTRAINT [PK__AssessmentObjectiveStudent] PRIMARY KEY CLUSTERED 
(
	[USI] ASC,
	[SchoolYear] ASC,
	[AssessmentPeriod] ASC,
	[AcademicSubject] ASC,
	[Objective] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SELECT *
FROM AssessmentObjectiveStudent aos
JOIN AssessmentStudent a on a.AssessmentStudentID=aos.AssessmentStudentID --simple join!  :)
```

## Execution Plans
Have folks have success using the execution plan to figure out how to speed up a slow query?

## ALT+click+drag = long cursur
Hold down alt and then click and drag to see some cool editing abilities!
![alt click drag example](https://user-images.githubusercontent.com/1110966/27159725-8601413a-512c-11e7-85d6-fdb082e53e2c.gif)

# Disclaimer
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
