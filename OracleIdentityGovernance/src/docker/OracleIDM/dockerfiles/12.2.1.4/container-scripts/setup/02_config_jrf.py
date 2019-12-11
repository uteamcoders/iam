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
readDomain('###DOMAIN_HOME###')
selectTemplate('Oracle JRF')
loadTemplates()
showTemplates()
exit()
