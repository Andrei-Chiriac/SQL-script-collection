select
mg.session_id
,t.text as [SQL]
,qp.query_plan as [Plan]
,mg.is_small
,mg.dop
,mg.query_cost
,mg.request_time
,mg.required_memory_kb
,mg.requested_memory_kb
,mg.wait_time_ms
,mg.grant_time
,mg.granted_memory_kb
,mg.used_memory_kb
,mg.max_used_memory_kb
from
sys.dm_exec_query_memory_grants mg with (nolock)
cross apply sys.dm_exec_sql_text(mg.sql_handle) t
cross apply sys.dm_exec_query_plan(mg.plan_handle) as qp
option (recompile)