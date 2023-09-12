#!/bin/bash
. ./config.sh 

export SITE_NAME=${ACCOUNT}.${DOMAIN}
echo $SITE_NAME

echo "certbot certonly --standalone -d ${SITE_NAME} --email ${ACCOUNT}-email@example.com --agree-tos --no-eff-email --quiet"
