select top 50
db_name(ps.database_id) as [DB]
,object_name(ps.object_id, ps.database_id) as [Proc Name]
,ps.type_desc as [Type]
,qp.query_plan as [Plan]
,ps.execution_count as [Exec Count]
,(ps.total_logical_reads + ps.total_logical_writes) /
ps.execution_count as [Avg IO]
,ps.total_logical_reads as [Total Reads]
,ps.last_logical_reads as [Last Reads]
,ps.total_logical_writes as [Total Writes]
,ps.last_logical_writes as [Last Writes]
,ps.total_worker_time as [Total Worker Time]
,ps.last_worker_time as [Last Worker Time]
,ps.total_elapsed_time / 1000 as [Total Elapsed Time]
,ps.last_elapsed_time / 1000 as [Last Elapsed Time]
,ps.last_execution_time as [Last Exec Time]
from
sys.dm_exec_procedure_stats ps with (nolock)
cross apply sys.dm_exec_query_plan(ps.plan_handle) qp
order by
[Avg IO] desc
option (recompile)