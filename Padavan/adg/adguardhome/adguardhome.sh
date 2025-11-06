#!/bin/sh

scriptfilepath=$(cd "$(dirname "$0")"; pwd)/$(basename $0)
change_dns() {
if [ "$(nvram get adg_redirect)" = 1 ]; then
sed -i '/no-resolv/d' /etc/storage/dnsmasq/dnsmasq.conf
sed -i '/server=127.0.0.1/d' /etc/storage/dnsmasq/dnsmasq.conf
cat >> /etc/storage/dnsmasq/dnsmasq.conf << EOF
no-resolv
server=127.0.0.1#5335
EOF
/sbin/restart_dhcpd
logger -t "【AdGuardHome】" "添加DNS转发到5335端口"
fi
}

del_dns() {
sed -i '/no-resolv/d' /etc/storage/dnsmasq/dnsmasq.conf
sed -i '/server=127.0.0.1#5335/d' /etc/storage/dnsmasq/dnsmasq.conf
/sbin/restart_dhcpd
}

set_iptable() {
    if [ "$(nvram get adg_redirect)" = 2 ]; then
  IPS="`ifconfig | grep "inet addr" | grep -v ":127" | grep "Bcast" | awk '{print $2}' | awk -F : '{print $2}'`"
  for IP in $IPS
  do
    iptables -t nat -A PREROUTING -p tcp -d $IP --dport 53 -j REDIRECT --to-ports 5335 >/dev/null 2>&1
    iptables -t nat -A PREROUTING -p udp -d $IP --dport 53 -j REDIRECT --to-ports 5335 >/dev/null 2>&1
  done

  IPS="`ifconfig | grep "inet6 addr" | grep -v " fe80::" | grep -v " ::1" | grep "Global" | awk '{print $3}'`"
  for IP in $IPS
  do
    ip6tables -t nat -A PREROUTING -p tcp -d $IP --dport 53 -j REDIRECT --to-ports 5335 >/dev/null 2>&1
    ip6tables -t nat -A PREROUTING -p udp -d $IP --dport 53 -j REDIRECT --to-ports 5335 >/dev/null 2>&1
  done
    logger -t "【AdGuardHome】" "重定向53端口"
    fi
}

clear_iptable() {
  OLD_PORT="5335"
  IPS="`ifconfig | grep "inet addr" | grep -v ":127" | grep "Bcast" | awk '{print $2}' | awk -F : '{print $2}'`"
  for IP in $IPS
  do
    iptables -t nat -D PREROUTING -p udp -d $IP --dport 53 -j REDIRECT --to-ports $OLD_PORT >/dev/null 2>&1
    iptables -t nat -D PREROUTING -p tcp -d $IP --dport 53 -j REDIRECT --to-ports $OLD_PORT >/dev/null 2>&1
  done

  IPS="`ifconfig | grep "inet6 addr" | grep -v " fe80::" | grep -v " ::1" | grep "Global" | awk '{print $3}'`"
  for IP in $IPS
  do
    ip6tables -t nat -D PREROUTING -p udp -d $IP --dport 53 -j REDIRECT --to-ports $OLD_PORT >/dev/null 2>&1
    ip6tables -t nat -D PREROUTING -p tcp -d $IP --dport 53 -j REDIRECT --to-ports $OLD_PORT >/dev/null 2>&1
  done

}

getconfig(){
adg_file="/etc/storage/adg.sh"
if [ ! -f "$adg_file" ] || [ ! -s "$adg_file" ] ; then
	cat > "$adg_file" <<-\EEE
http:
  address: 0.0.0.0:3030
auth_name: admin
auth_pass: admin
language: zh-cn
dns:
  bind_host: 0.0.0.0
  port: 5335
  ratelimit: 0
  upstream_dns:
  - tcp://1.0.0.1
  bootstrap_dns: tcp://1.0.0.1
  all_servers: true
tls:
  enabled: false
filters:
- enabled: true
  url: https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
  name: AdGuard Simplified Domain Names filter
  id: 1
- enabled: true
  url: https://adaway.org/hosts.txt
  name: AdAway
  id: 2
- enabled: true
  url: https://hosts-file.net/ad_servers.txt
  name: hpHosts - Ad and Tracking servers only
  id: 3
- enabled: true
  url: https://www.malwaredomainlist.com/hostslist/hosts.txt
  name: MalwareDomainList.com Hosts List
  id: 4
user_rules: []
dhcp:
  enabled: false
  interface_name: ""
  gateway_ip: ""
  subnet_mask: ""
  range_start: ""
  range_end: ""
  lease_duration: 86400
  icmp_timeout_msec: 1000
clients: []
log_file: ""
verbose: false
schema_version: 3

EEE
	chmod 755 "$adg_file"
fi
}
adg_renum=`nvram get adg_renum`

adg_restart () {
relock="/var/lock/AdGuardHome_restart.lock"
if [ "$1" = "o" ] ; then
	nvram set adg_renum="0"
	[ -f $relock ] && rm -f $relock
	return 0
fi
if [ "$1" = "x" ] ; then
	adg_renum=${adg_renum:-"0"}
	adg_renum=`expr $adg_renum + 1`
	nvram set adg_renum="$adg_renum"
	if [ "$adg_renum" -gt "3" ] ; then
		I=19
		echo $I > $relock
		logger -t "【AdGuardHome】" "多次尝试启动失败，等待【"`cat $relock`"分钟】后自动尝试重新启动"
		while [ $I -gt 0 ]; do
			I=$(($I - 1))
			echo $I > $relock
			sleep 60
			[ "$(nvram get adg_renum)" = "0" ] && break
   			#[ "$(nvram get adg_enable)" = "0" ] && exit 0
			[ $I -lt 0 ] && break
		done
		nvram set adg_renum="1"
	fi
	[ -f $relock ] && rm -f $relock
fi
start_adg
}

