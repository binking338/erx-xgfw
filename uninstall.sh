#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
run_cfg=/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper
run_op=/opt/vyatta/bin/vyatta-op-cmd-wrapper
#======================================================================================#
#   System Required:  EdgeMax V1.9                                                     #
#   Description: Uninstall Shadowsocks-libev For EdgeMax1.9                            #
#   Author: binking338 <binking338@qq.com><https://github.com/binking338>              #
#   Thanks: landvd <5586822@qq.com>                                                    #
#   Thanks: @madeye <https://github.com/madeye>                                        #
#                                                                                      #
#======================================================================================#
$run_cfg begin
$run_cfg delete service dns forwarding name-server
$run_cfg delete system name-server
$run_cfg commit
$run_cfg save
$run_cfg end

/etc/init.d/ss-redir stop
/etc/init.d/ss-tunnel stop
/etc/init.d/x-gfw stop
update-rc.d -f ss-redir remove
update-rc.d -f ss-tunnel remove
update-rc.d -f chinadns remove
update-rc.d -f x-gfw remove
rm -f /etc/init.d/ss-redir
rm -f /etc/init.d/ss-tunnel
rm -f /etc/init.d/x-gfw
rm -f /etc/cron.daily/update_namelist
rm -f /etc/dnsmasq.d/*_list.conf
rm -fr /etc/chinadns
rm -fr /usr/local/shadowsocks-libev
rm -fr /usr/local/pcre
rm -fr /etc/shadowsocks-libev
rm -f /usr/bin/ss-redir
rm -f /usr/bin/ss-tunnel
rm -fr /usr/local/chinadns
rm -f /usr/bin/ss_conf
rm -f /usr/bin/x-gfw
rm -fr /usr/local/xgfw

echo "Uninstall Service Success"





