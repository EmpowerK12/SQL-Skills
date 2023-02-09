/**************************************

					READ ME

Collation seems to tell the system how to compare and sort strings.  It may do other things as well.  
Here is query to see all collations:

--all collations
select * from fn_helpcollations()

This file explores the collations of existing databases, columns, etc and explores using collation to make comparisons case sensitive

****************************************/

--Latin1_General_CS_AS (case sensitive?)
--SQL_Latin1_General_CP1_CI_AS (default on our server)


--properties of case insensitive and server collation
SELECT
	name,
	description
	,COLLATIONPROPERTY(name, 'CodePage') AS CodePage
	,COLLATIONPROPERTY(name, 'LCID') AS LCID
FROM fn_helpcollations()
WHERE name in ( N'Latin1_General_CS_AS' --case insensitive (according to stack overflow)
	,N'SQL_Latin1_General_CP1_CI_AS'); --the default server collation

--properties of all columns
SELECT
	name,
	description
	,COLLATIONPROPERTY(name, 'CodePage') AS CodePage
	,COLLATIONPROPERTY(name, 'LCID') AS LCID
FROM fn_helpcollations()
WHERE name in ( SELECT distinct collation_name FROM sys.columns);

--this server's collation
SELECT CONVERT (varchar(256), SERVERPROPERTY('collation'));

--database collation
SELECT name, collation_name FROM sys.databases;

--columns
SELECT name, collation_name FROM sys.columns --WHERE name = N'<insert character data type column name>';

--columns for non standard collations
SELECT c.name, c.collation_name,o.name as objectName,o.type_desc,c.* FROM sys.columns c
join sys.objects o on o.object_id=c.object_id
WHERE collation_name in (
	N'Latin1_General_CS_AS'
	, N'SQL_Latin1_General_CP437_CS_AS'
	,N'SQL_Latin1_General_CP437_CS_AS'
	,N'Latin1_General_CI_AS_KS_WS'
	,N'Latin1_General_BIN'
	);

--columns for explicitly case sensitive Latin1_General_CS_AS collations
SELECT c.name, c.collation_name,o.name as objectName,o.type_desc,c.* FROM sys.columns c
join sys.objects o on o.object_id=c.object_id
WHERE collation_name =
	N'Latin1_General_CS_AS'
	





/**************************Testing Case Sensitive Compare**********************/

IF OBJECT_ID('tempdb..#collationTest') IS NOT NULL
    DROP TABLE #collationTest
create table #collationTest (ID varchar(20),things varchar(20))

insert into #collationTest
values ('A','Apple')

insert into #collationTest
values ('a','Banana')

select * from #collationTest

--no change in collation
select *
from #collationTest c1
join #collationTest c2 on c2.ID=c1.ID

--change collation
select *
from #collationTest c1
join #collationTest c2 on c2.ID=c1.ID collate Latin1_General_CS_AS

go

--does collation persist (must run the last query first, then this one)
select *
from #collationTest c1
join #collationTest c2 on c2.ID=c1.ID
--looks like it doesn't affect the collation permanently

--does it work in comparisons?  Looks like it doesn't matter which side of the equals sign is collated
select *
	, case when c1.ID=c2.ID then 1 else 0 end as [regular compare]
	, case when c1.ID=c2.ID collate Latin1_General_CS_AS then 1 else 0 end as [collate compare 1]
	, case when c1.ID collate Latin1_General_CS_AS =c2.ID  then 1 else 0 end as [collate compare 2]
from #collationTest c1
join #collationTest c2 on c2.ID=c1.ID

--how does distinct work?
select distinct ID collate Latin1_General_CS_AS from #collationTest

--how about in 'in' clauses?
select *
from #collationTest c1
where ID in ('a' collate Latin1_General_CS_AS)

select *
from #collationTest c1
where ID in ('a')

--row number?
select *
	,row_number() over(partition by ID order by ID)
from #collationTest c1

select *
	,row_number() over(partition by ID collate Latin1_General_CS_AS order by ID)
from #collationTest c1


--does it work in a subquery?
--yes.  carries through
select *
from #collationTest c1
join (select ID collate Latin1_General_CS_AS as ID,things from #collationTest) c2 on c2.ID=c1.ID
