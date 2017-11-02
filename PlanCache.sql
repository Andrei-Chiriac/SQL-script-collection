

select 
	p.usecounts, p.cacheobjtype, p.objtype, p.size_in_bytes, t.[text]
from
sys.dm_exec_cached_plans p
cross apply sys.dm_exec_sql_text(p.plan_handle) t
where
p.cacheobjtype like 'Compiled Plan%' and
t.[text] like '%%'
order by
p.size_in_bytes desc
option (recompile)
