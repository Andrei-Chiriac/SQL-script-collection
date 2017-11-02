--The first query below tells you which stored procedures are being called the most often, which is good to know for baseline and troubleshooting purposes. Don’t be fooled into assuming that the SP that is called the most often is the most costly though. It may well be that you have other stored procedures that are not called as much, which are much more costly (in different ways) than the most frequently called SPs.

--Query 2 shows the top 20 stored procedures sorted by total worker time (which equates to CPU pressure). This will tell you the most expensive stored procedures from a CPU perspective.

--Query 3 shows the top 20 stored procedures sorted by total logical reads(which equates to memory pressure). This will tell you the most expensive stored procedures from a memory perspective, and indirectly from a read I/O perspective.

--Query 4 shows the top 20 stored procedures sorted by total physical reads(which equates to read I/O pressure). This will tell you the most expensive stored procedures from a read I/O perspective.

--Query 5 shows the top 20 stored procedures sorted by total logical writes(which equates to write I/O pressure). This will tell you the most expensive stored procedures from a write I/O perspective.

--In an upcoming post, I will explain how to interpret the results of these queries, and more importantly, some steps to improve the queries that show up at the top of your lists.

 -- Get Top 100 executed SP's ordered by execution count
    SELECT TOP 100 qt.text AS 'SP Name', qs.execution_count AS 'Execution Count',  
    qs.execution_count/DATEDIFF(Second, qs.creation_time, GetDate()) AS 'Calls/Second',
    qs.total_worker_time/qs.execution_count AS 'AvgWorkerTime',
    qs.total_worker_time AS 'TotalWorkerTime',
    qs.total_elapsed_time/qs.execution_count AS 'AvgElapsedTime',
    qs.max_logical_reads, qs.max_logical_writes, qs.total_physical_reads, 
    DATEDIFF(Minute, qs.creation_time, GetDate()) AS 'Age in Cache'
    FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
    WHERE qt.dbid = db_id() -- Filter by current database
    ORDER BY qs.execution_count DESC


	-- Get Top 20 executed SP's ordered by total worker time (CPU pressure)
    SELECT TOP 20 qt.text AS 'SP Name', qs.total_worker_time AS 'TotalWorkerTime', 
    qs.total_worker_time/qs.execution_count AS 'AvgWorkerTime',
    qs.execution_count AS 'Execution Count', 
    ISNULL(qs.execution_count/DATEDIFF(Second, qs.creation_time, GetDate()), 0) AS 'Calls/Second',
    ISNULL(qs.total_elapsed_time/qs.execution_count, 0) AS 'AvgElapsedTime', 
    qs.max_logical_reads, qs.max_logical_writes, 
    DATEDIFF(Minute, qs.creation_time, GetDate()) AS 'Age in Cache'
    FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
    WHERE qt.dbid = db_id() -- Filter by current database
    ORDER BY qs.total_worker_time DESC


	-- Get Top 20 executed SP's ordered by logical reads (memory pressure)
    SELECT TOP 20 qt.text AS 'SP Name', total_logical_reads, 
    qs.execution_count AS 'Execution Count', total_logical_reads/qs.execution_count AS 'AvgLogicalReads',
    qs.execution_count/DATEDIFF(Second, qs.creation_time, GetDate()) AS 'Calls/Second', 
    qs.total_worker_time/qs.execution_count AS 'AvgWorkerTime',
    qs.total_worker_time AS 'TotalWorkerTime',
    qs.total_elapsed_time/qs.execution_count AS 'AvgElapsedTime',
    qs.total_logical_writes,
    qs.max_logical_reads, qs.max_logical_writes, qs.total_physical_reads, 
    DATEDIFF(Minute, qs.creation_time, GetDate()) AS 'Age in Cache', qt.dbid 
    FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
    WHERE qt.dbid = db_id() -- Filter by current database
    ORDER BY total_logical_reads DESC

	 -- Get Top 20 executed SP's ordered by physical reads (read I/O pressure)
    SELECT TOP 20 qt.text AS 'SP Name', qs.total_physical_reads, qs.total_physical_reads/qs.execution_count AS 'Avg Physical Reads',
    qs.execution_count AS 'Execution Count',
    qs.execution_count/DATEDIFF(Second, qs.creation_time, GetDate()) AS 'Calls/Second',  
    qs.total_worker_time/qs.execution_count AS 'AvgWorkerTime',
    qs.total_worker_time AS 'TotalWorkerTime',
    qs.total_elapsed_time/qs.execution_count AS 'AvgElapsedTime',
    qs.max_logical_reads, qs.max_logical_writes,  
    DATEDIFF(Minute, qs.creation_time, GetDate()) AS 'Age in Cache', qt.dbid 
    FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
    WHERE qt.dbid = db_id() -- Filter by current database
    ORDER BY qs.total_physical_reads DESC


	 -- Get Top 20 executed SP's ordered by logical writes/minute
    SELECT TOP 20 qt.text AS 'SP Name', qs.total_logical_writes, qs.total_logical_writes/qs.execution_count AS 'AvgLogicalWrites',
    qs.total_logical_writes/DATEDIFF(Minute, qs.creation_time, GetDate()) AS 'Logical Writes/Min',  
    qs.execution_count AS 'Execution Count', 
    qs.execution_count/DATEDIFF(Second, qs.creation_time, GetDate()) AS 'Calls/Second', 
    qs.total_worker_time/qs.execution_count AS 'AvgWorkerTime',
    qs.total_worker_time AS 'TotalWorkerTime',
    qs.total_elapsed_time/qs.execution_count AS 'AvgElapsedTime',
    qs.max_logical_reads, qs.max_logical_writes, qs.total_physical_reads, 
    DATEDIFF(Minute, qs.creation_time, GetDate()) AS 'Age in Cache',
    qs.total_physical_reads/qs.execution_count AS 'Avg Physical Reads', qt.dbid
    FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
    WHERE qt.dbid = db_id() -- Filter by current database
    ORDER BY qs.total_logical_writes DESC


