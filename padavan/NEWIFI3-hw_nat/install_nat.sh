#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`

default_nat_path="${DESTDIR}/trunk/linux-3.4.x/net/nat"

    echo "--------------开始复制配置文件----------------------"
sudo rm -rf $default_wifi_path/hw_nat
cp -rf ${ROOTDIR}/. $default_wifi_path
	      echo "--------------复制配置文件结束------------------"
