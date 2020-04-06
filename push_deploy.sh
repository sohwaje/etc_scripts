#!/bin/bash

CATALINA_HOME="/home/sigongweb/server/tomcat8-push"

tomcat_port=8080
host_ip=$(hostname -I | tr -d '[:space:]')
target_url="http://$(echo -e ${host_ip} | tr -d '[:space:]'):${tomcat_port}"

global_arg=$1

if [ "${global_arg}" == "start" ]; then
  config_work_status="WAIT"
elif [ "${global_arg}" == "end" ]; then
  config_work_status="RUN"
else
  echo "스크립트 시작 파라미터"
  echo "시작 : start"
  echo "배포 마무리 : end"
  exit
fi

#================================================================================================

function nginx_switch_off() {
  sed -i "s/push_end_point\\;.*/push_end_point_off\\;/g" /etc/nginx/conf.d/upstream_end_point.inc

  /usr/sbin/nginx -s reload
}

function nginx_switch_on() {
  sed -i "s/push_end_point_off\\;.*/push_end_point\\;/g" /etc/nginx/conf.d/upstream_end_point.inc

  /usr/sbin/nginx -s reload
}

#push 서버의 스레드들이 일을 할당 받을 수 있는지 유무를 조회
function get_push_server_work_status() {
  curl -s ${target_url}/deploy/worker/status | head -n 1 | cut -d " " -f 2
}

#push 서버의 스레드들이 일을 할당 받을 수 있게 또는 없게 수정 요청
function set_push_server_work_status() {
  work_status=$(get_push_server_work_status)
  echo "변경 전 Thread들 redis에서 작업 요청 상태 : (" ${work_status} ")"

  if [ "${work_status}" != "$1" ]; then
    result=$(curl -s -I -XPOST ${target_url}/deploy/worker/$1 | head -n 1 | cut -d " " -f 2)
    echo "변경 요청 결과 :" ${result}

    work_status=$(get_push_server_work_status)
    echo "변경 후 Thread들 redis에서 작업 요 상태 : (" ${work_status} ")"
  else
    echo "서버 상태와 변경 요청 값이 같음 서버 (" ${work_status} ") 요청 (" $1 ")"
  fi
}

#push 서버의 스레드 상태를 조회
function get_thread_status() {
  curl -s ${target_url}/deploy/thread/status | head -n 1 | cut -d " " -f 2
}

#push 서버의 스레드 정지 요청
function thread_shutdown() {
    curl -XPOST -s ${target_url}/deploy/thread/shutdown | head -n 1 | cut -d " " -f 2

    thread_status=$(get_thread_status)
    echo "작업 스레드 상태 : (" ${thread_status} ")"

    while [ ${thread_status} != "WAIT" ]; do
      thread_status=$(get_thread_status)
      echo "스레드 중지 요청중..." ${thread_status}

      sleep 5s
    done
}

function tomcat_down() {
  $CATALINA_HOME/bin/catalina.sh stop

  wait_until_shutdown_complete
}

function wait_until_shutdown_complete() {

  check=$(netstat -tnl | grep ${tomcat_port} | wc -l)
  if [ "${check}" == "0"  ]; then
    echo "톰캣 서버 정지 상태"
  else
    while [ "${check}" != "1" ]; do
      check=$(netstat -tnl | grep ${tomcat_port} | wc -l)

      echo "톰캣 서버 정지 중..."

      sleep 5s
    done

    echo "톰캣 서버 정지"
  fi
}

function tomcat_up() {
  $CATALINA_HOME/bin/catalina.sh start

  isStarted
}

function isStarted() {

  check=$(curl -XGET -s -I "${target_url}/deploy/health" | head -n 1 | cut -d " " -f 2)

  while [ "${check}" != "200" ]; do
    check=$(curl -XGET -s -I "${target_url}/deploy/health" | head -n 1 | cut -d " " -f 2)
    echo "톰캣 서버 시작 중..."

    sleep 5s
  done

  echo "톰캣 서버 시작!"
}

#================================================================================================

if [ ${global_arg} == "start" ]; then
  #배포 할려는 was를 서비스에서 제외/
  nginx_switch_off
fi

if [ "${global_arg}" == "start" ]; then
  #현제 작업을 진행 중이면 중지로 전환
  set_push_server_work_status "${config_work_status}"

  #작업 중인 스레드들 중지 요청
  thread_shutdown
fi

if [ "${global_arg}" == "start" ]; then
  #톰캣 중지 요청
  tomcat_down
elif [ "${global_arg}" == "end" ]; then
  #톰캣 시작 요청
  tomcat_up
fi

if [ ${global_arg} == "end" ]; then
  #배포 완료된 was를 서비스에 포험.
  nginx_switch_on
fi
