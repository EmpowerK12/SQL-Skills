--inspired by https://www.mssqltips.com/sqlservertip/3347/drop-and-recreate-all-foreign-key-constraints-in-sql-server/#comments

drop table if exists #x 
CREATE TABLE #x -- feel free to use a permanent table  --KO: I don't know what this does.  It was in the orginal script I copied.
(
  drop_script NVARCHAR(MAX),
  create_script NVARCHAR(MAX)
);
  
DECLARE @drop   NVARCHAR(MAX) = N'',
        @create NVARCHAR(MAX) = N'';

declare @targetcolumn varchar(30) = '[ProviderStudentID]' --put the column you want to find the constraints for here.

drop table if exists #allFK  --creating a main pull of all FK and their columns.
select quotename(cs.[name]) as [schema]
	,quotename(ct.[name]) as [table]
	,quotename(fk.[name]) as [foreign_key]
	,quotename(rs.[name]) as [referenced_schema]
	,quotename(rt.[name]) as [referenced_table]
	,constraint_column_id
	,QUOTENAME(c.[name]) as [column_name]
	,QUOTENAME(rc.[name]) as referenced_column_name
into #allFK
FROM sys.foreign_keys AS fk
JOIN sys.tables AS ct ON ct.[object_id] = fk.parent_object_id  --the table that foreign key lives on - the "constraint table"
JOIN sys.schemas AS cs ON cs.[schema_id] = ct.[schema_id]
JOIN sys.tables AS rt ON rt.[object_id] = fk.referenced_object_id --the table that the foreign key references (the target; what we would normally call the parent - be careful b/c parent below means the opposite)
JOIN sys.schemas AS rs ON  rs.[schema_id] = rt.[schema_id]
JOIN sys.foreign_key_columns fkc on fkc.constraint_object_id=fk.[object_id]
JOIN sys.columns c on c.column_id=fkc.parent_column_id and c.[object_id]=fkc.parent_object_id
join sys.columns rc on rc.column_id=fkc.referenced_column_id and rc.[object_id]=fkc.referenced_object_id
WHERE rt.is_ms_shipped = 0 --indicates it was created by a user, not 'shipped' by Microsoft
	AND ct.is_ms_shipped = 0;

drop table if exists #FKlist
select distinct [schema],[table],[foreign_key] --getting a distinct list of all the keys for our target column
into #FKlist
from #allFK
where column_name = @targetcolumn --need to look at both the constraint column and the referenced column 
or referenced_column_name = @targetcolumn


SELECT @drop += 
N'
ALTER TABLE ' + [schema] + '.' + [table] 
    + ' DROP CONSTRAINT ' + [foreign_key] + ';'
from #FKlist

--drop table if exists #FKcolumns
SELECT @create += N'
ALTER TABLE ' 
   + fc.[schema] + '.' + fc.[table]
   + ' ADD CONSTRAINT ' + fc.[foreign_key] 
   + ' FOREIGN KEY (' 
   + STRING_AGG([column_name],',') within group (order by constraint_column_id asc)  --use string_agg to put all columns in one "cell"
   + ') REFERENCES ' + referenced_schema + '.' + referenced_table
   + '(' 
   + STRING_AGG(referenced_column_name,',') within group (order by constraint_column_id asc)
   + ');'
from #allFK fc
join #FKlist fl on 1=1
	and fl.[schema]=fc.[schema] 
	and fl.[table]=fc.[table]
	and fl.foreign_key=fc.foreign_key
group by fc.[schema]
	,fc.[table]
	,fc.[foreign_key]
	,referenced_schema
	,referenced_table

UPDATE #x SET create_script = @create;



--these get printed and then you can copy them to a new window
print @drop;
PRINT @create;


/*
EXEC sp_executesql @drop
-- clear out data etc. here
EXEC sp_executesql @create;
*/
