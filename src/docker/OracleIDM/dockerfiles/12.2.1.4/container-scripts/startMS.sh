#!/bin/bash
#
#
#
# Copyright (c) 2016-2017 Oracle and/or its affiliates. All rights reserved.
#
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

# Author:nevin.cleetus@oracle.com

export DOMAIN_NAME=${DOMAIN_NAME:-idm_domain}
export DOMAIN_ROOT=${DOMAIN_ROOT:-/u01/oracle/user_projects/domains}
export DOMAIN_HOME=${DOMAIN_ROOT}/${DOMAIN_NAME}

#=================================================================
function _int() {
   echo "INFO: Stopping container."
   echo "INFO: SIGINT received, shutting down Managed Server!"
   $DOMAIN_HOME/bin/stopManagedWebLogic.sh ${MANAGED_SERVER} "http://"${ADMIN_HOST}:${ADMIN_PORT}
   exit;
}

#=================================================================
function _term() {
   echo "INFO: Stopping container."
   echo "INFO: SIGTERM received, shutting down Managed Server!"
   $DOMAIN_HOME/bin/stopManagedWebLogic.sh ${MANAGED_SERVER} "http://"${ADMIN_HOST}:${ADMIN_PORT}
   exit;
}

#=================================================================
function _kill() {
   echo "INFO: SIGKILL received, shutting down Managed Server!"
   $DOMAIN_HOME/bin/stopManagedWebLogic.sh ${MANAGED_SERVER} "http://"${ADMIN_HOST}:${ADMIN_PORT}
   exit;
}

#=================================================================
#== MAIN Starts here...
#=================================================================
trap _int SIGINT
trap _term SIGTERM
trap _kill SIGKILL

export vol_name=u01

grepPat="SOA Platform is running and accepting requests"


LOGDIR=${DOMAIN_HOME}/logs
LOGFILE=${LOGDIR}/${MANAGED_SERVER}.log
mkdir -p ${LOGDIR}

export thehost=`hostname -I`
echo "INFO: Updating the listen address - ${thehost} ${ADMIN_HOST}"
/u01/oracle/oracle_common/common/bin/wlst.sh -skipWLSModuleScanning /u01/oracle/dockertools/updListenAddress.py $vol_name $thehost ${MANAGED_SERVER} ${ADMIN_HOST} > ${LOGDIR}/mslisten.log 2>&1

# Start SOA server
echo "INFO: Starting the managed server ${MANAGED_SERVER}"
$DOMAIN_HOME/bin/startManagedWebLogic.sh ${MANAGED_SERVER} "http://"${ADMIN_HOST}:${ADMIN_PORT} > ${LOGFILE} 2>&1 &
# tail Managed Server log
tail -f ${LOGFILE} &

childPID=$!
wait $childPID
