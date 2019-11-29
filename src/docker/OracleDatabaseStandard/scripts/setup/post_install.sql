-- pdbadmin/MyPasswd123@//idm.iplusplus.dev:1527/PDB1.localdomain
-- -v [<host mount point>:]/u01/app/oracle/oradata \
-- sudo docker exec  -it template-orcl /u01/app/oracle/product/12.1.0/dbhome_1/bin/sqlplus pdbadmin/MyPasswd123@//idm.iplusplus.dev:1527/PDB1.localdomain
-- sudo docker run -d --env-file idm/src/docker/OracleDatabaseStandard/template_db_env.properties -p 1527:1521 -p 5507:5500 -it --name template-orcl -v /home/oracle/oradata:/u01/app/oracle/oradata --shm-size="8g" container-registry.oracle.com/database/standard:12.1.0.2
-- sudo docker exec  -it template-orcl /u01/app/oracle/product/12.1.0/dbhome_1/bin/sqlplus sys/MyPasswd123@orcl as sysdba
alter system set open_cursors = 1000;
grant select on v$xatrans$ to public;
grant select on pending_trans$ to public;
grant select on dba_2pc_pending to public;
grant select on dba_pending_transactions to public;
grant execute on dbms_xa to public;