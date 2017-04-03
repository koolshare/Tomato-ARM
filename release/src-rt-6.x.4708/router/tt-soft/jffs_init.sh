#!/bin/sh

[ -d /jffs/koolshare ] && exit 0
cp /rom/softcenter/softcenter.tar.gz /tmp
cd /tmp;tar -zxvf softcenter.tar.gz
sh /tmp/softcenter/install.sh
rm -rf /tmp/softcenter*
