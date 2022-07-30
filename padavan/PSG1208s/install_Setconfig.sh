#!/bin/bash

DESTDIR=/opt/rt-n56u
ROOTDIR=`pwd`


cp -f "${ROOTDIR}/${CONFIG_FILENAME}" "${DESTDIR}/trunk/.config"
cp -f "${ROOTDIR}/defaults.h" "${DESTDIR}/trunk/user/shared/defaults.h"
cp -f "${ROOTDIR}/kernel-3.4.x.config" "${DESTDIR}/trunk/configs/boards/PSG1208/kernel-3.4.x.config"
