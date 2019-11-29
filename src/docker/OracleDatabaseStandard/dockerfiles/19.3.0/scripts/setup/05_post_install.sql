-- sudo docker exec  -it template-orcl /opt/oracle/setPassword.sh MyPasswd123
--  sudo docker exec  -it template-orcl /opt/oracle/product/19c/dbhome_1/bin/sqlplus system/MyPasswd123@//localhost:1521/ORCLPDB1
-- sudo docker run -d -p 1527:1521 -p 5507:5500 -it --name template-orcl -v /home/oracle/oradata:/opt/oracle/oradata -v /home/oracle/scripts/setup:/docker-entrypoint-initdb.d/setup --shm-size="8g" oracle/idm/database:19.3.0-se2
-- sqlplus system/MyPasswd123@//idm.iplusplus.dev:1527/ORCLPDB1
grant select on v$xatrans$ to public;
grant select on pending_trans$ to public;
grant select on dba_2pc_pending to public;
grant select on dba_pending_transactions to public;
grant execute on dbms_xa to public;
GRANT SELECT ON v$xatrans$ TO system WITH GRANT OPTION;
GRANT SELECT ON pending_trans$ TO system WITH GRANT OPTION;
GRANT SELECT ON dba_2pc_pending TO system WITH GRANT OPTION;
GRANT SELECT ON dba_pending_transactions TO system WITH GRANT OPTION;
GRANT SELECT ON v_$session TO system;
GRANT EXECUTE ON sys.dbms_system TO system WITH GRANT OPTION;
GRANT EXECUTE ON SYS.DBMS_FLASHBACK TO system WITH GRANT OPTION;
GRANT EXECUTE ON sys.DBMS_SHARED_POOL TO system WITH GRANT OPTION;
GRANT EXECUTE ON DBMS_SCHEDULER TO system WITH GRANT OPTION;

alter system set open_cursors = 1000;