#!/bin/sh
APP_NAME="$(ls /home/sigongweb/apps/front)"

get_PID()
{
    ps ux | grep ${APP_NAME} | grep -v grep | awk '{print $2}'
}

PID=$(get_PID)
  echo "APP name is ${APP_NAME}"
  sleep 1
  echo "kill -9 ${PID}"

kill -9 ${PID}
