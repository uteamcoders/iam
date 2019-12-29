#!/bin/bash
set -x
echo "Usage: install_dbat_app.sh APP_NAME OIM_API_URL OIM_API_USER PASSWORD"
cp -R /u01/oracle/install/$1 /u01/oracle/user_projects/domains/idm_domain
curl  -H "Content-Type: application/json"  -H "X-Requested-By: utcoders"  -X POST \
     -u $3:$4  -d @/u01/oracle/user_projects/domains/idm_domain/$1-app.json \
       $2/iam/governance/applicationmanagement/api/v1/applications
