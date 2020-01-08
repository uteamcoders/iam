#!/bin/bash
set -x
echo "Usage: fix_session_timeout.sh WEBLOGIC_API_URL WEBLOGIC_API_USER PASSWORD"
cp -R /u01/iam-self-service.Plan.xml /u01/oracle/user_projects/domains/idm_domain
cp -R /u01/iam-sysadmin.Plan.xml /u01/oracle/user_projects/domains/idm_domain

curl -v --user $2:$3 \
-H X-Requested-By:utcoders \
-H Accept:application/json \
-H Content-Type:application/json \
-d "{
 name: 'oracle.iam.console.identity.self-service.ear',
 applicationPath : '/u01/oracle/idm/server/apps/oracle.iam.console.identity.self-service.ear',
 targets: ['oim_server1'],
 plan: '/u01/oracle/user_projects/domains/idm_domain/iam-self-service.Plan.xml',
 deploymentOptions: {}
}" \
-X POST $1/management/weblogic/latest/domainRuntime/deploymentManager/deploy

curl -v --user $2:$3 \
-H X-Requested-By:utcoders \
-H Accept:application/json \
-H Content-Type:application/json \
-d "{
 name: 'oracle.iam.console.identity.sysadmin.ear',
 applicationPath : '/u01/oracle/idm/server/apps/oracle.iam.console.identity.sysadmin.ear',
 targets: ['oim_server1'],
 plan: '/u01/oracle/user_projects/domains/idm_domain/iam-sysadmin.Plan.xml',
 deploymentOptions: {}
}" \
-X POST $1/management/weblogic/latest/domainRuntime/deploymentManager/deploy