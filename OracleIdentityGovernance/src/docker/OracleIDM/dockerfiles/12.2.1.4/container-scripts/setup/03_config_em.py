#!/usr/bin/python

import os, sys

try:
    WL_HOME = "###MW_HOME###/wlserver"
    DOMAIN_HOME = "###DOMAIN_HOME###"
    ORACLE_HOME = "###MW_HOME###/idm"
    if DOMAIN_HOME is None:
        sys.exit("Error: Please set the environment variable DOMAIN_HOME")
    if WL_HOME is None:
        sys.exit("Error: Please set the environment variable WL_HOME")
    if ORACLE_HOME is None:
        sys.exit("Error: Please set the environment variable ORACLE_HOME")
except (KeyError), why:
    sys.exit("Error: Missing Environment Variables " + str(why))
readDomain(r'###DOMAIN_HOME###')
selectTemplate('Oracle Enterprise Manager')
loadTemplates()
showTemplates()
dumpStack()
cd('/JdbcSystemResource/WLSSchemaDataSource/JdbcResource/WLSSchemaDataSource/JdbcDriverParams/NO_NAME')
cmo.setUrl('jdbc:oracle:thin:@###CONNECTION_STRING###')
cmo.setDriverName('oracle.jdbc.OracleDriver')
set('PasswordEncrypted', '###DB_SCHEMA_PASSWORD###')
cd('Properties/NO_NAME/Property/user')
cmo.setValue('###RCUPREFIX###_WLS')
cd('/JdbcSystemResource/opss-data-source/JdbcResource/opss-data-source/JdbcDriverParams/NO_NAME')
cmo.setUrl('jdbc:oracle:thin:@###CONNECTION_STRING###')
cmo.setDriverName('oracle.jdbc.OracleDriver')
set('PasswordEncrypted', '###DB_SCHEMA_PASSWORD###')
cd('Properties/NO_NAME/Property/user')
cmo.setValue('###RCUPREFIX###_OPSS')
cd('/JdbcSystemResource/opss-audit-DBDS/JdbcResource/opss-audit-DBDS/JdbcDriverParams/NO_NAME')
cmo.setUrl('jdbc:oracle:thin:@###CONNECTION_STRING###')
cmo.setDriverName('oracle.jdbc.OracleDriver')
set('PasswordEncrypted', '###DB_SCHEMA_PASSWORD###')
cd('Properties/NO_NAME/Property/user')
cmo.setValue('###RCUPREFIX###_IAU_APPEND')
cd('/JdbcSystemResource/opss-audit-viewDS/JdbcResource/opss-audit-viewDS/JdbcDriverParams/NO_NAME')
cmo.setUrl('jdbc:oracle:thin:@###CONNECTION_STRING###')
cmo.setDriverName('oracle.jdbc.OracleDriver')
set('PasswordEncrypted', '###DB_SCHEMA_PASSWORD###')
cd('Properties/NO_NAME/Property/user')
cmo.setValue('###RCUPREFIX###_IAU_VIEWER')
cd('/JdbcSystemResource/LocalSvcTblDataSource/JdbcResource/LocalSvcTblDataSource/JdbcDriverParams/NO_NAME')
cmo.setUrl('jdbc:oracle:thin:@###CONNECTION_STRING###')
cmo.setDriverName('oracle.jdbc.OracleDriver')
set('PasswordEncrypted', '###DB_SCHEMA_PASSWORD###')
cd('Properties/NO_NAME/Property/user')
cmo.setValue('###RCUPREFIX###_STB')
updateDomain()
closeDomain()
exit()
