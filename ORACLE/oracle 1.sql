select * from v$dispatcher;
select * from v$fixed_table;
select * from v$instance;
select * from v$circuit;
select * from dba_tablespaces;
select * from dba_data_files;
select * from dba_temp_files;
select * from dba_tables t where t.owner='TF_DEVINT';
select * from dba_free_space;
select sum(t.bytes)/1024/1024 as size_mb,t.tablespace_name from dba_free_space t group by t.tablespace_name;
select * from dba_users t where t.account_status='OPEN';
select * from sys.user$;
select * from v$lock;
select * from v$session;
select t.SID,t.SERIAL#,t.BLOCKING_SESSION,t.BLOCKING_INSTANCE,t.BLOCKING_SESSION_STATUS from v$session t;
select * from aud$;
select * from dba_audit_trail where username='SYS';
select * from v$sysstat t;-- where t.NAME like '%sort%';
select * from v$sesstat a, v$statname b where a.STATISTIC#=b.STATISTIC#;
select * from v$event_name;
select * from v$system_event;
select * from v$session_event;
select * from v$service_event;
select * from dba_objects t where t.status='INVALID';
select * from dba_indexes t;-- where t.status='INVALID';
select * from v$instance_recovery;
select * from v$controlfile;
select * from v$logfile;
select * from v$log;
--alter system switch logfile;
select * from V$ir_Failure;
select * from v$ir_manual_checklist;
select * from v$ir_repair;

select * from v$pwfile_users;
select resource_name,liMit from dba_profiles where profile='DEFAULT';
select * from V$BACKUP_CORRUPTION;
select * from dba_views