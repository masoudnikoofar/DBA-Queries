SELECT SU.NAME,
       'ALTER USER ' || SU.NAME || ' IDENTIFIED BY VALUES ' || ' ''' || SPARE4 || ';' || SU.PASSWORD || ''';' AS CMD
  FROM SYS.USER$ SU
  JOIN DBA_USERS DU
    ON ACCOUNT_STATUS LIKE 'EXPIRED%'
   AND SU.NAME = DU.USERNAME
   and du.username='JURIDICAL_CONNECTIONS'
   ORDER BY 1;