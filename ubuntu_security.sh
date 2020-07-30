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
  sudo sed -i 's/^PermitRootLogin prohibit-password$/PermitRootLogin no/' /etc/ssh/sshd_config
  sleep 1
  echo 'Done'
}

set_commonauth() {
  echo '[2]/etc/pam.d/common-auth setting'
  sudo echo 'auth required /lib/security/pam_tally.so deny=5 unlock_time=120' >> /etc/pam.d/common-auth
  sleep 1
  echo 'Done'
}

set_passwordmaxdays() {
  echo 'change password max days'
  sudo echo 'PASS_MAX_DAYS 90' >> /etc/login.defs
  sleep 1
  echo 'Done'
}

set_umask() {
  echo 'change umask'
  sudo echo 'umask 002' >> /etc/profile
  sleep 1
  echo 'Done'
}

set_sessiontimeout() {
  echo 'change session timeout'
  echo 'export TMOUT=1200' >> /etc/profile
  sleep 1
  echo 'Done'
}

set_banner() {
  echo 'set /etc/motd'
  cat ubuntu_templates/motd > /etc/motd
  cat ubuntu_templates/motd > /etc/issue
  cat ubuntu_templates/motd > /etc/issue.net
  echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
  systemctl restart sshd
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

# setuid, setgid 스케쥴링 설정
set_suidsgid() {
  echo 'find SUID, SGID or Sticky bit'
  crontab -l | { cat; echo "5 * * * * sh ubuntu_templates/find_setuid_gid.sh"; } | crontab -
  sleep 1
  echo 'Done'
}


set_logdirperm() {
  echo '시스템 로그 파일의 권한을 644로 변경'
  chmod -R 644 /var/log
  sleep 1
  echo 'Done'
}

set_gccperm() {
  echo 'change gcc exec perm'
  chmod 100 /usr/bin/x86_64-linux-gnu-gcc*
  echo 'Done'
}

set_worldwritable() {
  echo 'find wolrd writable file'
  find /home -perm -2 -ls >> ~/wwritable_home
  find /tmp -perm -2 -ls >> ~/wwritable_tmp
  find /etc -perm -2 -ls >> ~/wwritable_etc
  find /var -perm -2 -ls >> ~/wwritable_var
}

set_acl_su() {
  echo 'change perm /bin/su'
  sudo chmod 4750 /bin/suset_acl_su
  echo 'Done'
}

set_disablerootlogin
set_commonauth
set_passwordmaxdays
set_umask
set_sessiontimeout
set_banner
set_find_hiddenfile
set_crontab_perm
set_suidsgid
set_etcshadow
set_logdirperm
set_gccperm
set_acl_su

echo "Server Setting Processes end"
