#!/bin/sh
# 로그의 특정 메시지가 기준치 이상으로 찍히면 SLACK으로 Alert 메세지를 보냅니다.
#LOG file
LOG="/home/sigongweb/apps/logs/hi-class-file.log.2020-06-14.5"
# Slack 주소
WEBHOOK_ADDRESS='https://hooks.slack.com/services/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'
# 날짜
DATE=$(date '+%Y-%m-%d %H:%M:%S')
# json 형식의 ALERT 메시지
ALERT_TEXT="{\"text\": \"MSG: scheduling Error Date:  $DATE\"}"
# 특정 메시지 개수를 담은 변수
NUM=$(tail -n 20 $LOG | grep 'scheduling-1' | wc -l)

# 임시 파일 삭제
rm -f log.tmp

# 로그 파일 개수 확인
if [ $NUM -gt 10 ];
then
  echo "Warning: $NUM  | Date: $DATE"
  curl -X POST -H 'Content-type: application/json' --data "$ALERT_TEXT" $WEBHOOK_ADDRESS > /dev/null 2>&1
else
  echo "Normal : $NUM | DATE: $DATE"
fi
