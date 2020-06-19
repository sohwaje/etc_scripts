#!/bin/sh
USERID="sigongweb"
USER_PASSWORD="!@#"
ROOT_PASSWORD="!@#"
HOST="gitlab"
expect <<EOF
set timeout 20
#set HOST [lindex $argv 0]
#set USERID [lindex $argv 1]
#set USER_PASSWORD [lindex $argv 2]
#set ROOT_PASSWORD [lindex $argv 3]

spawn ssh $USERID@$HOST -p 16215
expect -re "No route" {
            exit 1
     } -re "try again" {
            exit 1
     } -re "yes/no" {
            send "yes\r"
            exp_continue
     } -re "password:" {
            send "$USER_PASSWORD\r"
            exp_continue
     } -re  ">" {
            send "su -\r"
     }
expect ":" { send "$ROOT_PASSWORD\r" }
send "/opt/hp/hpssacli/bld/hpssacli ctrl all show config | grep -E 'physicaldrive'\r"
send "exit\r"
send "exit\r"
expect eof
EOF
