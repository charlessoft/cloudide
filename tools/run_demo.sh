#!/bin/bash
source ./config.sh

if docker network ls | grep -q "mynetwork"; then
    echo "ok"
else
    docker network create --subnet 171.17.0.0/24 mynetwork
fi

docker rm -f ${CONTAINER_NAME}

docker run -d --init --net mynetwork --name ${CONTAINER_NAME} -u $(id -u):$(id -g) --ip ${CONTAINER_IP} \
	       -v "$(pwd)/../:/home/project:cached" \
	       -v "/root/.ssh/:/root/.ssh" theiaide/theia-full



#docker exec ${CONTAINER_NAME} /bin/bash -c "/home/project/tools/init_node.sh"

#node-v16.17.1-linux-x64
#docker cp /root/apps/node-v16.17.1-linux-x64.tar.xz ${CONTAINER_NAME}:/tmp/
