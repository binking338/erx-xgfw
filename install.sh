#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
run_cfg=/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper
run_op=/opt/vyatta/bin/vyatta-op-cmd-wrapper
#======================================================================================#
#   System Required:  EdgeMax V1.9                                                     #
#   Description: Install Shadowsocks-libev For EdgeMax1.9                              #
#   Author: binking338 <binking338@qq.com><https://github.com/binking338>              #
#   Thanks: landvd <5586822@qq.com>                                                    #
#   Thanks: @madeye <https://github.com/madeye>                                        #
#                                                                                      #
#======================================================================================#
until
echo "Please Select You Connect Mode"		
echo "1.PPPOE"
echo "2.DHCP"
echo "3.Static Ip"
echo "4.Exit Setup"
read select
test $select = 4
do
case $select in
	1)
    echo "You Select PPPOE"
	break;;
	2)
    echo "You Select DHCP"
	break;;
	3)
    echo "You Select Static IP"
	break;;
	4)
    echo "Exit Setup"
	exit;;
esac
done

until
echo "Please Select ShadowSocks Version"		
echo "1.ShadowSocks"
echo "2.ShadowSocksR"
read ssver
test $ssver = 2
do
case $ssver in
	1)
    echo "You Select ShadowSocks"
	break;;
	2)
    echo "You Select ShadowSocksR"
	break;;
esac
done

echo "Check System Libc6"
now_ver=$(apt-cache show libc6 | grep Version)
new_ver="Version: 2.19-18+deb8u6"
if [ "$now_ver" = "$new_ver" ];then
    echo "System Libc6 do not need to Upgrade"
else
    dpkg -i ./libc6_2.19-18+deb8u6_mipsel.deb
fi
echo "Update System libc6 Success"

if [ $select -eq 1 ];then
    $run_cfg begin
    $run_cfg set interfaces ethernet eth0 pppoe 0 name-server none
    $run_cfg set service dns forwarding name-server 127.0.0.1
    $run_cfg set system name-server 127.0.0.1
    $run_cfg set system offload hwnat enable
    $run_cfg set system offload ipsec enable
    $run_cfg commit
    $run_cfg save
    $run_cfg end
fi
if [ $select -eq 2 ];then
    $run_cfg begin
    $run_cfg set service dns forwarding name-server 127.0.0.1
    $run_cfg set system name-server 127.0.0.1
    $run_cfg set system offload hwnat enable
    $run_cfg set system offload ipsec enable
    $run_cfg commit
    $run_cfg save
    $run_cfg end
fi
if [ $select -eq 3 ];then
    $run_cfg begin
    $run_cfg set service dns forwarding name-server 127.0.0.1
    $run_cfg set system name-server 127.0.0.1
    $run_cfg set system offload hwnat enable
    $run_cfg set system offload ipsec enable
    $run_cfg commit
    $run_cfg save
    $run_cfg end
fi
echo "System Config Success"

# set ISP DNS
echo "Please input your ISP DNS:"
read -p "(Default DNS: 202.101.172.35):" DNSIP
[ -z "${DNSIP}" ] && DNSIP="202.101.172.35"

# Set shadowsocks-libev config service
echo "Please input service for shadowsocks-libev"
read -p "(Default service: xgfw.com):" shadowsocksservice
[ -z "${shadowsocksservice}" ] && shadowsocksservice="xgfw.com"
echo
echo "---------------------------"
echo "shadowsocksservice = ${shadowsocksservice}"
echo "---------------------------"
echo

# Set shadowsocks-libev config port
echo "Please input port for shadowsocks-libev"
read -p "(Default port: 8388):" shadowsocksport
[ -z "${shadowsocksport}" ] && shadowsocksport="8388"
echo
echo "---------------------------"
echo "shadowsocksport = ${shadowsocksport}"
echo "---------------------------"
echo

# Set shadowsocks-libev config password
echo "Please input password for shadowsocks-libev"
read -p "(Default password: 123456):" shadowsockspwd
[ -z "${shadowsockspwd}" ] && shadowsockspwd="123456"
echo
echo "---------------------------"
echo "password = ${shadowsockspwd}"
echo "---------------------------"
echo

