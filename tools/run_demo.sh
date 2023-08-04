#!/bin/bash
source ./config.sh

if docker network ls | grep -q "mynetwork"; then
    echo "ok"
else
    docker network create --subnet 171.17.0.0/24 mynetwork
fi

docker rm -f ${CONTAINER_NAME}

docker run -d --init --net mynetwork --name ${CONTAINER_NAME} -u $(id -u):$(id -g) --ip ${CONTAINER_IP} -v "$(pwd)/../:/home/project:cached" theiaide/theia-full

