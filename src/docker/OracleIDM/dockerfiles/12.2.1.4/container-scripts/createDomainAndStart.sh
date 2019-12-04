#!/bin/bash
set -x
#
#
# Copyright (c) 2014-2017 Oracle and/or its affiliates. All rights reserved.
#
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

export DOMAIN_NAME=${DOMAIN_NAME:-idm_domain}
export DOMAIN_ROOT=${DOMAIN_ROOT:-/u01/oracle/user_projects/domains}
export DOMAIN_HOME=${DOMAIN_ROOT}/${DOMAIN_NAME}

#==================================================
function _int() {
  echo "INFO: Stopping container."
  echo "INFO:   SIGINT received, shutting down Admin Server!"
  /u01/oracle/user_projects/domains/idm_domain/bin/stopWebLogic.sh
  exit;
}

#==================================================
function _term() {
  echo "INFO: Stopping container."
  echo "INFO:   SIGTERM received, shutting down Admin Server!"
  /u01/oracle/user_projects/domains/idm_domain/bin/stopWebLogic.sh
  exit;
}

#==================================================
function _kill() {
  echo "INFO: SIGKILL received, shutting down Admin Server!"
  /u01/oracle/user_projects/domains/idm_domain/bin/stopWebLogic.sh
  exit;
}

