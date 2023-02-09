IF OBJECT_ID('tempdb..#testStudents') IS NOT NULL
    DROP TABLE #testStudents

CREATE TABLE #testStudents
(
	Id INT PRIMARY KEY IDENTITY,
	StudentName VARCHAR (50),
	StudentGender VARCHAR (50),
	StudentAge INT
)
GO

INSERT INTO #testStudents VALUES ('Sally', 'Female', 14 )
INSERT INTO #testStudents VALUES ('Edward', 'Male', 12 )
INSERT INTO #testStudents VALUES ('Jon', 'Male', 13 )
INSERT INTO #testStudents VALUES ('Liana', 'Female', 10 )
INSERT INTO #testStudents VALUES ('Ben', 'Male', 11 )
INSERT INTO #testStudents VALUES ('Elice', 'Female', 12 )
INSERT INTO #testStudents VALUES ('Nick', 'Male', 9 )
INSERT INTO #testStudents VALUES ('Josh', 'Male', 12 )
INSERT INTO #testStudents VALUES ('Liza', 'Female', 10 )
INSERT INTO #testStudents VALUES ('Wick', 'Male', 15 )

select * from #testStudents

-----------------------window functions-------------------
--sums and running totals
select 'order by id',			*,sum(StudentAge) over(order by id) from #testStudents
select 'order by studentAge',	*,sum(StudentAge) over(order by StudentAge) from #testStudents
select 'rows unbounded...',		*,sum(StudentAge) over(order by StudentAge rows unbounded preceding) from #testStudents
select 'partition by gender',	*,sum(StudentAge) over(partition by StudentGender) from #testStudents

--lag
select 'lag',					*,lag(studentAge,1,null) over(partition by StudentGender order by studentAge) from #testStudents
/*https://docs.microsoft.com/en-us/sql/t-sql/functions/lag-transact-sql?view=sql-server-ver15
LAG (scalar_expression [,offset] [,default])  
    OVER ( [ partition_by_clause ] order_by_clause )

LAG (value aka column [,offset] [,default value if offset not present])  
    OVER ( [ partition_by_clause ] order_by_clause )
      
scalar_expression
The value to be returned based on the specified offset. It is an expression of any type that returns a single (scalar) value. scalar_expression cannot be an analytic function.

offset
The number of rows back from the current row from which to obtain a value. If not specified, the default is 1. offset can be a column, subquery, or other expression that evaluates to a positive integer or can be implicitly converted to bigint. offset cannot be a negative value or an analytic function.

default
The value to return when offset is beyond the scope of the partition. If a default value is not specified, NULL is returned. default can be a column, subquery, or other expression, but it cannot be an analytic function. default must be type-compatible with scalar_expression.

OVER ( [ partition_by_clause ] order_by_clause)
partition_by_clause divides the result set produced by the FROM clause into partitions to which the function is applied. If not specified, the function treats all rows of the query result set as a single group. order_by_clause determines the order of the data before the function is applied. If partition_by_clause is specified, it determines the order of the data in the partition. The order_by_clause is required. For more information, see OVER Clause (Transact-SQL).
*/