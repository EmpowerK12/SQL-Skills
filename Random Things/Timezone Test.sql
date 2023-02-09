SELECT GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

SELECT GETDATE() AT TIME ZONE 'UTC'
SELECT GETDATE() 

SELECT CAST(DATEADD(HOUR,6,GETDATE()) AS DATE)
SELECT CAST(DATEADD(HOUR,6,GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time') AS DATE)
--note: eastern standard time is based on your computer's registry and takes daylight savings into account
select * from sys.time_zone_info

--see https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-time-zone-info-transact-sql?view=sql-server-ver15
--see https://docs.microsoft.com/en-us/sql/t-sql/queries/at-time-zone-transact-sql?view=sql-server-ver15