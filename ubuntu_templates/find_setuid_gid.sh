#!/bin/sh
export  DATE=`date +%Y%m%d`
find / -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev -exec ls -al {} \; >> ~/$DATE-suidsgid.txt
