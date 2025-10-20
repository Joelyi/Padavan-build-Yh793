#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`

default_wifi_path="${DESTDIR}/trunk/proprietary/rt_wifi/rtpci/4.1.X.X"

    echo "--------------开始复制配置文件----------------------"
sudo rm -rf $default_wifi_path/mt76x3
sudo rm -rf $default_wifi_path/mt76x3_ap
cp -rf ${ROOTDIR}/. $default_wifi_path
	      echo "--------------复制配置文件结束------------------"
