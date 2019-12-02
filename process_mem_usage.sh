#!/bin/sh
COUNT=10
while :
do
  if [ $COUNT = 10 ]
  then
    clear
  fi
ps -eo user,pid,ppid,rss,size,vsize,pmem,pcpu,time,comm --sort -rss | head -n 11
sleep 2
done
