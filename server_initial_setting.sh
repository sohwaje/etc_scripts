#!/usr/bin/env bash
export  DATE=`date +%Y%m%d`
######################################################################################
# Name: server_initial_setting.sh
# Date: 2020-01-03
# Made: Lee Yusung
# Desc: Linux Server Setting Script
######################################################################################

set_swapoff() {
  echo 'Swap  OFF'
  swapoff -a
  echo 0 > /proc/sys/vm/swappiness
  sed -e '/swap/ s/^#*/#/' -i /etc/fstab
  sleep 1
  echo 'Done'
}

set_selinux_off() {
  echo 'selinux OFF'
  sed -i 's/^SELINUX=enforcing$/SELINUX=disable/' /etc/selinux/config
  setenforce 0
  sleep 1
  echo 'Done'
}

set_stop_firewalld() {
  echo "firewalld OFF"
  systemctl disable firewalld
  systemctl stop firewalld
  sleep 1
  echo "Done"
}

set_login_shell() {
  echo "login shell setting"
  echo "export PS1=`hostname`'-$LOGNAME $PWD>'" >> /etc/profile
  echo "export PS1=`hostname`'-$LOGNAME $PWD]'" >> /root/.bashrc
  source /etc/profile
  source /root/.bashrc
  sleep 1
  echo "Done"
}

set_ssh_port_setting() {
  echo "SSH Port setting"
  sed -i 's/#Port 22$/Port 16215/' /etc/ssh/sshd_config
  systemctl restart sshd
  sleep 1
  echo "Done"
}

set_file_descripter_setting() {
  echo "file descripter setting"
  echo "*       soft    nproc   unlimited" >> /etc/security/limits.conf
  echo "*       hard    nproc   unlimited" >> /etc/security/limits.conf
  echo "*       soft    nofile  65536" >> /etc/security/limits.conf
  echo "*       hard    nofile  65536" >> /etc/security/limits.conf
  echo "*       soft    nproc   unlimited" > /etc/security/limits.d/20-nproc.conf
  echo "*       hard    nproc   unlimited" >> /etc/security/limits.d/20-nproc.conf
  echo "root    soft    nproc   unlimited" >> /etc/security/limits.d/20-nproc.conf
  echo "root    hard    nproc   unlimited" >> /etc/security/limits.d/20-nproc.conf
  sleep 1
  echo "Done"
}

set_crontab_setting() {
  echo "crontab setting"
  (crontab -l 2>/dev/null; echo "0 0 * * * rdate -s time.bora.net; hwclock -w") | crontab -
  (crontab -l 2>/dev/null; echo "0 2 * * * sync && echo 3 > /proc/sys/vm/drop_caches") | crontab -
  systemctl restart crond
  sleep 1
  echo "Done"
}

set_timezone_change() {
  echo "timezone change"
  ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
  sleep 1
  echo "Done"
}

set_sysctl() {
  echo "Kernel Parameter setting"
  mv /etc/sysctl.conf /etc/sysctl.conf.$DATE
  echo "# $DATE : Modify server setter" >> /etc/sysctl.conf
  echo "swapoff -a" >> /etc/rc.local
  echo "echo 0 > /proc/sys/vm/swappiness" >> /etc/rc.local
  echo "modprobe ip_conntrack" >> /etc/rc.local
  echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
  echo "fs.file-max=10000000" >> /etc/sysctl.conf
  echo "net.core.somaxconn=65535" >> /etc/sysctl.conf
  echo "net.core.netdev_max_backlog=16777216" >> /etc/sysctl.conf
  echo "net.core.rmem_max=134217728" >> /etc/sysctl.conf
  echo "net.core.wmem_max=134217728" >> /etc/sysctl.conf
  echo "net.core.rmem_default=67108864" >> /etc/sysctl.conf
  echo "net.core.wmem_default=67108864" >> /etc/sysctl.conf
  echo "net.core.optmem_max=67108864" >> /etc/sysctl.conf
  echo "net.ipv4.ip_local_port_range=1024 65535" >> /etc/sysctl.conf
  echo "net.ipv4.ip_local_port_range=1024 65535" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_tw_reuse=1" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_max_syn_backlog=16777216" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_mem=134217728 134217728 134217728" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_rmem=10240 87380 134217728" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_wmem=10240 87380 134217728" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_fin_timeout=10" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_max_orphans=262144" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_synack_retries=5" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_syn_retries=5" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_keepalive_time=60" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_keepalive_probes=3" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_keepalive_intvl=10" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_sack=1" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_timestamps=1" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_window_scaling=1" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_slow_start_after_idle=0" >> /etc/sysctl.conf
  echo "net.ipv4.udp_rmem_min=65536" >> /etc/sysctl.conf
  echo "net.ipv4.udp_wmem_min=65536" >> /etc/sysctl.conf
  echo "net.unix.max_dgram_qlen=100" >> /etc/sysctl.conf
  echo "vm.dirty_ratio=40" >> /etc/sysctl.conf
  echo "vm.dirty_background_ratio=10" >> /etc/sysctl.conf
  echo "vm.max_map_count=262144" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_fack=1" >> /etc/sysctl.conf
  echo "kernel.msgmnb=65536" >> /etc/sysctl.conf
  echo "kernel.msgmax=65536" >> /etc/sysctl.conf
  echo "ip_conntrack" >> /etc/modules
  modprobe ip_conntrack
  sysctl -p
  sleep 1
  echo "Done"
}

set_swapoff
set_selinux_off
set_stop_firewalld
set_login_shell
set_ssh_port_setting
set_file_descripter_setting
set_crontab_setting
set_timezone_change
set_sysctl
#
sleep 1
echo "Server Setting Processes end"
