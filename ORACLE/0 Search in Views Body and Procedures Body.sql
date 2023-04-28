SELECT * FROM DBA_SOURCE X WHERE UPPER(X.TEXT) LIKE '%IN_CUSTOMER_DATA%';



DECLARE
  L_SEARCH VARCHAR2(1000) := UPPER('IN_CUSTOMER_DATA');
  L_CHAR VARCHAR2(32767);
BEGIN
  FOR REC IN (SELECT * FROM ALL_VIEWS WHERE TEXT_LENGTH < 32767 ORDER BY OWNER,VIEW_NAME)
  LOOP
    L_CHAR := UPPER(REC.TEXT);
    IF (INSTR(L_CHAR, L_SEARCH) > 0) THEN
      DBMS_OUTPUT.PUT_LINE('' || REC.OWNER || '.' || REC.VIEW_NAME);
    END IF;
  END LOOP;
END;


