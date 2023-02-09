--does row_number make something not unique? --yes.  treat it as a column BEFORE the distinct is applied

IF OBJECT_ID('tempdb..#rowTest') IS NOT NULL
    DROP TABLE #rowTest
create table #rowTest (ID varchar(20),things varchar(20))

insert into #rowTest
values ('1','Apple')

insert into #rowTest
values ('2','Banana')

insert into #rowTest
values ('2','Yogurt')

select * from #rowTest

select distinct ID from #rowTest

select  
	ID
	,ROW_NUMBER() over(partition by ID order by things) as rn
from #rowTest

select distinct 
	ID
	,ROW_NUMBER() over(partition by ID order by things) as rn
from #rowTest