find_bin() {
SVC_PATH="$(nvram get adg_bin)"

dirs="/etc/storage/bin
/tmp/AdGuardHome
/usr/bin"

if [ -z "$SVC_PATH" ] ; then
  for dir in $dirs ; do
    if [ -f "$dir/AdGuardHome" ] ; then
        SVC_PATH="$dir/AdGuardHome"
        [ ! -x "$SVC_PATH" ] && chmod +x $SVC_PATH
        break
    fi
  done
  [ -z "$SVC_PATH" ] && SVC_PATH="/tmp/AdGuardHome/AdGuardHome"
fi
}

dl_adg(){
logger -t "AdGuardHome" "下载AdGuardHome"
#wget --no-check-certificate -O /tmp/AdGuardHome.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.101.0/AdGuardHome_linux_mipsle.tar.gz
curl -k -s -o /tmp/AdGuardHome/AdGuardHome --connect-timeout 10 --retry 3 https://fastly.jsdelivr.net/gh/Joelyi/Padavan-build/adg/AdGuardHome
if [ ! -f "/tmp/AdGuardHome/AdGuardHome" ]; then
logger -t "AdGuardHome" "AdGuardHome下载失败，请检查是否能正常访问github!程序将退出。"
nvram set adg_enable=0
exit 0
else
logger -t "AdGuardHome" "AdGuardHome下载成功。"
chmod 777 /tmp/AdGuardHome/AdGuardHome
fi
}

adg_keep() {
	logger -t "【AdGuardHome】" "守护进程启动"
	if [ -s /tmp/script/_opt_script_check ]; then
	sed -Ei '/【AdGuardHome】|^$/d' /tmp/script/_opt_script_check
	cat >> "/tmp/script/_opt_script_check" <<-OSC
	[ -z "\`pidof AdGuardHome\`" ] && logger -t "进程守护" "AdGuardHome 进程掉线" && eval "$scriptfilepath start &" && sed -Ei '/【AdGuardHome】|^$/d' /tmp/script/_opt_script_check #【AdGuardHome】
	OSC

	fi

}

start_adg() {
  mkdir -p /tmp/AdGuardHome
  mkdir -p /etc/storage/AdGuardHome
  logger -t "【AdGuardHome】" "正在启动..."
  sed -Ei '/【AdGuardHome】|^$/d' /tmp/script/_opt_script_check
  find_bin
  [ ! -x "$SVC_PATH" ] && chmod +x $SVC_PATH
  [[ "$($SVC_PATH -h 2>&1 | wc -l)" -lt 3 ]] && rm $SVC_PATH
  if [ ! -f "$SVC_PATH" ] || [[ "$($SVC_PATH -h 2>&1 | wc -l)" -lt 3 ]] ; then
  dl_adg
  fi
  adgenable=$(nvram get adg_enable)
  if [ "$adgenable" = "1" ] ;then
  getconfig
  change_dns
  set_iptable
  logger -t "【AdGuardHome】" "运行 $SVC_PATH"
  [ ! -x "$SVC_PATH" ] && chmod +x $SVC_PATH
  eval "$SVC_PATH -c $adg_file -w /tmp/AdGuardHome -v" &
  sleep 4
  	if [ ! -z "`pidof AdGuardHome`" ] ; then
 		mem=$(cat /proc/$(pidof AdGuardHome)/status | grep -w VmRSS | awk '{printf "%.1f MB", $2/1024}')
   		cpui="$(top -b -n1 | grep -E "$(pidof AdGuardHome)" 2>/dev/null| grep -v grep | awk '{for (i=1;i<=NF;i++) {if ($i ~ /AdGuardHome/) break; else cpu=i}} END {print $cpu}')"
		logger -t "【AdGuardHome】" "运行成功！"
  		logger -t "【AdGuardHome】" "内存占用 ${mem} CPU占用 ${cpui}%"
  		adg_restart o
		echo `date +%s` > /tmp/vntcli_time
		vnt_rules
	else
		logger -t "【AdGuardHome】" "运行失败, 注意检查${VNTCLI}是否下载完整,10 秒后自动尝试重新启动"
  		sleep 10
  		adg_restart x
	fi
 adg_keep
  fi
  
}

stop_adg() {
scriptname=$(basename $0)
sed -Ei '/【AdGuardHome】|^$/d' /tmp/script/_opt_script_check
rm -rf /tmp/AdGuardHome
killall -9 AdGuardHome
killall AdGuardHome
del_dns
clear_iptable
logger -t "【AdGuardHome】" "关闭AdGuardHome"
if [ ! -z "$scriptname" ] ; then
	eval $(ps -w | grep "$scriptname" | grep -v $$ | grep -v grep | awk '{print "kill "$1";";}')
	eval $(ps -w | grep "$scriptname" | grep -v $$ | grep -v grep | awk '{print "kill -9 "$1";";}')
fi
}

case $1 in
start)
  start_adg &
  ;;
stop)
  stop_adg
  ;;
*)
  echo "check"
  ;;
esac