# Set shadowsocks-libev config method
echo "Please input method for shadowsocks-libev"
read -p "(Default method: aes-256-cfb):" shadowsocksmethod
[ -z "${shadowsocksmethod}" ] && shadowsocksmethod="aes-256-cfb"
echo
echo "---------------------------"
echo "shadowsocksmethod= ${shadowsocksmethod}"
echo "---------------------------"
echo
if [ $ssver -eq 2 ];then
# Set shadowsocks-libev config protocol
echo "Please input protocol for shadowsocks-libev"
read -p "(Default protocol: origin):" shadowsocksprotocol
[ -z "${shadowsocksprotocol}" ] && shadowsocksprotocol="origin"
echo
echo "---------------------------"
echo "shadowsocksprotocol= ${shadowsocksprotocol}"
echo "---------------------------"
echo
# Set shadowsocks-libev config protocol_param
echo "Please input protocol_param for shadowsocks-libev"
read -p "(Default protocol_param: ""):" shadowsocksprotocol_param
[ -z "${shadowsocksprotocol_param}" ] && shadowsocksprotocol_param=""
echo
echo "---------------------------"
echo "shadowsocksprotocol_param= ${shadowsocksprotocol_param}"
echo "---------------------------"
echo
# Set shadowsocks-libev config obfs
echo "Please input obfs for shadowsocks-libev"
read -p "(Default obfs: "tls1.2_ticket_auth_compatible"):" shadowsocksobfs
[ -z "${shadowsocksobfs}" ] && shadowsocksobfs="tls1.2_ticket_auth_compatible"
echo
echo "---------------------------"
echo "shadowsocksobfs= ${shadowsocksobfs}"
echo "---------------------------"
echo
# Set shadowsocks-libev config obfs_param
echo "Please input obfs_param for shadowsocks-libev"
read -p "(Default obfs_param: ""):" shadowsocksobfs_param
[ -z "${shadowsocksobfs_param}" ] && shadowsocksobfs_param=""
echo
echo "---------------------------"
echo "shadowsocksobfs_param= ${shadowsocksobfs_param}"
echo "---------------------------"
echo
fi

echo "Copy files Start..."
cd `dirname $0`
if [ $ssver -eq 1 ];then
  cp -f -r ./soft/shadowsocks-libev /usr/local
  ssimpl="libev"
fi
if [ $ssver -eq 2 ];then
  cp -f -r ./soft/shadowsocks-libevR /usr/local/shadowsocks-libev
  ssimpl="libevR"
fi
cp -f -r ./bin/xgfw /usr/local/
cp -f -r ./soft/pcre /usr/local/
cp -f ./uninstall.sh /usr/local/xgfw/uninstall

ln -s /usr/local/shadowsocks-libev/bin/ss-redir /usr/bin/ss-redir
ln -s /usr/local/shadowsocks-libev/bin/ss-tunnel /usr/bin/ss-tunnel
ln -s /usr/local/xgfw/chinadns /usr/bin/chinadns
chmod +x /usr/local/shadowsocks-libev/bin/ss-redir
chmod +x /usr/local/shadowsocks-libev/bin/ss-tunnel
chmod +x /usr/local/xgfw/chinadns

ln -s /usr/local/xgfw/init.d/ss-redir /etc/init.d/ss-redir
ln -s /usr/local/xgfw/init.d/ss-tunnel /etc/init.d/ss-tunnel
ln -s /usr/local/xgfw/init.d/chinadns /etc/init.d/chinadns
ln -s /usr/local/xgfw/init.d/x-gfw /etc/init.d/x-gfw
ln -s /usr/local/xgfw/init.d/x-gfw /usr/bin/x-gfw
ln -s /usr/local/xgfw/update_namelist /etc/cron.daily/update_namelist
ln -s /usr/local/xgfw/ss-conf /usr/bin/ss-conf
ln -s /usr/local/xgfw/ss-blacklist /usr/bin/ss-blacklist
ln -s /usr/local/xgfw/ss-whitelist /usr/bin/ss-whitelist
chmod +x /usr/local/xgfw/init.d/*
chmod +x /usr/local/xgfw/*
# copy chinadns config
cp -f -r /usr/local/xgfw/chinadns /etc/
# copy dnsmasq config
cp -f /usr/local/xgfw/dnsmasq.d/*.conf /etc/dnsmasq.d/
# config firewall rules
sed -i "s/fuckgfw.com/${shadowsocksservice}/g" /usr/local/xgfw/update_iptables
sed -i "s/8388/${shadowsocksport}/g" /usr/local/xgfw/update_iptables

update-rc.d ss-redir defaults
update-rc.d ss-tunnel defaults
update-rc.d chinadns defaults
update-rc.d x-gfw defaults
echo "Copy files Success"

# config & start chinadns service
set -i "s/202.101.172.35/${DNSIP}/" /usr/local/xgfw/init.d/chinadns
/etc/init.d/chinadns start
echo "Configure & Start chinadns Success"

# config & start ss service 
/usr/local/xgfw/ss-conf $ssimpl $shadowsocksservice $shadowsocksport $shadowsockspwd $shadowsocksmethod $shadowsocksprotocol $shadowsocksprotocol_param $shadowsocksobfs $shadowsocksobfs_param
echo "Configure & Start SS Success"

# config & start x-gfw service
set -i "s/202.101.172.35/${DNSIP}/" /usr/local/xgfw/init.d/x-gfw
/etc/init.d/x-gfw start

until
echo "do you want to update_namelist now? (y/n)"
read select
test $select = n
do
case $select in
    y)
    /usr/local/xgfw/update_namelist
    break;;
    n)
    break;;
esac
done

echo "--------------------------------------------------------"
echo "Install x-gfw Success"
echo
x-gfw help
echo
ss-conf help
echo
ss-blacklist help
echo
ss-whitelist help
echo
echo "Enjoy!"
