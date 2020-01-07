#!/bin/sh
# [1]app의 홈디렉토리
APP_HOME=/home/sigongweb/apps

# [2]app 이름
API_NAME="$(ls ${APP_HOME}/api)"
CHAT_NAME="$(ls ${APP_HOME}/chat)"
OAUTH2_NAME="$(ls ${APP_HOME}/oauth2)"
OAUTH2CLIENT_NAME="$(ls ${APP_HOME}/oauth2client)"
ADMIN_NAME="$(ls ${APP_HOME}/admin)"
FILE_NAME="$(ls ${APP_HOME}/file)"
CRAWLER_NAME="$(ls ${APP_HOME}/crawler)"
UI_NAME="$(ls ${APP_HOME}/front)"

# [3]app이름으로 PID 찾는다.
APIPID=$(ps -ef | grep $API_NAME | grep -v grep | awk '{print $2}')
CHATPID=$(ps -ef | grep $CHAT_NAME | grep -v grep | awk '{print $2}')
OAUTH2PID=$(ps -ef | grep $OAUTH2_NAME | grep -v grep | awk '{print $2}')
OAUTH2CLIENTPID=$(ps -ef | grep $OAUTH2CLIENT_NAME | grep -v grep | awk '{print $2}')
ADMINPID=$(ps -ef | grep $ADMIN_NAME | grep -v grep | awk '{print $2}')
FILEPID=$(ps -ef | grep $FILE_NAME | grep -v grep | awk '{print $2}')
CRAWLERPID=$(ps -ef | grep $CRAWLER_NAME | grep -v grep | awk '{print $2}')
UIPID=$(ps -ef | grep $UI_NAME | grep -v grep | awk '{print $2}')

# [4] APP의 PID의 메모리와 CPU 사용률
COUNT=10
while :
do
  if [ $COUNT = 10 ]
  then
    clear
  fi
# API
if [ -z $APIPID ]
then
  echo "========================================"
  echo "API: Not Found"
  echo "========================================"
else
  echo "========================================"
  echo "API:" $(ps -p $APIPID -o %cpu)
  echo "API:" $(ps -p $APIPID -o %mem)
  echo "========================================"
fi

# CHAT
if [ -z $CHATPID ]
then
  echo "========================================"
  echo "CHAT: Not Found"
  echo "========================================"
else
  echo "========================================"
  echo "CHAT:" $(ps -p $CHATPID -o %cpu)
  echo "CHAT:" $(ps -p $CHATPID -o %mem)
  echo "========================================"
fi
# OAUTH2
if [ -z $OAUTH2PID ]
then
  echo "========================================"
  echo "OAUTH2: Not Found"
  echo "========================================"
else
  echo "========================================"
  echo "OAUTH2:" $(ps -p $OAUTH2PID -o %cpu)
  echo "OAUTH2:" $(ps -p $OAUTH2PID -o %mem)
  echo "========================================"
fi

# OAUTH2-CLIENT
if [ -z $OAUTH2CLIENTPID ]
then
  echo "========================================"
  echo "OAUTH2-CLIENT: Not Found"
  echo "========================================"
else
  echo "========================================"
  echo "OAUTH2-CLIENT:" $(ps -p $OAUTH2CLIENTPID -o %cpu)
  echo "OAUTH2-CLIENT:" $(ps -p $OAUTH2CLIENTPID -o %mem)
  echo "========================================"
fi

# admin-ui
if [ -z $ADMINPID ]
then
  echo "========================================"
  echo "UI-ADMIN: Not Found"
  echo "========================================"
else
  echo "========================================"
  echo "UI-ADMIN:" $(ps -p $ADMINPID -o %cpu)
  echo "UI-ADMIN:" $(ps -p $ADMINPID -o %mem)
  echo "========================================"
fi

# file
if [ -z $FILEPID ]
then
  echo "========================================"
  echo "FILE: Not Found"
  echo "========================================"
else
  echo "========================================"
  echo "FILE:" $(ps -p $FILEPID -o %cpu)
  echo "FILE:" $(ps -p $FILEPID -o %mem)
  echo "========================================"
fi

# crawler
if [ -z $CRAWLERPID ]
then
  echo "========================================"
  echo "CRAWLER: Not Found"
  echo "========================================"
else
  echo "========================================"
  echo "CRAWLER:" $(ps -p $CRAWLERPID -o %cpu)
  echo "CRAWLER:" $(ps -p $CRAWLERPID -o %mem)
  echo "========================================"
fi

# front-ui
if [ -z $UIPID ]
then
  echo "========================================"
  echo "UI: Not Found"
  echo "========================================"
else
  echo "========================================"
  echo "UI:" $(ps -p $UIPID -o %cpu)
  echo "UI:" $(ps -p $UIPID -o %mem)
  echo "========================================"
fi
sleep 2
done
