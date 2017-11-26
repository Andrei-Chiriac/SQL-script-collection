select name,create_date,modify_date,datediff(mi,modify_date,getdate()) as ModifiedMinutesAgo
from sys.procedures
where datediff(mi,modify_date,getdate())  < 60
go