#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`
CONFIG_FILENAME=NEWIFI3.config

    echo "--------------开始复制配置文件----------------------"
#cp -f "${ROOTDIR}/${CONFIG_FILENAME}" "${DESTDIR}/trunk/configs/templates/${CONFIG_FILENAME}"
cp -f "${ROOTDIR}/defaults.h" "${DESTDIR}/trunk/user/shared/defaults.h"
cp -f "${ROOTDIR}/common.h" "${DESTDIR}/trunk/user/httpd/common.h"
cp -f "${ROOTDIR}/Makefile" "${DESTDIR}/trunk/libs/libiconv/Makefile"
	      echo "--------------复制配置文件结束------------------"
