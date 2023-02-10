/*********************************************

JOIN on NULL Test

Author: EK12

Notes:
	* None

*************************************************/

drop table if exists #test
create table #test (val1 int,val2 int)

insert into #test
values (null,1),(null,2)

select * from #test

--if we join on null will the rows come through?  No.
select * 
from #test t1
join #test t2 on t2.val1=t1.val1