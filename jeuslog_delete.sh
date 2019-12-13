#!/bin/sh
JEUSDIR="/home/sigongweb/jeus7/log"
JEUSSERVLETDIR="/home/sigongweb/jeus7/log/*/servlet"
find $JEUSDIR -maxdepth 2 -mtime +6 -type f -exec rm -f {} \;
find $JEUSSERVLETDIR -mtime +2 -type f -exec rm -f {} \;
