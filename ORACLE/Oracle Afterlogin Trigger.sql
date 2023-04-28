CREATE TABLESPACE AUDIT_ARCHIVE DATAFILE SIZE 100M AUTOEXTEND ON MAXSIZE UNLIMITED;
CREATE TABLE SYS.ENBDBA_USERS (USER_ID NUMBER,USERNAME VARCHAR2(30),IS_LIMITED VARCHAR2(3),IS_LOGGED VARCHAR2(3)) TABLESPACE AUDIT_ARCHIVE;

CREATE TABLE SYS.ENBDBA_USERS_LIMITS (USER_ID NUMBER,IP_ADDRESS VARCHAR2(20),
HOST VARCHAR2(100),
TERMINAL VARCHAR2(100),
OS_USER VARCHAR2(100),
MODULE VARCHAR2(100))  TABLESPACE AUDIT_ARCHIVE;


CREATE TABLE SYS.ENBDBA_USERS_LIMITS_LOG (USER_ID NUMBER,IP_ADDRESS VARCHAR2(20),
HOST VARCHAR2(100),
TERMINAL VARCHAR2(100),
OS_USER VARCHAR2(100),
MODULE VARCHAR2(100),
LOGIN_DATE DATE)  TABLESPACE AUDIT_ARCHIVE;



----------------------------------------------------




CREATE OR REPLACE TRIGGER ENBDBA_AFTERLOGON
  AFTER LOGON ON DATABASE
DECLARE
  IS_ALLOWED BOOLEAN := TRUE;
  IS_LOGGED  BOOLEAN := TRUE;
  ROW_COUNT  NUMBER := 0;
BEGIN
  SELECT COUNT(*)
    INTO ROW_COUNT
    FROM SYS.ENBDBA_USERS X
   WHERE X.USER_ID = SYS_CONTEXT('USERENV', 'SESSION_USERID')
     AND X.IS_LIMITED = 'YES';
  IF ROW_COUNT > 0 THEN
    SELECT COUNT(*)
      INTO ROW_COUNT
      FROM SYS.ENBDBA_USERS_LIMITS X
     WHERE X.USER_ID = SYS_CONTEXT('USERENV', 'SESSION_USERID')
       AND (X.IP_ADDRESS IN (SYS_CONTEXT('USERENV', 'IP_ADDRESS'), 'ALL'))
       AND (X.HOST IN (SYS_CONTEXT('USERENV', 'HOST'), 'ALL'))
       AND (X.TERMINAL IN (SYS_CONTEXT('USERENV', 'TERMINAL'), 'ALL'))
       AND (X.OS_USER IN (SYS_CONTEXT('USERENV', 'OS_USER'), 'ALL'))
       AND (X.MODULE IN (SYS_CONTEXT('USERENV', 'MODULE'), 'ALL'));
    IF ROW_COUNT < 1 THEN
      INSERT INTO SYS.ENBDBA_USERS_LIMITS_LOG
      VALUES
        (SYS_CONTEXT('USERENV', 'SESSION_USERID'),
         SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
         SYS_CONTEXT('USERENV', 'HOST'),         
         SYS_CONTEXT('USERENV', 'TERMINAL'),
         SYS_CONTEXT('USERENV', 'OS_USER'),
         SYS_CONTEXT('USERENV', 'MODULE'),
         SYSDATE);
      COMMIT;
      RAISE_APPLICATION_ERROR(-20001, 'NOT ALLOWED');
    END IF;
  END IF;
  SELECT COUNT(*)
    INTO ROW_COUNT
    FROM SYS.ENBDBA_USERS X
   WHERE X.USER_ID = SYS_CONTEXT('USERENV', 'SESSION_USERID')
     AND X.IS_LOGGED = 'YES';
  IF ROW_COUNT > 0 THEN 
     INSERT INTO SYS.ENBDBA_USERS_LIMITS_LOG
      VALUES
        (SYS_CONTEXT('USERENV', 'SESSION_USERID'),
         SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
         SYS_CONTEXT('USERENV', 'HOST'),         
         SYS_CONTEXT('USERENV', 'TERMINAL'),
         SYS_CONTEXT('USERENV', 'OS_USER'),
         SYS_CONTEXT('USERENV', 'MODULE'),
         SYSDATE);
      COMMIT;
  END IF;
END;