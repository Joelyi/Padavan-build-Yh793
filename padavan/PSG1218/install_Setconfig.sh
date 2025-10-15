#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`
CONFIG_FILENAME=PSG1218.config

    echo "--------------开始复制配置文件----------------------"
cp -f "${ROOTDIR}/${CONFIG_FILENAME}" "${DESTDIR}/trunk/configs/templates/${CONFIG_FILENAME}"
#cp -f "${ROOTDIR}/defaults.h" "${DESTDIR}/trunk/user/shared/defaults.h"
#cp -f "${ROOTDIR}/kernel-3.4.x.config" "${DESTDIR}/trunk/configs/boards/PSG1218/kernel-3.4.x.config"
	      echo "--------------复制配置文件结束------------------"
