#!/bin/bash
# jar 파일 복사
PROC_NAME="$(ls ../survey )"
echo ${PROC_NAME}
readonly DAEMON="/home/sigongweb/apps/survey/${PROC_NAME}"
# 프로세스 아이디가 존재할 패스를 설정
readonly PID_PATH="/home/sigongweb/apps/bin/"
readonly PROC_PID="${PID_PATH}${PROC_NAME}.pid"

# 시작 함수
start()
{
   echo "Starting ${PROC_NAME}..."
    local PID=$(get_status)
    if [ -n "${PID}" ]; then
        echo "${PROC_NAME} is already running"
        exit 0
    fi
    nohup java -jar -XX:MaxMetaspaceSize=512m -XX:MetaspaceSize=256m -Xms1024m -Xmx1024m -Dspring.profiles.active=dev "${DAEMON}" > /dev/null 2>&1 &
    local PID=${!}

    if [ -n ${PID} ]; then
        echo " - Starting..."
        echo " - Created Process ID in ${PROC_PID}"
        echo ${PID} > ${PROC_PID}
    else
        echo " - failed to start."
    fi
}
# 중지
stop()
{
    echo "Stopping ${PROC_NAME}..."
    local DAEMON_PID=`cat "${PROC_PID}" 2>/dev/null`

    if [ -z "$DAEMON_PID" ]; then
        echo "${PROC_NAME} was not running."
    else
        kill $DAEMON_PID 2>/dev/null
        rm -f $PROC_PID 2>/dev/null
        echo " - Shutdown ...."
    fi
}
# 상태
status()
{
    local PID=$(get_status)
    if [ -n "${PID}" ]; then
        echo "${PROC_NAME} is running"
    else
        echo "${PROC_NAME} is stopped"
        # start daemon
        #nohup java -jar "${DAEMON}" > /dev/null 2>&1 &
    fi
}

get_status()
{
    ps ux | grep ${PROC_NAME} | grep -v grep | awk '{print $2}'
}

# 케이스 별로 함수를 호출하도록 한다.

case "$1" in
start)
start
sleep 7
;;
stop)
stop
sleep 5
;;
restart)
stop ; echo "Restarting..."; sleep 5 ;
start
;;
status)
status "${PROC_NAME}"
    ;;
    *)
    echo "Usage: $0 {start | stop | restart | status }"
esac
exit 0
