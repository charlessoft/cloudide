#!/bin/bash
source ./config.sh

# if [ "$#" -lt 2 ]; then
#     echo "sh forward_port account forward_port"
#     exit 1
# fi

ACCOUNT=$1
CONTAINER_IP=$2
DEFAULT_PORT=$3
PROXY_NAME=$4



echo "==========config web site config=========="
export SITE_NAME=${ACCOUNT}.${DOMAIN}
# echo $SITE_NAME
# mkdir -p /www/server/panel/vhost/nginx/proxy/${SITE_NAME}


cat << EOF >/www/server/panel/vhost/nginx/proxy/${SITE_NAME}/${PROXY_NAME}.conf
#PROXY-START/

location ^~ /
{
    proxy_pass http://${CONTAINER_IP}:${DEFAULT_PORT};
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header REMOTE-HOST \$remote_addr;
    proxy_set_header Upgrade \$http_upgrade;
    #proxy_set_header Connection \$connection_upgrade;
    proxy_http_version 1.1;
    # proxy_hide_header Upgrade;

    add_header X-Cache \$upstream_cache_status;

    #Set Nginx Cache


    set \$static_fileSJrxlr6g 0;
    if ( \$uri ~* "\.(gif|png|jpg|css|js|woff|woff2)$" )
    {
        set \$static_fileSJrxlr6g 1;
        expires 1m;
        }
    if ( \$static_fileSJrxlr6g = 0 )
    {
    add_header Cache-Control no-cache;
    }
}

#PROXY-END/
EOF


echo "creare proxy end"
