select page_count, avg_page_space_used_in_percent, avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats
(db_id(),object_id(N'dbo.Numetabel'),1,null,'DETAILED');