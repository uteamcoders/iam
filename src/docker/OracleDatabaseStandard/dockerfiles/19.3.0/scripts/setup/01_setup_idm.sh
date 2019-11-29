#!/bin/bash

SCRIPTS_ROOT="$ORACLE_HOME/rdbms/admin";

# Check whether parameter has been passed on
if [ -z "$SCRIPTS_ROOT" ]; then
   echo "$0: No SCRIPTS_ROOT passed on, no scripts will be run";
   exit 1;
fi;

# Execute custom provided files (only if directory exists and has files in it)
if [ -d "$SCRIPTS_ROOT" ] && [ -n "$(ls -A $SCRIPTS_ROOT)" ]; then

  echo "";
  echo "Executing user defined scripts"

  for f in [dbmspool.sql,prvtpool.plb,xaview.sql]; do
      case "$f" in
          *.sql)    echo "$0: running $f"; echo "exit" | $ORACLE_HOME/bin/sqlplus -s "/ as sysdba" @"$f"; echo ;;
      esac
      echo "";
  done

  echo "DONE: Executing user defined scripts"
  echo "";

fi;