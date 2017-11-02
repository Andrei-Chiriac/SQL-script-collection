select top 50
	s.name + '.' + p.name as [Procedure]
	,qp.query_plan as [Plan]
	,(ps.total_logical_reads + ps.total_logical_writes) /
	ps.execution_count as [Avg IO]
	,ps.execution_count as [Exec Cnt]
	,ps.cached_time as [Cached]
	,ps.last_execution_time as [Last Exec Time]
	,ps.total_logical_reads as [Total Reads]
	,ps.last_logical_reads as [Last Reads]
	,ps.total_logical_writes as [Total Writes]
	,ps.last_logical_writes as [Last Writes]
	,ps.total_worker_time as [Total Worker Time]
	,ps.last_worker_time as [Last Worker Time]
	,ps.total_elapsed_time as [Total Elapsed Time]
	,ps.last_elapsed_time as [Last Elapsed Time]
from
	sys.procedures as p with (nolock) join sys.schemas s with (nolock) on
	p.schema_id = s.schema_id
	join sys.dm_exec_procedure_stats as ps with (nolock) on
	p.object_id = ps.object_id
	outer apply sys.dm_exec_query_plan(ps.plan_handle) qp
order by
[Avg IO] desc
option (recompile);