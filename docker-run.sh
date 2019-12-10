#!/bin/sh
#[1] WAR 홈, 소스 홈 지정
WAR_HOME="/home/sigongweb/apps/war"
SOURCE_HOME="/home/sigongweb/apps/source"
WAR_NAME="$(ls ..$WAR_HOME)"

#[2] war 파일 압축 풀기
if [ ! -f ${WAR_HOME}/${WAR_NAME} ]; then
  echo "WAR 파일을 찾을 수 없습니다."
  exit 1;
else
  echo "${WAR_HOME}에 ${WAR_NAME}가 있습니다."
  echo "압축을 풉니다."
  cd $WAR_HOME
  jar -xvf ${WAR_HOME}/${WAR_NAME}
fi


#[3] docker 실행
