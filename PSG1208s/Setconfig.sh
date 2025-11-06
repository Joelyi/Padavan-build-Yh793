#!/bin/sh

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`
CONFIG_FILENAME=PSG1208s.config
	echo "--------------开始复制配置文件------------------"
      \cp -f ${ROOTDIR}/${CONFIG_FILENAME} ${DESTDIR}/trunk/configs/templates/${CONFIG_FILENAME}
      \cp -f ${ROOTDIR}/defaults.h ${DESTDIR}/trunk/user/shared/defaults.h
      \cp -f ${ROOTDIR}/kernel-3.4.x.config ${DESTDIR}/trunk/configs/boards/PSG1208/kernel-3.4.x.config
	if [ -e "${ROOTDIR}/Makefile" ] ; then
		cp -f "${ROOTDIR}/Makefile" "${DESTDIR}/trunk/user/www/"
	fi
  #
  if [ -e "${ROOTDIR}/CN.dict" ] ; then
		cp -f "${ROOTDIR}/CN.dict" "${DESTDIR}/trunk/user/www/dict/"
	fi
	echo "--------------复制配置文件结束------------------"
