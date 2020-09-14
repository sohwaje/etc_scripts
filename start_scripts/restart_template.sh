#!/bin/sh
projectPathName="$1"
projectPath="/home/sigongweb/$projectPathName"
echo $projectPath
echo $(ps aux | grep $projectPath/ | awk '{print $2}')
kill $(ps aux | grep $projectPath/ | awk '{print $2}')
echo "pause 3 second"
sleep 3s
cd $projectPath
sh bin/shutdown.sh; sleep 8s; sh bin/startup.sh; tail -f logs/catalina.out