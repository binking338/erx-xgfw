#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#======================================================================================#
#   System Required:  EdgeMax V1.9                                                     #
#   Description: Uninstall Shadowsocks-libev For EdgeMax1.9                            #
#   Author: binking338 <binking338@qq.com><https://github.com/binking338>              #
#   Thanks: landvd <5586822@qq.com>                                                    #
#   Thanks: @madeye <https://github.com/madeye>                                        #
#                                                                                      #
#======================================================================================#
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
rm -f /usr/bin/chinadns
rm -f /usr/bin/ss-conf
rm -f /usr/bin/x-gfw
rm -fr /usr/local/xgfw
sed -i s/server=127.0.0.1#5353/server=114.114.114.114/ /etc/dnsmasq.conf
sed -i "s|no-resolv|# no-resolv|" /etc/dnsmasq.conf
echo "Uninstall Service Success"





