#!/bin/bash

. ./config.sh

ACCOUNT=$1
FORWARED_PORT=$2

TOOLS_PATH=/root/apps/cloudide/tools

 ssh root@119.13.106.38 " \
     cd ${TOOLS_PATH} && \
     sh forward_port.sh ${ACCOUNT} ${FORWARED_PORT}
     "
