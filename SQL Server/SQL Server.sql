

----shrink log file

USE Risk_mng_OLTP
GO
ALTER DATABASE Risk_mng_OLTP SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKFILE(Risk_Mng_TAT_log_BK, 1)
ALTER DATABASE Risk_mng_OLTP SET RECOVERY FULL WITH NO_WAIT
GO





----TPS
SELECT cntr_value, *
 FROM sys.dm_os_performance_counters
 WHERE counter_name = 'transactions/sec'
 AND OBJECT_NAME = 'SQLServer:Databases';
 
 
SELECT cntr_value, *
 FROM sys.dm_os_performance_counters
 WHERE instance_name='NonDomesticTransactions';
 
 
 
 ----SIZE
 use filerwin
exec sp_spaceused


--TABLES SIZE


SELECT 
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.NAME NOT LIKE 'dt%' 
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
GROUP BY 
    t.Name, s.Name, p.Rows
ORDER BY 
    t.Name




---
SELECT CONVERT (varchar, SERVERPROPERTY('collation'));

SELECT name, collation_name FROM sys.databases;

EXECUTE sp_helpsort;

SELECT name, description FROM sys.fn_helpcollations();

SELECT CONVERT (varchar, DATABASEPROPERTYEX('database_name','collation'));

SELECT name, collation_name FROM sys.columns WHERE name = N'<insert character data type column name>';

