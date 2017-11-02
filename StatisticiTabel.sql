SELECT s.object_id,
OBJECT_NAME(s.object_id) AS table_name,
COL_NAME(s.object_id, sc.column_id) AS 'Column Name',
s.Name AS 'Name of the statistics',
s.auto_created as 'Is automatically created'
FROM sys.stats AS s
INNER JOIN sys.stats_columns AS sc
ON s.stats_id = sc.stats_id AND s.object_id = sc.object_id
--order by OBJECT_NAME(s.object_id) 
WHERE s.object_id = OBJECT_ID( '*****NUME_TABEL*****')