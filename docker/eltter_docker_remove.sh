#!/bin/sh
DOCKER_NAME="nginx"

docker stop ${DOCKER_NAME}
sleep 3

docker system prune -a
