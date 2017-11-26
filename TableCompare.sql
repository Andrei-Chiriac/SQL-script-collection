--let's copy over 20 rows to a table named authors2
SELECT TOP 20 * INTO tempdb..authors2
FROM pubs..authors
 
--update 5 records by appending X to the au_fname
SET ROWCOUNT 5
 
 
UPDATE tempdb..authors2
SET au_fname =au_fname +'X'
 
 
--Set rowcount back to 0
SET ROWCOUNT 0
 
--let's insert a row that doesn't exist in pubs
INSERT INTO tempdb..authors2
SELECT '666-66-6666', au_lname, au_fname, phone, address, city, state, zip, contract
FROM tempdb..authors2
WHERE au_id ='172-32-1176'
 
--*** The BIG SELECT QUERY --***
 
--Not in Pubs
SELECT 'Does Not Exist On Production',t2.au_id
FROM pubs..authors t1
RIGHT JOIN tempdb..authors2 t2 ON t1.au_id =t2.au_id
WHERE t1.au_id IS NULL
UNION ALL
--Not in Temp
SELECT 'Does Not Exist In Staging',t1.au_id
FROM pubs..authors t1
LEFT JOIN tempdb..authors2 t2 ON t1.au_id =t2.au_id
WHERE t2.au_id IS NULL
UNION ALL
--Data Mismatch
SELECT 'Data Mismatch', t1.au_id
FROM( SELECT BINARY_CHECKSUM(*) AS CheckSum1 ,au_id FROM pubs..authors) t1
JOIN(SELECT BINARY_CHECKSUM(*) AS CheckSum2,au_id FROM tempdb..authors2) t2 ON t1.au_id =t2.au_id
WHERE CheckSum1 <> CheckSum2
 
--Clean up
DROP TABLE tempdb..authors2
GO


--OR

SELECT CASE WHEN t1.au_id IS NULL
AND t2.au_id IS NOT NULL
THEN 'Does Not Exist On Production'
WHEN t1.au_id IS NOT NULL
AND t2.au_id IS NULL
THEN 'Does Not Exist In Staging'
ELSE 'Data Mismatch' END,
COALESCE(t1.au_id, t2.au_id) AS au_id
FROM (SELECT *, BINARY_CHECKSUM(*) AS bc FROM pubs..authors) AS t1
FULL OUTER JOIN (SELECT *, BINARY_CHECKSUM(*) AS bc FROM tempdb..authors2) AS t2
ON t1.au_id =t2.au_id
WHERE t1.au_id IS NULL
OR t2.au_id IS NULL
OR t1.bc <> t2.bc