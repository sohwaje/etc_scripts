#!/bin/sh
APP_NAME="$(ls /home/sigongweb/apps/api)"

PID=$(get_PID)

kill -9 $PID

get_PID()
{
    ps ux | grep ${APP_NAME} | grep -v grep | awk '{print $2}'
}
