#!/bin/sh
# 앱의 파일명을 찾는다.
APP_NAME="$(ls /home/sigongweb/apps/front)"

# 앱의 파일명으로 PID를 찾는 함수
get_PID()
{
    ps ux | grep ${APP_NAME} | grep -v grep | awk '{print $2}'
}

# 찾은 PID를 PID 변수에 대입한다
PID=$(get_PID)
  echo "APP name is ${APP_NAME}"
  sleep 1
  echo "kill -9 ${PID}"

# PID 변수에 담긴 PID에 kill signal을 보낸다.
kill -9 ${PID}