#==================================================
function rand_pwd(){
  while true; do
    s=$(cat /dev/urandom | tr -dc "A-Za-z0-9" | fold -w 8 | head -n 1)
    if [[ ${#s} -ge 8 && "$s" = *[A-Z]* && "$s" = *[a-z]* && "$s" = *[0-9]*  ]]
    then
      break
    else
      echo "INFO: Password does not Match the criteria, re-generating..." >&2
    fi
  done
  echo "${s}" 
}

#==================================================
setupRCU() {
  dbType=`echo ${CONNECTION_STRING} | cut -d "/" -f2`
  scrName=/u01/oracle/oracle_common/common/sql/iau/scripts/creAuditTabs.sql

  if [ ! -s "${scrName}.orig" ]; then
    echo "INFO: Copying RCU backup file"
    cp ${scrName} ${scrName}.orig
  fi

  if [ "${dbType}" = "XE" -o "${dbType}" = "xe" ]; then
    echo "INFO: Setting RCU for XE"
    sed -e "s/^@@prepareAuditView.sql/-- @@prepareAuditView.sql/g" ${scrName}.orig > ${scrName}
  else
    echo "INFO: Setting RCU for ORCL"
    cp ${scrName}.orig ${scrName}    
  fi
}

#==================================================
updateListenAddress() {
  mkdir -p ${DOMAIN_HOME}/logs

  export thehost=`hostname -I`
  echo "INFO: Updating the listen address - ${thehost} ${ADMIN_HOST}"
  cmd="/u01/oracle/oracle_common/common/bin/wlst.sh -skipWLSModuleScanning /u01/oracle/dockertools/updListenAddress.py $vol_name ${thehost} AdminServer ${ADMIN_HOST}"
  echo ${cmd}
  ${cmd} > ${DOMAIN_HOME}/logs/aslisten.log 2>&1
}

#==================================================
#== MAIN starts here...
#==================================================
trap _int SIGINT
trap _term SIGTERM
trap _kill SIGKILL

echo "INFO: CONNECTION_STRING = ${CONNECTION_STRING:?"Please set CONNECTION_STRING"}"
echo "INFO: RCUPREFIX         = ${RCUPREFIX:?"Please set RCUPREFIX"}"

if [ -z ${DB_PASSWORD} ]
then
  echo ""
  echo "FATAL: DB System password is empty. Exiting..."
  exit 1
fi;

if [ -z ${ADMIN_PASSWORD} ]
then
  # Auto generate Oracle WebLogic Server admin password
  ADMIN_PASSWORD=$(rand_pwd)
  echo ""
  echo "INFO: Oracle WebLogic Server Password Auto Generated :"
  echo "  'weblogic' admin password: $ADMIN_PASSWORD"
  echo ""
fi;

if [ -z ${DB_SCHEMA_PASSWORD} ]
then
  DB_SCHEMA_PASSWORD=${DB_PASSWORD}
  echo ""
  echo "INFO: Database Schema password :"
  echo "  Database schema password: $DB_SCHEMA_PASSWORD"
  echo ""
fi

export jdbc_url="jdbc:oracle:thin:@"$CONNECTION_STRING
export vol_name=u01

echo -e $DB_PASSWORD"\n"$DB_SCHEMA_PASSWORD > /tmp/pwd.txt

INSTALL_DOMAIN_DIR=/$vol_name/oracle/user_projects/domains/install_${DOMAIN_NAME}

#
# Creating schemas needed for sample domain ####
#===============================================
#
RUN_RCU="true"
CONFIGURE_DOMAIN="true"

if [ -d  $INSTALL_DOMAIN_DIR ] 
then
  # First load the Env Data from the env file... 
  if [ -e $INSTALL_DOMAIN_DIR/contenv.sh ] 
  then
    . $INSTALL_DOMAIN_DIR/contenv.sh
    #reset the JDBC URL
    export jdbc_url="jdbc:oracle:thin:@"$CONNECTION_STRING
  fi
else
  mkdir -p $INSTALL_DOMAIN_DIR
fi

if [ -e $INSTALL_DOMAIN_DIR/RCU.$RCUPREFIX.suc ] 
then
    #RCU has already been executed successfully, no need to rerun
    RUN_RCU="false"
    echo "INFO: IDM RCU has already been loaded. Skipping..."
fi

if [ "$RUN_RCU" = "true" ] 
then
  setupRCU
  # Run the RCU.. it hasnt been loaded before. If it has
  # then drop the prefix and restart. New Domain creation
  # scenario
  echo "INFO: Dropping Schema $RCUPREFIX..."
  /$vol_name/oracle/oracle_common/bin/rcu -silent -dropRepository -databaseType ORACLE -connectString $CONNECTION_STRING -dbUser sys -dbRole sysdba -selectDependentsForComponents true -schemaPrefix $RCUPREFIX -component STB -component OPSS -component SOAINFRA -component OIM -component UCSUMS -component OAM -component IAU -component IAU_APPEND -component IAU_VIEWER -component MDS -component WLS -f < /tmp/pwd.txt
	
  echo "INFO: Creating Schema $RCUPREFIX..."
  /$vol_name/oracle/oracle_common/bin/rcu -silent -createRepository -databaseType ORACLE -connectString $CONNECTION_STRING -dbUser sys -dbRole sysdba -useSamePasswordForAllSchemaUsers true -selectDependentsForComponents true -variables SOA_PROFILE_TYPE=SMALL,HEALTHCARE_INTEGRATION=NO -schemaPrefix $RCUPREFIX -component STB -component OPSS -component SOAINFRA -component OIM -component UCSUMS -component OAM -component IAU -component IAU_APPEND -component IAU_VIEWER -component MDS -component WLS -f < /tmp/pwd.txt
  retval=$?

  if [ $retval -ne 0 ]; 
  then
    echo "ERROR: RCU Loading Failed. Check the RCU logs"
    exit
  else
    # Write the rcu suc file... 
    touch $INSTALL_DOMAIN_DIR/RCU.$RCUPREFIX.suc
    	
    # Write the env file.. such that the passwords etc.. will be saved and we will 
    # be able to restart from the RCU
    cat > $INSTALL_DOMAIN_DIR/contenv.sh <<EOF
CONNECTION_STRING=$CONNECTION_STRING
RCUPREFIX=$RCUPREFIX
ADMIN_PASSWORD=$ADMIN_PASSWORD
DB_PASSWORD=$DB_PASSWORD
DB_SCHEMA_PASSWORD=$DB_SCHEMA_PASSWORD
vol_name=$vol_name
EOF
  fi
fi

rm -f "/tmp/pwd.txt"
    
#
# Configuration of IDM domain
#=============================
if [ -e $INSTALL_DOMAIN_DIR/IDM.DOMAINCFG.suc ] 
then
  CONFIGURE_DOMAIN="false"
  echo "INFO: Domain Already configured. Skipping..."
fi

if [ "$CONFIGURE_DOMAIN" = "true" ] 
then
  export CONFIG_JVM_ARGS=-DSchemaTypeSystemName=TrustServiceIdentityAsserter
  $ORACLE_HOME/oracle_common/common/bin/prepareCustomProvider.sh -mjf=$ORACLE_HOME/oracle_common/modules/oracle.jps/jps-wls-trustprovider.jar -out $ORACLE_HOME/oracle_common/lib/schematypes/jps-wls-trustprovider.schema.jar
#  Enable this somehow later to create clusters
#  cfgCmd="/u01/weblogic-deploy/bin/createDomain.sh \
#        -oracle_home $ORACLE_HOME \
#        -java_home $JAVA_HOME \
#        -domain_home $DOMAIN_HOME \
#        -domain_type OIM \
#        -model_file /u01/IdmDomain.yaml \
#        -variable_file  /u01/IdmDomain.properties \
#        -archive_file /u01/IdmDomain.zip"
  cfgCmd=/u01/oracle/dockertools/runSetupScripts.sh
  ${cfgCmd}
  retval=$?
  if [ $retval -ne 0 ];
  then
    echo "ERROR: Domain Configuration failed. Please check the logs"
    exit
  else
    # https://docs.oracle.com/en/middleware/fusion-middleware/12.2.1.4/inoam/configuring-oracle-identity-governance-domain.html#GUID-D97A8D45-C3FD-49DB-BCF5-4372E37BE94F
    cd $ORACLE_HOME/idm/server/bin && ./offlineConfigManager.sh
    updateListenAddress
    # Write the Domain suc file... 
    touch $INSTALL_DOMAIN_DIR/IDM.DOMAINCFG.suc
    echo ${cfgCmd} >> $INSTALL_DOMAIN_DIR/IDM.DOMAINCFG.suc

    cat > $INSTALL_DOMAIN_DIR/contenv.sh <<EOF
CONNECTION_STRING=$CONNECTION_STRING
RCUPREFIX=$RCUPREFIX
ADMIN_PASSWORD=$ADMIN_PASSWORD
DB_PASSWORD=$DB_PASSWORD
DB_SCHEMA_PASSWORD=$DB_SCHEMA_PASSWORD
vol_name=$vol_name
EOF
  fi
fi

#
# Creating domain env file
#=========================
mkdir -p $DOMAIN_HOME/servers/AdminServer/security $DOMAIN_HOME/servers/${MANAGED_SERVER}/security

#
# Password less Adminserver starting
#===================================
echo "username=weblogic" > $DOMAIN_HOME/servers/AdminServer/security/boot.properties
echo "password="$ADMIN_PASSWORD >> $DOMAIN_HOME/servers/AdminServer/security/boot.properties

#
# Password less Managed Server starting
#======================================
echo "username=weblogic" > $DOMAIN_HOME/servers/${MANAGED_SERVER}/security/boot.properties
echo "password="$ADMIN_PASSWORD >> $DOMAIN_HOME/servers/${MANAGED_SERVER}/security/boot.properties

#
# Setting env variables
#=======================
echo ". $DOMAIN_HOME/bin/setDomainEnv.sh" >> /u01/oracle/.bashrc
echo "export PATH=$PATH:/u01/oracle/common/bin:$DOMAIN_HOME/bin" >> /u01/oracle/.bashrc

# Now we start the Admin server in this container... 
/u01/oracle/dockertools/startAS.sh

sleep infinity
