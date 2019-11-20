#!/bin/sh
#hi-class-api
APIPID=$(ps -ef | grep hi-class-api | grep -v grep | awk '{print $2}')
CHATPID=$(ps -ef | grep hi-class-chat | grep -v grep | awk '{print $2}')
OAUTH2PID=$(ps -ef | grep hi-class-oauth2 | grep -v grep | grep -v hi-class-oauth2-client | awk '{print $2}')
OAUTH2CLIENTPID=$(ps -ef | grep hi-class-oauth2-client | grep -v grep | awk '{print $2}')
ADMINPID=$(ps -ef | grep hi-class-ui-admin | grep -v grep | awk '{print $2}')
FILEPID=$(ps -ef | grep hi-class-file | grep -v grep | awk '{print $2}')
CRAWLERPID=$(ps -ef | grep hi-class-crawler | grep -v grep | awk '{print $2}')
UIPID=$(ps -ef | grep hi-class-ui | grep -v grep | grep -v hi-class-ui-admin | awk '{print $2}')

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
  echo "Hi-class-api 앱이 없음"
else
  echo "API:" $(ps -p $APIPID -o %cpu)
  echo "API:" $(ps -p $APIPID -o %mem)
  echo
fi

# CHAT
if [ -z $CHATPID ]
then
  echo "hi-class-chat 앱이 없음"
else
  echo "CHAT:" $(ps -p $CHATPID -o %cpu)
  echo "CHAT:" $(ps -p $CHATPID -o %mem)
  echo
fi
# OAUTH2
if [ -z $OAUTH2PID ]
then
  echo "hi-class-oauth2 앱이 없음"
else
  echo "oauth2:" $(ps -p $OAUTH2PID -o %cpu)
  echo "oauth2:" $(ps -p $OAUTH2PID -o %mem)
  echo
fi

# OAUTH2-CLIENT
if [ -z $OAUTH2CLIENTPID ]
then
  echo "hi-class-oauth2-client 앱이 없음"
else
  echo "oauth2-client:" $(ps -p $OAUTH2CLIENTPID -o %cpu)
  echo "oauth2-client:" $(ps -p $OAUTH2CLIENTPID -o %mem)
  echo
fi

# admin-ui
if [ -z $ADMINPID ]
then
  echo "hi-class-ui-admin 앱이 없음"
else
  echo "admin:" $(ps -p $ADMINPID -o %cpu)
  echo "admin:" $(ps -p $ADMINPID -o %mem)
  echo
fi

# file
if [ -z $FILEPID ]
then
  echo "hi-class-file 앱이 없음"
else
  echo "file:" $(ps -p $FILEPID -o %cpu)
  echo "file:" $(ps -p $FILEPID -o %mem)
  echo
fi

# crawler
if [ -z $CRAWLERPID ]
then
  echo "hi-class-crawler 앱이 없음"
else
  echo "crawler:" $(ps -p $CRAWLERPID -o %cpu)
  echo "crawler:" $(ps -p $CRAWLERPID -o %mem)
  echo
fi

# front-ui
if [ -z $UIPID ]
then
  echo "hi-class-ui 앱이 없음"
else
  echo "front:" $(ps -p $UIPID -o %cpu)
  echo "front:" $(ps -p $UIPID -o %mem)
  echo
fi
sleep 2
done
