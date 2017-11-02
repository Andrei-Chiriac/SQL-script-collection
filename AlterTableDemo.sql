create table dbo.AlterDemo
(
	ID int not null,
	Col1 int null,
	Col2 bigint null,
	Col3 char(10) null,
	Col4 tinyint null
);


select
c.column_id, c.Name, ipc.leaf_offset as [Offset in Row]
,ipc.max_inrow_length as [Max Length], ipc.system_type_id as [Column Type]
from
sys.system_internals_partition_columns ipc join sys.partitions p on
ipc.partition_id = p.partition_id
join sys.columns c on
	c.column_id = ipc.partition_column_id and
c.object_id = p.object_id
where p.object_id = object_id(N'dbo.AlterDemo')
order by c.column_id;


alter table dbo.AlterDemo drop column Col1;
alter table dbo.AlterDemo alter column Col2 tinyint;
alter table dbo.AlterDemo alter column Col3 char(1);
alter table dbo.AlterDemo alter column Col4 int;