#!/bin/sh
DOCKER_NAME="nginx"

docker stop ${DOCKER_NAME}
sleep 3

echo "y" | docker system prune -a
