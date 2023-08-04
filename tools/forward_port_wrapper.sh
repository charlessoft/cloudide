#!/bin/bash

. ./config.sh

ACCOUNT=$1
FORWARED_PORT=$2

 ssh root@35.241.101.99 " \
     cd /root/apps/docker_theia/demo/tools && \
     sh forward_port.sh ${ACCOUNT} ${FORWARED_PORT}
     "
