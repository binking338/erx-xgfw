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
	1)echo "You Select PPPOE"
	break;;
	2)echo "You Select DHCP"
	break;;
	3)echo "You Select Static ip"
	break;;
	4)echo "Exit Setup"
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
	1)echo "You Select ShadowSocks"
	break;;
	2)echo "You Select ShadowSocksR"
	break;;
esac
done

now_ver=$(apt-cache show libc6 | grep Version)
new_ver="Version: 2.19-18+deb8u6"
if [ "$now_ver" = "$new_ver" ];then
echo "Libc6 already!Not Upgrade"
else
dpkg -i ./libc6_2.19-18+deb8u6_mipsel.deb
fi
echo "Update System libc6 Success"

if [ $select -eq 1 ];then
$run_cfg begin
$run_cfg set interfaces ethernet eth0 pppoe 0 name-server none
#$run_cfg set service dns forwarding name-server 127.0.0.1
#$run_cfg set system name-server 127.0.0.1
$run_cfg set system offload hwnat enable
$run_cfg set system offload ipsec enable
$run_cfg commit
$run_cfg save
$run_cfg end
fi
if [ $select -eq 2 ];then
$run_cfg begin
#$run_cfg set service dns forwarding name-server 127.0.0.1
#$run_cfg set system name-server 127.0.0.1
$run_cfg set system offload hwnat enable
$run_cfg set system offload ipsec enable
$run_cfg commit
$run_cfg save
$run_cfg end
fi
if [ $select -eq 3 ];then
$run_cfg begin
#$run_cfg set service dns forwarding name-server 127.0.0.1
#$run_cfg set system name-server 127.0.0.1
$run_cfg set system offload hwnat enable
$run_cfg set system offload ipsec enable
$run_cfg commit
$run_cfg save
$run_cfg end
fi
echo "System Config Success"

if [ $ssver -eq 1 ];then
cp -f -r ./soft/shadowsocks-libev /usr/local
fi
if [ $ssver -eq 2 ];then
cp -f -r ./soft/shadowsocks-libevR /usr/local/shadowsocks-libev
fi

ln -s /usr/local/shadowsocks-libev/bin/ss-redir /usr/bin/ss-redir
ln -s /usr/local/shadowsocks-libev/bin/ss-tunnel /usr/bin/ss-tunnel
cp -f -r ./soft/pcre /usr/local/
chmod +x /usr/local/shadowsocks-libev/bin/ss-redir
chmod +x /usr/local/shadowsocks-libev/bin/ss-tunnel
echo "Install SS Success"

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
read -p "(Default port: 10470):" shadowsocksport
[ -z "${shadowsocksport}" ] && shadowsocksport="10470"
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
if [ ! -d /etc/shadowsocks-libev ]; then
    mkdir -p /etc/shadowsocks-libev
fi
if [ $ssver -eq 1 ];then
    cat > /etc/shadowsocks-libev/config.json<<-EOF
{
    "server":"${shadowsocksservice}",
    "server_port":${shadowsocksport},
    "local_address":"0.0.0.0",
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":600,
    "method":"${shadowsocksmethod}",
}
EOF
fi
if [ $ssver -eq 2 ];then
    cat > /etc/shadowsocks-libev/config.json<<-EOF
{
    "server":"${shadowsocksservice}",
    "server_port":${shadowsocksport},
    "local_address":"0.0.0.0",
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":600,
    "method":"${shadowsocksmethod}",
    "protocol":"${shadowsocksprotocol}",
    "protocol_param":"${shadowsocksprotocol_param}",
    "obfs":"${shadowsocksobfs}",
    "obfs_param":"${shadowsocksobfs_param}"
}
EOF
fi
echo "write /etc/shadowsocks-libev/config.json success"
echo "Install Configure File  Success"

cp -f -r ./bin/xgfw /usr/local/
ln -s /usr/local/xgfw/init.d/ss-redir /etc/init.d/ss-redir
#ln -s /usr/local/xgfw/init.d/ss-tunnel /etc/init.d/ss-tunnel
ln -s /usr/local/xgfw/init.d/x-gfw /etc/init.d/x-gfw
cp -f /usr/local/xgfw/dnsmasq.d/*.conf /etc/dnsmasq.d/
ln -s /usr/local/xgfw/update_namelist /etc/cron.daily/update_namelist
chmod +x /usr/local/xgfw/init.d/ss-redir
chmod +x /usr/local/xgfw/init.d/ss-tunnel
chmod +x /usr/local/xgfw/init.d/x-gfw
chmod +x /usr/local/xgfw/gfwlist2dnsmasq.sh
chmod +x /usr/local/xgfw/update_namelist
chmod +x /usr/local/xgfw/update_iptables
sed -i "s/fuckgfw.com/${shadowsocksservice}/g" /usr/local/xgfw/update_iptables
sed -i "s/8388/${shadowsocksport}/g" /usr/local/xgfw/update_iptables

/usr/local/xgfw/update_namelist

update-rc.d ss-redir defaults
#update-rc.d ss-tunnel defaults
update-rc.d x-gfw defaults
/etc/init.d/ss-redir start
#/etc/init.d/ss-tunnel start
/etc/init.d/x-gfw start
echo "Install Service & Set Service Success"
echo "Enjoy For SS System"
