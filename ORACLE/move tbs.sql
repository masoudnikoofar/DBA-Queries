PURGE DBA_RECYCLEBIN;
SELECT * FROM ENBDBA_TABLESPACES;
SELECT X.OWNER,SUM(X.BYTES)/1024/1024/1024 AS GB FROM DBA_SEGMENTS X 
GROUP BY X.OWNER
ORDER BY 2 DESC;
SELECT * FROM DBA_SEGMENTS X WHERE X.OWNER='BANKSMARKET_DEV_S';

SELECT 'ALTER TABLE ENBDBA.' || OBJECT_NAME ||' MOVE TABLESPACE '||' ENBDBA02; '
FROM ALL_OBJECTS
WHERE OWNER = 'ENBDBA'
AND OBJECT_TYPE = 'TABLE'




SELECT 'ALTER TABLE ' || W.OWNER || '.' || W.SEGMENT_NAME || ' MOVE TABLESPACE TBS_' || W.OWNER || ' PARALLEL;' FROM DBA_SEGMENTS W WHERE W.OWNER='ENPBS' AND SEGMENT_TYPE='TABLE' AND TABLESPACE_NAME='OTHERTBS'
UNION ALL
SELECT 'ALTER INDEX ' || W.OWNER || '.' || W.INDEX_NAME || ' REBUILD TABLESPACE TBS_' || W.OWNER || ' NOLOGGING PARALLEL;' FROM DBA_INDEXES W WHERE W.OWNER='ENPBS' AND W.TABLESPACE_NAME='OTHERTBS';



ALTER TABLE ENPBS.ATTACHMENT MOVE LOB(ATTACHMENT_CONTENT) STORE AS (TABLESPACE TBS_ENPBS);



SELECT 
'ALTER TABLE ' || A.OWNER || '.' || A.TABLE_NAME || ' MOVE LOB(' || A.COLUMN_NAME || ') STORE AS ( TABLESPACE ENPBS );' AS COMMAND
 FROM DBA_LOBS A
WHERE A.OWNER='ENPBS' AND A.TABLESPACE_NAME='OTHERTBS'






ALTER TABLE parts MOVE PARTITION depot2 TABLESPACE ts094 NOLOGGING COMPRESS;