select
	s.Name + N'.' + t.name as [Table]
	,i.name as [Index]
	,ius.user_seeks as [Seeks], ius.user_scans as [Scans]
	,ius.user_lookups as [Lookups]
	,ius.user_seeks + ius.user_scans + ius.user_lookups as [Reads]
	,ius.user_updates as [Updates], ius.last_user_seek as [Last Seek]
	,ius.last_user_scan as [Last Scan], ius.last_user_lookup as [Last Lookup]
	,ius.last_user_update as [Last Update]
from
sys.tables t join sys.indexes i on
	t.object_id = i.object_id
join sys.schemas s on
	t.schema_id = s.schema_id
left outer join sys.dm_db_index_usage_stats ius on
	ius.database_id = db_id() and
	ius.object_id = i.object_id and
	ius.index_id = i.index_id
where
	s.name = N'dbo' and t.name = N'UsageDemo'
order by
	s.name, t.name, i.index_id



------------------------------------------------------------
--Unused indexes

select object_name(i.object_id) as ObjectName, i.name as [Unused Index],MAX(p.rows) Rows
,8 * SUM(a.used_pages) AS 'Indexsize(KB)',
case 
	when i.type = 0 then 'Heap' 
	when i.type= 1 then 'clustered'
	when i.type=2 then 'Non-clustered'  
	when i.type=3 then 'XML'  
	when i.type=4 then 'Spatial' 
	when i.type=5 then 'Clustered xVelocity memory optimized columnstore index'  
	when i.type=6 then 'Nonclustered columnstore index' 
end index_type,
'DROP INDEX ' + i.name + ' ON ' + object_name(i.object_id) 'Drop Statement'
from sys.indexes i
left join sys.dm_db_index_usage_stats s on s.object_id = i.object_id
     and i.index_id = s.index_id
     and s.database_id = db_id()
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
where objectproperty(i.object_id, 'IsIndexable') = 1
AND objectproperty(i.object_id, 'IsIndexed') = 1
and s.index_id is null -- and dm_db_index_usage_stats has no reference to this index
or (s.user_updates > 0 and s.user_seeks = 0 and s.user_scans = 0 and s.user_lookups = 0)-- index is being updated, but not used by seeks/scans/lookups
GROUP BY object_name(i.object_id) ,i.name,i.type
order by object_name(i.object_id) asc