#!/bin/bash

. ./config.sh

ACCOUNT=$1
ACCOUNT_DIST=$ACCOUNT-dist
SITE_NAME=$ACCOUNT_DIST.${DOMAIN}


 ssh root@35.241.101.99 " \
     cd /root/apps/docker_theia/demo/tools && \
     sh deploy_dist_site.sh ${ACCOUNT_DIST}
     "

cd ../hello-world/dist
scp -r * root@35.241.101.99:/www/wwwroot/${SITE_NAME}
