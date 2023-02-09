/**************************************************************
			INSERT and UPDATE in the Same Script Example

Author: EK12
Notes:
	* This is not meant to be run.  It is just an example
	* The script first inserts any records that don't already exist.  Just insert any non-null columns.  You'll update all the columns in the second step
	* It then updates. 
	* Your source data needs to be unique on the target/update table PK or else you'll get a duplicate error

****************************************************************/

--In this particular example, we had a table called studentForLoading that didn't have  PK on it, so we needed to check for uniqueness or force it.
--select StudentIdentifier from StudentForLoading
--group by studentIdentifier
--having count(*) >1



--student for loading absolutely has to be unique by studentidentifier
insert into Student (
	[StudentIdentifier] --only insert the columns that cannot be null
      ,[USI]
      ,[LEA_Code]
      ,[SchoolYear]
)
select 
	[StudentIdentifier]
      ,[USI]
      ,[LEA_Code]
      ,[SchoolYear]
from StudentForLoading sfl
where 1=1
	and lea_code is not null
	and usi is not null
	and not exists (select * from Student s where s.StudentIdentifier=sfl.StudentIdentifier)

;
--student for loading absolutely has to be unique by studentidentifier
update s
set 
	s.[StudentIdentifier]=u.[StudentIdentifier] --I copied these exact columns using excel to make sure they match (with a little editing after the forumula ) -> =",s."&RIGHT(TRIM(A1),LEN(TRIM(A1))-1)&"=u."&RIGHT(TRIM(A1),LEN(TRIM(A1))-1)
	,s.[USI]=u.[USI]
	,s.[LEA_Code]=u.[LEA_Code]
	,s.[SchoolYear]=u.[SchoolYear]
	,s.[At-Risk Status]=u.[At-Risk Status]
	,s.[IEP Status]=u.[IEP Status]
	,s.[Grade Level]=Left(u.[Grade Level],10)
	,s.[Race Ethnicity]=u.[Race Ethnicity]
	,s.[Gender]=u.[Gender]
	,s.[ELL Status]=u.[ELL Status]
	,s.[GradeSort]=u.[GradeSort]
	,s.[Name]=u.[Name]
	,s.[School Code]=u.[School Code]
	,s.[Current SWD Level]=u.[Current SWD Level]
	,s.[Highest SWD Level]=u.[Highest SWD Level]
	,s.[Current Primary Disability]=u.[Current Primary Disability]
	,s.[Homeless Status]=u.[Homeless Status]
	,s.[SIS FARMS Status]=u.[SIS FARMS Status]
	,s.[FARMS Status]=u.[FARMS Status]
	,s.[School CEP Status]=u.[School CEP Status]
	,s.[Stage 5 Entry Date]=u.[Stage 5 Entry Date]
	,s.[Stage 5 Exit Date]=u.[Stage 5 Exit Date]
from student s
join studentForLoading u on u.studentidentifier=s.studentidentifier


