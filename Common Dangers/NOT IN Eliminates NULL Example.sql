/**************************************************
NOT IN Eliminates NULL example

Author: EmpowerK12
Notes:
	* None


***************************************************/

drop table if exists #test
create table #test (val1 int)

insert into #test values (1),(2),(3),(null)

select 'all values' as tableName, val1 from #test
select 'not in' as tableName, val1 from #test where val1 not in (1,2) --notice that 3 shows but null gets eliminated
select '<>' as tableName, val1 from #test where val1 <> 1 --notice that 2 and 3 show but null gets eliminated
select 'or includes null' as tableName, val1 from #test where val1 <> 1 or val1 is null --use or to include nulls