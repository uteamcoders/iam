#
# Copyright (c) 2016-2017 Oracle and/or its affiliates. All rights reserved.
#
# Licensed under the Universal Permissive License v 1.0 as shown at 
# http://oss.oracle.com/licenses/upl.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle IDM
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# See idm.download file in the install directory
#
# Pull base image
# ---------------
FROM store/oracle/serverjre:8 as builder

# Maintainer
# ----------
MAINTAINER Monica Riccelli <monica.riccelli@oracle.com>


# Common environment variables required for this build
# ----------------------------------------------------
ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    PATH=$PATH:${JAVA_HOME}/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin

# Setup subdirectory for FMW install package and container-scripts
# -----------------------------------------------------------------
RUN mkdir -p /u01 && \
    chmod a+xr /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
## Copy packages
## -------------
# COPY install.file oraInst.loc /u01/
RUN chown oracle:oracle -R /u01

# Install
# ------------------------------------------------------------
USER oracle
#RUN cd /u01 && $JAVA_HOME/bin/jar xf /u01/$FMW_PKG && cd - && \
#    $JAVA_HOME/bin/java -jar /u01/$FMW_JAR -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server" && \
#    rm /u01/$FMW_JAR /u01/$FMW_PKG /u01/oraInst.loc /u01/install.file && \
#    rm -rf /u01/oracle/cfgtoollogs

# Final image stage
FROM store/oracle/serverjre:8
ENV ORACLE_HOME=/u01/oracle \
    VOLUME_DIR=/u01/oracle/user_projects \
    SCRIPT_FILE=/u01/oracle/container-scripts/* \
    DOMAIN_NAME="${DOMAIN_NAME:-idm_domain}" \
    ADMIN_NAME="${ADMIN_NAME:-AdminServer}" \
    ADMIN_HOST="${ADMIN_HOST:-idmas}" \
    ADMINISTRATION_PORT_ENABLED="${ADMINISTRATION_PORT_ENABLED:-false}" \
    ADMINISTRATION_PORT="${ADMINISTRATION_PORT:-9002}" \
    RCUPREFIX="${RCUPREFIX}" \
    PRODUCTION_MODE="${PRODUCTION_MODE:-prod}" \
    CONNECTION_STRING=${CONNECTION_STRING} \
    JAVA_OPTIONS="-Doracle.jdbc.fanEnabled=false -Dweblogic.StdoutDebugEnabled=false" \
    PATH=$PATH:/usr/java/default/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle/container-scripts

RUN mkdir -p /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle && \
    chmod a+xr /u01 && chown oracle:oracle /u01 && \
    mkdir -p $VOLUME_DIR && chown oracle:oracle /u01 $VOLUME_DIR && \
    mkdir -p /u01/oracle/container-scripts && \
    yum install -y libaio && \
    yum install -y unzip && \
    rm -rf /var/cache/yum


# Copy packages and scripts
# -------------------------
COPY container-scripts/* /u01/oracle/container-scripts/

COPY --from=builder --chown=oracle:oracle /u01 /u01
RUN chmod +xr $SCRIPT_FILE

#
# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
USER root
ENV DISTR_DIR=distr \
    FMW_JAR1=fmw_12.2.1.4.0_idmquickstart.jar \
    FMW_JAR2=fmw_12.2.1.4.0_idmquickstart2.jar

#
# Copy files and packages for install
# -----------------------------------
ADD  $DISTR_DIR/$FMW_JAR1 $DISTR_DIR/$FMW_JAR2 /u01/
COPY container-scripts/* /u01/oracle/dockertools/
RUN  yum install -y hostname &&    \
     rm -rf /var/cache/yum &&      \
     cd /u01 && chmod 755 *.jar && \
     chmod a+xr /u01/oracle/dockertools/*.*
#
USER oracle
COPY install/* /u01/
RUN cd /u01 && curl https://github.com/oracle/weblogic-deploy-tooling/releases/download/weblogic-deploy-tooling-1.6.0/weblogic-deploy.zip -L -o /u01/weblogic-deploy.zip && \
    unzip /u01/weblogic-deploy.zip && cd /u01/weblogic-deploy

RUN cd /u01 && \
  $JAVA_HOME/bin/java -jar /u01/$FMW_JAR1 -silent -responseFile /u01/idm.12.2.1.4.response -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME && \
  rm -fr /u01/*.jar /u01/*.response /u01/*.loc && \
  find /u01/ -type f -iname "*.sh" -exec chmod +x {} \;

#
# Define default command to start bash.
#
WORKDIR $ORACLE_HOME
CMD ["/u01/oracle/dockertools/createDomainAndStart.sh"]


# weblogic-deploy/bin/discoverDomain.sh -oracle_home /home/ivasi/Oracle/Middleware/Oracle_Home -domain_home /home/ivasi/Oracle/Middleware/Oracle_Home/user_projects/domains/idm_domain -archive_file IdmDomain.zip -model_file IdmDomain.yaml