#!/bin/sh

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`

default_theme_path="${DESTDIR}/trunk/user/www"  # 默认文件配置目录

    echo "--------------开始复制主题----------------------"
sudo rm -rf $default_theme_path/n56u_ribbon_fixed
cp -rf ${ROOTDIR}/touming-Theme/. $default_theme_path
	echo "--------------复制主题文件结束------------------"
 
