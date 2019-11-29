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

SCRIPTS_ROOT="$1";

# Check whether parameter has been passed on
if [ -z "$SCRIPTS_ROOT" ]; then
   echo "$0: No SCRIPTS_ROOT passed on, no scripts will be run";
   exit 1;
fi;

# Execute custom provided files (only if directory exists and has files in it)
if [ -d "$SCRIPTS_ROOT" ] && [ -n "$(ls -A $SCRIPTS_ROOT)" ]; then

  echo "";
  echo "Executing IDM scripts as in https://docs.oracle.com/en/middleware/fusion-middleware/12.2.1.3/sysrs/system-requirements-and-specifications.html#GUID-0CFB01B2-2571-41C7-8553-4046D91E3C38"

  for f in $SCRIPTS_ROOT/*; do
      case "$f" in
          *.sh)     echo "$0: running $f"; . "$f" ;;
          *.sql)    echo "$0: running $f"; echo "exit" | $ORACLE_HOME/bin/sqlplus -s "/ as sysdba" @"$f"; echo ;;
          *)        echo "$0: ignoring $f" ;;
      esac
      echo "";
  done
  
  echo "DONE: Executing user defined scripts"
  echo "";

fi;