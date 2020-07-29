#!/usr/bin/env bash
export  DATE=`date +%Y%m%d`
######################################################################################
# Name: server_initial_setting.sh
# Date: 2020-07-29
# Made: Lee Yusung
# Desc: Linux Server Setting Script
######################################################################################

set_disablerootlogin() {
  echo '[1]Root login Yes -> No'
  sed -i 's/^PermitRootLogin prohibit-password$/PermitRootLogin no/' /etc/ssh/sshd_config
  sleep 1
  echo 'Done'
}

set_commonauth() {
  echo '[2]/etc/pam.d/common-auth setting'
  echo 'auth required /lib/security/pam_tally.so deny=5 unlock_time=120' >> /etc/pam.d/common-auth
  sleep 1
  echo 'Done'
}

set_passwordmaxdays() {
  echo 'change password max days'“wheel” 그룹(su 명령어 사용 그룹) 및 그룹 내 구성원 존재 여부 확인
  echo 'PASS_MAX_DAYS 90' >> /etc/login.defs
  sleep 1
  echo 'Done'
}

set_umask() {
  echo 'change umask'
  echo 'umask 002' >> /etc/profile
  sleep 1
  echo 'Done'
}

set_sessiontimeout() {
  echo 'change session timeout'
  echo 'export TMOUT=1200' >> /etc/profile
  sleep 1
  echo 'Done'
}

set_motd() {
  echo 'set /etc/motd'
  echo 'MSG' > /etc/motd
  sleep 1
  echo 'Done'
}

set_issue() {
  echo 'set /etc/issue.net'
  echo 'MSG~' > /etc/issue.net
  sleep 1
  echo 'Done'
}

set_banner() {
  echo 'set banner'
  echo 'Banner MSG' >> /etc/ssh/ssh_config
  sleep 1
  echo 'Done'
}

set_find_hiddenfile() {
  echo 'find hidden file'
  find / -name '.*' -print >> ~/hidden_file_list.txt
  sleep 1
  echo 'Done'  sleep 1
}

set_crontab_perm() {
  echo "/etc/crontab"
  chmod o-rw /etc/crontab
  sleep 1
  echo 'Done'
}

set_etcshadow() {
  echo '/etc/shadow'
  chown root /etc/shadow
  chmod 600 /etc/shadow
  sleep 1
  echo 'Done'
}

set_suidsgid() {
  echo 'find SUID, SGID or Sticky bit'
  find / -user root -type f \( -perm -04000 -o -perm -02000 \) -xdev -exec ls -al {} \; >> ~/suidsgid.txt
  sleep 1
  echo 'Done'
}
# 주기적으로 애플리케이션 또는 사용자가 임의로 생성한 파일 등 의심스럽거나 특이한 파일을 확인하여 SUID 권한 또는 파일 제거

set_logdirperm() {
  echo '시스템 로그 파일의 권한을 644로 변경'
  chmod -R 644 /var/log
  sleep 1
  echo 'Done'
}

set_acl_su() {

}

set_disablerootlogin
set_commonauth
set_passwordmaxdays
set_umask
set_sessiontimeout
set_motd
set_issue
set_banner
set_find_hiddenfile
set_crontab_perm
set_etcshadow
set_logdirperm

echo "Server Setting Processes end"
