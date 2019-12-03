#!/bin/bash
set -x
SCRIPTS_ROOT="/tmp";

# Check whether parameter has been passed on
if [ -z "$SCRIPTS_ROOT" ]; then
   echo "$0: No SCRIPTS_ROOT passed on, no scripts will be run";
   exit 1;
fi;

# Execute custom provided files (only if directory exists and has files in it)
if [ -d "$SCRIPTS_ROOT" ] && [ -n "$(ls -A $SCRIPTS_ROOT)" ]; then

  echo "";
  echo "Executing save checkpoint"
  checkpoint="docker_after_start_$(date +"%FT%H%M%S")";
  f="$SCRIPTS_ROOT/checkpoint$checkpoint";
  echo "CREATE RESTORE POINT $checkpoint;" > $f;
  echo "$0: running $f"; echo "exit" | $ORACLE_HOME/bin/sqlplus -s "/ as sysdba" @"$f";
  rm -f $f;
  echo "DONE: Executing save checkpoint"
  echo "";

fi;
