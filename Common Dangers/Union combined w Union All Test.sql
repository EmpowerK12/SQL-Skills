drop table if exists #test1
create table #test1 (
	col1 int not null
)

drop table if exists #test2
create table #test2 (
	col1 int not null
)

drop table if exists #test3
create table #test3 (
	col1 int not null
)

drop table if exists #test4
create table #test4 (
	col1 int not null
)
insert into #test1
values (1),(1),(2),(3),(5)

insert into #test2
values (1),(2),(3),(4),(6)

insert into #test3
values (1),(2),(4),(7),(7)

insert into #test4
values (1),(2),(5),(8),(8)

select * from #test1
select * from #test2
select * from #test3
select * from #test4

select * from #test1
union all
select * from #test2
union 
select * from #test3


select * from #test1
union all
select * from #test2
union all
select * from #test3


select * from
(select * from #test1
union all
select * from #test2) a
union
select * from #test3


select * from #test1
union all
select * from
(select * from #test2
union
select * from #test3) a


select * from #test1
union
select * from #test2
union all
select * from #test3