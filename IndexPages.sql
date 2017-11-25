

if objectproperty(object_id('[IndexPagesOutput]'), 'IsUserTable') is not null
	drop table [IndexPagesOutput]
go

create table IndexPagesOutput
(
	[PageFID] tinyint,
	[PagePID] int,
	[IAMFID] tinyint,
	[IAMPID] int,
	[ObjectID] int,
	[IndexID] int,
	[PartitionNumber] tinyint,
	[PartitionID] bigint,
	[iam_chain_type] varchar(30),
	[PageType] tinyint,
	[IndexLevel] tinyint,
	[NextPageFID] tinyint,
	[NextPagePID] int,
	[PrevPageFID] tinyint,
	[PrevPagePID] int,
	constraint [IndexPageOutput_PK]
		primary key ([PageFID], [PagePID])
)

go

select 
	--*
	index_depth as D,
	index_level as L,
	record_count as [Rows],
	page_count as [Pages],
	avg_page_space_used_in_percent as  [Page_Percent_Full],
	min_record_size_in_bytes as [Row_Min_Length],
	max_record_size_in_bytes as [Row_Max_Length],
	avg_record_size_in_bytes as [Row_Avg_Length]
from sys.dm_db_index_physical_stats
	 (
		db_id(N'AdventureWorks2014'), --baza de date
		object_id(N'Person.Person'), --tabel
		1,	--id-ul indexului; pentru indexul clustered este 1
		null,	--id partitie
		'detailed' --mode
	 )


truncate table [IndexPagesOutput]
insert [IndexPagesOutput]
exec ('dbcc ind ([AdventureWorks2014], ''[Person].[Person]'', 1)')
go

select
	*
from [IndexPagesOutput]
order by [IndexLevel] desc, [PrevPagePID]