#!/bin/bash
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2018 Oracle and/or its affiliates. All rights reserved.
#
# Since: July, 2017
# Author: gerald.venzl@oracle.com
# Description: Runs user shell and SQL scripts
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 
set -x

SCRIPTS_ROOT="/u01/oracle/dockertools/setup";

# Check whether parameter has been passed on
if [ -z "$SCRIPTS_ROOT" ]; then
   echo "$0: No SCRIPTS_ROOT passed on, no scripts will be run";
   exit 1;
fi;

# Execute custom provided files (only if directory exists and has files in it)
if [ -d "$SCRIPTS_ROOT" ] && [ -n "$(ls -A $SCRIPTS_ROOT)" ]; then

  echo "";
  echo "Executing IDM scripts as in Performing a Silent Config of the OIG 12c Domain (Doc ID 2465751.1)"

  for f in $SCRIPTS_ROOT/*; do
      /u01/oracle/dockertools/replace_vars.sh "$f"
      case "$f" in
          *.sh)     echo "$0: running $f"; . "$f" ;;
          *.py)    echo "$0: running $f"; echo "exit" | $ORACLE_HOME/oracle_common/common/bin/wlst.sh "$f"; echo ;;
          *)        echo "$0: ignoring $f" ;;
      esac
      echo "";
  done
  
  echo "DONE: Executing user defined scripts"
  echo "";

fi;