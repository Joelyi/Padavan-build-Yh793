#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`

default_path="${DESTDIR}/trunk/user"

    echo "--------------开始复制配置文件----------------------"
sudo rm -rf $default_path/e2fsprogs
cp -rf ${ROOTDIR}/. $default_path
	      echo "--------------复制配置文件结束------------------"
