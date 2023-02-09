drop table if exists #sampledata

create table #sampledata (
	id int not null
	, studentName varchar(50) not null
	, entryDate date not null
	, exitDate date
)

insert into #sampledata
values( 1,'Kenli','1/1/2000',null)

insert into #sampledata
values( 2,'Amanda','1/5/2000','6/1/2000')


drop table if exists #dates


create table #dates (
	[date] date not null
)

insert into #dates
values( '1/1/2000')
	,('1/2/2000')
	,('1/3/2000')
	,('1/4/2000')
	,('1/5/2000')
	,('1/6/2000')
	,('1/7/2000')
	,('1/8/2000')
	,('1/9/2000')
	,('1/10/2000')




declare @today date
set @today='1/3/2000'

declare @lastDayOfSchool date
set @lastDayOfSchool='6/30/2000'

select * from #sampledata
select * from #dates

--pick active students
select * from #sampledata
where entrydate<=@today
	and coalesce(exitdate,@lastDayOfSchool)>=@today --?>?


--one row for each day a student is enrolled (stop example at 1/10/2000)
select * from #sampledata s
join #dates d on d.[date]>=s.entryDate and d.[date]<=coalesce(s.exitDate,@lastDayOfSchool)  --?>?

--same idea with between (which I think is inlusive?)
select * from #sampledata s
join #dates d on d.[date] between s.entryDate and coalesce(s.exitDate,@lastDayOfSchool)  --?>?