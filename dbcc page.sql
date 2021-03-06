DBCC CHECKDB

DBCC SHOWCONTIG()
DBCC SHOWCONTIG('NumeTabel')


dbcc ind
(
	'SQLServerInternals' /*Database Name*/
	,'dbo.DataRows' /*Table Name*/
	,-1 /*Display information for all pages of all indexes*/
);

dbcc traceon(3604)
dbcc page
(
	'SqlServerInternals' /*Database Name*/
	,1 /*File ID*/
	,214643 /*Page ID*/
	,3 /*Output mode: 3 - display page header and row details */
);
dbcc traceoff(3604)