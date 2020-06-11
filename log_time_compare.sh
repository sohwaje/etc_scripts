#!/bin/sh
# https://zetawiki.com/wiki/Bash_Unixtime-DATETIME_%EB%B3%80%ED%99%98
# 로그의 가장 마지막 줄의 시간을 구한다.
BEFORE=`tail -n 1 hi-class-file.log | awk '{print $2}'| cut -f 1 -d '.'`
B=`date +%s --date $BEFORE`
echo "B: $B"

sleep 60
# 현재 시간을 구한다.
A=`date +%s`
echo "A: $A"

# 로그의 마지막 줄의 시간과 현재 시간을 비교한다.
let C=$A-$B
if [ $C > 10 ];
then
  echo "크롤러 서버" | mail -s "f로그 안 쌓임. 긴급 점검하세요." kisssulran@i-screammedia.com
else
  echo "END"
fi
