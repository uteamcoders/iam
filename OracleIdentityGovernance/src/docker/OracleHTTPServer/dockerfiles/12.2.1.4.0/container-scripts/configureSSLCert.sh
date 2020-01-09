#!/bin/bash

#*************************************************************************
echo "MW_HOME=${MW_HOME:?"Please set MW_HOME"}"
echo "DOMAIN_NAME=${DOMAIN_NAME:?"Please set DOMAIN_NAME"}"
echo "OHS_COMPONENT_NAME=${OHS_COMPONENT_NAME:?"Please set OHS_COMPONENT_NAME"}"

DOMAIN_HOME=${MW_HOME}/user_projects/domains/${DOMAIN_NAME}
INSTANCE_CONFIG_HOME=$DOMAIN_HOME/config/fmwconfig/components/OHS/instances/${OHS_COMPONENT_NAME}
export INSTANCE_CONFIG_HOME
echo "INSTANCE_CONFIG_DIR=${INSTANCE_CONFIG_HOME}"

INSTANCE_KEYSTORE_HOME=${INSTANCE_CONFIG_HOME}/keystores/idmwallet
export INSTANCE_KEYSTORE_HOME
echo "INSTANCE_KEYSTORE_HOME=${INSTANCE_KEYSTORE_HOME}"
mkdir -p $INSTANCE_KEYSTORE_HOME
if [[ ! -f "${INSTANCE_KEYSTORE_HOME}/idmwallet.txt" ]]; then
    rm -f ${INSTANCE_KEYSTORE_HOME}/*
    cd $INSTANCE_KEYSTORE_HOME
    echo "Marker file to install the IDM SSL certificate, if this file does not exist" > ${INSTANCE_KEYSTORE_HOME}/idmwallet.txt
    /u01/oracle/ohssa/oracle_common/bin/orapki wallet create -wallet ${INSTANCE_KEYSTORE_HOME} -auto_login -pwd $OHS_PASSWORD
    /u01/oracle/ohssa/oracle_common/bin/orapki wallet import_pkcs12 -wallet ${INSTANCE_KEYSTORE_HOME} -pwd $OHS_PASSWORD -pkcs12file $OHS_SSL_CERT -pkcs12pwd $OHS_PASSWORD
fi