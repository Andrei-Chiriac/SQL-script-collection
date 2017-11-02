select
TL1.resource_type as [Resource Type]
,db_name(TL1.resource_database_id) as [DB Name]
,case TL1.resource_type
when 'OBJECT' then
object_name(TL1.resource_associated_entity_id
,TL1.resource_database_id)
when 'DATABASE' then
'DB'
else
case
when TL1.resource_database_id = db_id()
then
(
select object_name(object_id
,TL1.resource_database_id)
from sys.partitions
where hobt_id =
TL1.resource_associated_entity_id
)
else
'(Run under DB context)'
end
end as [Object]
,TL1.resource_description as [Resource]
,TL1.request_session_id as [Session]
,TL1.request_mode as [Mode]
,TL1.request_status as [Status]
,WT.wait_duration_ms as [Wait (ms)]
,QueryInfo.sql
,QueryInfo.query_plan
from
sys.dm_tran_locks TL1 with (nolock)
left outer join sys.dm_os_waiting_tasks WT with (nolock) on
TL1.lock_owner_address = WT.resource_address
and TL1.request_status = 'WAIT'
outer apply
(
select
substring(
S.Text,
(ER.statement_start_offset / 2) + 1,
((
case
ER.statement_end_offset
when -1
then datalength(S.text)
else ER.statement_end_offset
end - ER.statement_start_offset) / 2) + 1
) as sql,
qp.query_plan
from
sys.dm_exec_requests ER with (nolock)
cross apply sys.dm_exec_sql_text(ER.sql_handle) S
outer apply sys.dm_exec_query_plan(er.plan_handle) qp
where
TL1.request_session_id = ER.session_id
) QueryInfo
where
TL1.request_session_id <> @@spid
order by
TL1.request_session_id
option (recompile)