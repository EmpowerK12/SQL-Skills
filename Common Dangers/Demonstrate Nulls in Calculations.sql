select 50 + null


/*create table #tempTable (val1 int, val2 int)
insert into #tempTable values (1,2)
insert into #tempTable values (null,2)
insert into #tempTable values (1,null)*/

select sum(val1) from #tempTable
select avg(val1) from #tempTable
select val1+val2 from #tempTable