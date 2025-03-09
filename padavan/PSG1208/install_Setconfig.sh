#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`
CONFIG_FILENAME=PSG1208_nano.config

    echo "--------------开始复制配置文件----------------------"
cp -f "${ROOTDIR}/${CONFIG_FILENAME}" "${DESTDIR}/trunk/configs/templates/${CONFIG_FILENAME}"
	      echo "--------------复制配置文件结束------------------"
