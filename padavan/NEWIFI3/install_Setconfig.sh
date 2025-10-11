#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`
default_wifi_path="${DESTDIR}/trunk/linux-3.4.x/drivers/net/wireless/ralink"
CONFIG_FILENAME=NEWIFI3.config

    echo "--------------开始复制配置文件----------------------"
cp -f "${ROOTDIR}/defaults.h" "${DESTDIR}/trunk/user/shared/defaults.h"
sudo rm -rf $default_wifi_path/mt76x3
sudo rm -rf $default_wifi_path/mt76x3_ap
cp -rf ${ROOTDIR}NEWIFI3/mt7603-4.1.2.0/. $default_wifi_path
	      echo "--------------复制配置文件结束------------------"
