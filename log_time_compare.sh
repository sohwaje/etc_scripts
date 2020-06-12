#!/bin/sh
# https://zetawiki.com/wiki/Bash_Unixtime-DATETIME_%EB%B3%80%ED%99%98
# 특정 시간 동안 더이상 로그가 찍히지 않을 때 alert을 보낸다.
# Slack 주소
WEBHOOK_ADDRESS='https://hooks.slack.com/services/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'
DATE=$(date)
ALERT_TEXT="{\"text\": \"hi-class-file에 로그가 쌓이지 않습니다. :  $DATE\"}"

# 로그의 가장 마지막 줄의 시간을 UNIXTIME 형식으로 구하는 함수.
function LOGTIME {
  date -d $(tail -n 1 hi-class-file.log | awk '{print $2}'| cut -f 1 -d '.') +%s
}
BEFORE=`LOGTIME`

# 현재 시간을 구하는 함수
function CURRENT_TIME {
  date +%s
}
AFTER=`CURRENT_TIME`

# 현재 시간에서 로그의 마지막 시간을 뺀다. 300초 보다 클 경우 alert을 보낸다.
let RESULT=$AFTER-$BEFORE

if [ $RESULT -gt 300 ];
then
  curl -X POST -H 'Content-type: application/json' --data "$ALERT_TEXT" $WEBHOOK_ADDRESS
else
  echo "이상 무"
  exit 0
fi
