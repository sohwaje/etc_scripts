#!/bin/sh
# 특정 로그가 일정 개수 이상 생겨날 때 Alert을 보낸다.
# Slack 주소
WEBHOOK_ADDRESS='https://hooks.slack.com/services/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'
DATE=$(date)
ALERT_TEXT="{\"text\": \"scheduling만 연속으로 찍히고 있습니다.:  $DATE\"}"


tail -n 10 test.log > log.tmp
NUM=$(cat log.tmp | grep 'scheduling-1' | wc -l)

echo $NUM
rm -f log.tmp

if [ $NUM -gt 5 ];
then
  curl -X POST -H 'Content-type: application/json' --data "$ALERT_TEXT" $WEBHOOK_ADDRESS
else
  echo "이상 무"
  exit 0
fi
