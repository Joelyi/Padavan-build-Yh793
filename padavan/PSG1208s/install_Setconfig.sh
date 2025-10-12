#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`
CONFIG_FILENAME=PSG1208s.config

    echo "--------------开始复制配置文件----------------------"
#cp -f "${ROOTDIR}/defaults.h" "${DESTDIR}/trunk/user/shared/defaults.h"
cp -f "${ROOTDIR}/board.h" "${DESTDIR}/trunk/configs/boards/PSG1208/board.h"
cp -f "${ROOTDIR}/board.mk" "${DESTDIR}/trunk/configs/boards/PSG1208/board.mk"
cp -f "${ROOTDIR}/kernel-3.4.x.config" "${DESTDIR}/trunk/configs/boards/PSG1208/kernel-3.4.x.config"
	      echo "--------------复制配置文件结束------------------"
