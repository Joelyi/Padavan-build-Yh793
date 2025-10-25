#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`

default_path="${DESTDIR}/trunk/proprietary/rt_wifi"

    echo "--------------开始复制配置文件----------------------"
sudo rm -rf ${DESTDIR}/trunk/linux-3.4.x/drivers/net/wireless/ralink/mt76x2_ap
sudo rm -rf ${DESTDIR}/trunk/linux-3.4.x/drivers/net/wireless/ralink/rt2860v2_ap
sudo rm -rf $default_path/rtpci/3.0.X.X/mt76x2
sudo rm -rf $default_path/rtpci/3.0.X.X/mt76x2_ap
sudo rm -rf $default_path/rtsoc\2.7.X.X/rt2860v2
sudo rm -rf $default_path/rtsoc\2.7.X.X/rt2860v2_ap
sudo rm -rf $default_path/rtsoc\2.7.X.X/rt2860v2_sta
cp -rf ${ROOTDIR}/. $default_path
	      echo "--------------复制配置文件结束------------------"
