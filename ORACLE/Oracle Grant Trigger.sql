CREATE TABLE SYS.ENBDBA_GRANTS_AUDIT_LOG ( 
     AUDIT_DATE DATE
	,USER_ID NUMBER
	,IP_ADDRESS VARCHAR2(20)
	,HOST VARCHAR2(100)
	,TERMINAL VARCHAR2(100)
	,OS_USER VARCHAR2(100)
	,MODULE VARCHAR2(100)
    ,ACTION_CODE NUMBER /*'1 = GRANT | 2 = REVOKE'*/
    ,PRIVILEGE VARCHAR2(100)
    ,OBJECT_OWNER VARCHAR(20)
    ,OBJECT_NAME VARCHAR2(30)
	,GRANTEE VARCHAR2(100)
) TABLESPACE AUDIT_ARCHIVE;



CREATE OR REPLACE TRIGGER ENBDBA_AFTERGRANT
  AFTER GRANT OR REVOKE ON DATABASE
DECLARE
  PRIV        DBMS_STANDARD.ORA_NAME_LIST_T;
  WHO         DBMS_STANDARD.ORA_NAME_LIST_T;
  NPRIV       PLS_INTEGER;
  NWHO        PLS_INTEGER;
  ACTION_CODE NUMBER;
BEGIN
  NPRIV := ORA_PRIVILEGE_LIST(PRIV);
  IF (ORA_SYSEVENT = 'GRANT') THEN
    ACTION_CODE := 1;
    NWHO        := ORA_GRANTEE(WHO);
  ELSE
    ACTION_CODE := 2;
    NWHO        := ORA_REVOKEE(WHO);
  END IF;
  FOR I IN 1 .. NPRIV LOOP
    FOR J IN 1 .. NWHO LOOP
      INSERT INTO ENBDBA_GRANTS_AUDIT_LOG
      VALUES
        (SYSDATE,
         SYS_CONTEXT('USERENV', 'SESSION_USERID'),
         SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
         SYS_CONTEXT('USERENV', 'HOST'),
         SYS_CONTEXT('USERENV', 'TERMINAL'),
         SYS_CONTEXT('USERENV', 'OS_USER'),
         SYS_CONTEXT('USERENV', 'MODULE'),
         ACTION_CODE,
         PRIV(I),
         ORA_DICT_OBJ_OWNER,
         ORA_DICT_OBJ_NAME,
         WHO(J));
    END LOOP;
  END LOOP;
END;