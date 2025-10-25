#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`

default_path="${DESTDIR}/trunk/libs"

    echo "--------------开始复制配置文件----------------------"
sudo rm -rf ${DESTDIR}/libssl
cp -rf ${ROOTDIR}/. $default_path
	      echo "--------------复制配置文件结束------------------"