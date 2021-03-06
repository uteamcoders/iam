#!/bin/bash
set -x
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

LOGDIR=${DOMAIN_HOME}/logs
LOGFILE=${LOGDIR}/${MANAGED_SERVER}.log
mkdir -p ${LOGDIR}
cp /u01/uteamcoders-idm.png /u01/oracle/idm/server/apps/oim.ear/iam-consoles-faces.war/images/uteamcoders-idm.png

# Start Managed server
echo "INFO: Starting the managed server ${MANAGED_SERVER}"
$DOMAIN_HOME/bin/startManagedWebLogic.sh ${MANAGED_SERVER} "http://"${ADMIN_HOST}:${ADMIN_PORT} > ${LOGFILE} 2>&1 &
# tail Managed Server log
tail -F ${DOMAIN_HOME}/servers/${MANAGED_SERVER}/logs/${MANAGED_SERVER}.log &

childPID=$!
wait $childPID
