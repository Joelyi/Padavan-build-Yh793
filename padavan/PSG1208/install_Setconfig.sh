#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`/padavan/PSG1208`
CONFIG_FILENAME=PSG1208.config

    echo "--------------开始复制配置文件----------------------"
cp -f "${ROOTDIR}/${CONFIG_FILENAME}" "${DESTDIR}/trunk/configs/templates/${CONFIG_FILENAME}"
	      echo "--------------复制配置文件结束------------------"
