#!/bin/bash
set -e

export PROJECT_ID=
export SITE_NS=
export WP_DB_NAME=
export WP_USER_PWD=



cp -vr deploy/resources/per-site deploy/resources/${SITE_NS}
LC_CTYPE=C && find ./deploy/resources/${SITE_NS}/ -type f -exec sed -i '' "s/\[SITE_NS\]/${SITE_NS}/g" {} \;
LC_CTYPE=C && find ./deploy/resources/${SITE_NS}/ -type f -exec sed -i '' "s/\[PROJECT_ID\]/${PROJECT_ID}/g" {} \;
LC_CTYPE=C && find ./deploy/resources/${SITE_NS}/ -type f -exec sed -i '' "s/\[WP_DB_NAME\]/${WP_DB_NAME}/g" {} \;
LC_CTYPE=C && find ./deploy/resources/${SITE_NS}/ -type f -exec sed -i '' "s/\[WP_USER_PWD\]/${WP_USER_PWD}/g" {} \;


#TODO: add entry to deploy/resources/shared/gcp/wi-policy.yaml
#rm -rf deploy/resources/$SITE_NS
