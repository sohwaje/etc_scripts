#!/bin/sh
#!/usr/bin/expect
HOST=('10.1.0.4' '10.1.0.5' '10.1.0.15' '10.1.0.8' '10.1.0.9' '10.1.0.10' '10.1.0.11' '10.1.0.12' '10.1.0.13' '10.1.0.14')
USERID='sigongweb'
USER_PASSWORD='!#SI0aleldj*)'
ROOT_PASSWORD='!#SI0aleldj*)'

for i in "${HOST[@]}"; do
  ./root_login.exp $i $USERID $USER_PASSWORD $ROOT_PASSWORD
done
