SELECT SUM(LinesOfCode)
FROM(
SELECT LEN(definition)- LEN(REPLACE(definition,CHAR(10),'')) AS LinesOfCode,
OBJECT_NAME(OBJECT_ID) AS  NameOfObject
 FROM sys.all_sql_modules a
JOIN sysobjects  s ON a.object_id = s.id
AND xtype IN('TR','P','FN','IF','TF')
WHERE OBJECTPROPERTY(OBJECT_ID,'IsMSShipped') =0) x