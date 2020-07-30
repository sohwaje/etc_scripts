#!/usr/bin/env bash
export  DATE=`date +%Y%m%d`
######################################################################################
# Name: server_initial_setting.sh
# Date: 2020-07-29
# Made: Lee Yusung
# Desc: Linux Server Setting Script
######################################################################################

# 호스트네임 설정
sudo bash -c 'echo "127.0.0.1 $HOSTNAME" >> /etc/hosts'

# root 원격접속 제한
set_disablerootlogin() {
  echo '##############Root login Yes -> No##############'
  sudo sed -i 's/^PermitRootLogin prohibit-password$/PermitRootLogin no/' /etc/ssh/sshd_config
  sleep 1
  echo 'Done'
}

# 계정잠금 임계값 설정
set_commonauth() {
  echo '##############/etc/pam.d/common-auth setting##############'
  sudo bash -c 'echo "auth required /lib/security/pam_tally.so deny=5 unlock_time=120" >> /etc/pam.d/common-auth'
  sleep 1
  echo 'Done'
}

# 패스워드 만료일 설정
set_passwordmaxdays() {
  echo '##############change password max days##############'
  sudo bash -c 'echo "PASS_MAX_DAYS 90" >> /etc/login.defs'
  sleep 1
  echo 'Done'
}

# umask 설정
set_umask() {
  echo '##############change umask##############'
  sudo bash -c 'echo "umask 002" >> /etc/profile'
  sleep 1
  echo 'Done'
}

# 원격접속 세션 타임아웃 설정
set_sessiontimeout() {
  echo '##############change session timeout##############'
  sudo bash -c 'echo "export TMOUT=1200" >> /etc/profile'
  sleep 1
  echo 'Done'
}

# 배너 설정
set_banner() {
  echo '##############set /etc/motd##############'
  sudo bash -c 'cat ubuntu_templates/motd > /etc/motd'
  sudo bash -c 'cat ubuntu_templates/motd > /etc/issue'
  sudo bash -c 'cat ubuntu_templates/motd > /etc/issue.net'
  sudo bash -c 'echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config'
  sudo systemctl restart sshd
  echo 'Done'
}

# 숨김 파일 모두 찾아서 파일에 저장
set_find_hiddenfile() {
  echo '##############find hidden file##############'
  sudo bash -c "find / -name '.*' -print >> ~/hidden_file_list.txt"
  sleep 1
  echo 'Done'
}

# 크론탭 퍼미션 설정
set_crontab_perm() {
  echo "##############/etc/crontab##############"
  sudo bash -c "chmod o-rw /etc/crontab"
  sleep 1
  echo 'Done'
}

# /etc/shadow 파일 소유자 및 권한 설정
set_etcshadow() {
  echo '##############/etc/shadow##############'
  sudo bash -c "chown root /etc/shadow"
  sudo bash -c "chmod 600 /etc/shadow"

  sleep 1
  echo 'Done'
}

# setuid, setgid 스케쥴링 설정
set_suidsgid() {
  echo '##############find SUID, SGID or Sticky bit##############'
  sudo bash -c 'crontab -l | { cat; echo "2 * * * * sh ubuntu_templates/find_setuid_gid.sh"; } | crontab -'
  sleep 1
  echo 'Done'
}

# /var/log 디렉토리 설정
set_logdirperm() {
  echo '##############change log dir perm##############'
  sudo bash -c "chmod -R 644 /var/log"
  sleep 1
  echo 'Done'
}
# 시스템 로그 파일의 권한을 644로 변경
# GCC 실행 권한 제한
set_gccperm() {
  echo '##############change gcc exec perm##############'
  sudo bash -c "chmod 100 /usr/bin/x86_64-linux-gnu-gcc*"
  echo 'Done'
}

# worldwritable 파일 찾아서 저장
set_worldwritable() {
  echo '##############find wolrd writable file##############'
  sudo bash -c "find /home -perm -2 -ls >> ~/wwritable_home"
  sudo bash -c "find /tmp -perm -2 -ls >> ~/wwritable_tmp"
  sudo bash -c "find /etc -perm -2 -ls >> ~/wwritable_etc"
  sudo bash -c "find /var -perm -2 -ls >> ~/wwritable_var"
  echo 'Done'
}

# su 권한 설정
set_acl_su() {
  echo '##############change perm /bin/su##############'
  sudo bash -c "chmod 4750 /bin/su"
  echo 'Done'
}

# 실행
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
