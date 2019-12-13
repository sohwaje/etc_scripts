#!/bin/sh
WEBTOBDIR="/home/sigongweb/webtob/log"
find $WEBTOBDIR -maxdepth 2 -mtime +6 -type f -exec rm -f {} \;
