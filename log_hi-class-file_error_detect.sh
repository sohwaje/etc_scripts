#!/bin/sh
# 로그의 특정 메시지가 기준치 이상으로 반복해서 찍히면 SLACK으로 Alert 메세지를 보냅니다.
#LOG file
LOG="/home/sigongweb/apps/logs/hi-class-file.log"

# 특정 메시지 개수를 담은 변수
NUM=$(tail -n 20 $LOG | grep 'scheduling-1' | wc -l)

# Slack 주소
WEBHOOK_ADDRESS=''

# 날짜
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 슬랙으로 메시지 보내기 함수
function slack_message(){
    # $1 : message
    # $2 : true=good, false=danger

    COLOR="danger"
    if $2 ; then
        COLOR="good"
    fi
    curl -s -d 'payload={"attachments":[{"color":"'"$COLOR"'","pretext":"<!channel> *hi-class-file*","text":"*HOST* : '"$HOSTNAME"' \n*MESSAGE* : '"$1"'"}]}' $WEBHOOK_ADDRESS > /dev/null 2>&1
}

# 정기적인 Alert 메시지를 보내는 함수
function regular_alert_message(){
  BDATE=`echo $DATE | awk '{print $2}' | awk -F ':' '{print $1":"$2}'`
  ADATE="08:00"

if [ "$BDATE" == "$ADATE" ]; then
  slack_message "$HOSTNAME NOW 08:00 " true
fi
}

# 임시 파일 삭제
rm -f log.tmp

# 특정 로그 파일이 연속해서 10개 이상 찍히면 Slack으로 알림 전송
if [ $NUM -gt 10 ]; then
#if [ $NUM -ne 10 ]; then
  echo "Warning: $NUM  | Date: $DATE"
  slack_message "$HOSTNAME hi-class-file server maybe FAULT!!!!. " false  # 성공
  exit 0
else
#  slack_message "$HOSTNAME NORMARL" true             # 실패
  echo "Normal : $NUM | DATE: $DATE"
  exit 1
fi

regular_alert_message
