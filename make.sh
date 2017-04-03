#!/bin/sh
SRC=`pwd`/release/src-rt-6.x.4708

#
# TOOLCHAIN:
#
sudo ln -sf $SRC/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3
export PATH=$PATH:/opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3/bin

# SuSE x64 32bit libs for toolchain
# sudo zypper install libelf1-32bit
# sudo ln -sf /usr/lib/libmpc.so.3 /usr/lib/libmpc.so.2

# Ubuntu 14.04 LTS x64 32bit libs for toolchain
# sudo apt-get install libelf1:i386 zlib1g:i386

# Build Essentials
# sudo apt-get install build-essential gcc libncurses5 libncurses5-dev m4 bison flex libtool automake pkg-config

export LANG=C
export LC_ALL=en_US.UTF-8
cd $SRC
# echo " ---- Update sources from GIT ---- "
# git pull

### VERSION
VER="138"
export BUILDNR="0138"
EXTENDNO="ML-"`git rev-parse --verify HEAD --short`
# 1337
echo "1336" > linux/linux-2.6/.version

# CLEAN
make clean

#
# TARGETS (see release/src-rt-6.x.4708/Makefile):
#

# Huawei build
# export HUAWEI=y
# make V1=$VER- V2=$EXTENDNO ws880e	# VPN
# make V1=$VER- V2=$EXTENDNO ws880z	# AIO
# make V1=$VER- V2=$EXTENDNO ws880zz	# AIO Custom (no NGINX and SNMP)

# Xiaomi build
# export XIAOMI=y
# make V1=$VER- V2=$EXTENDNO r1dz	# AIO Custom EX

# Netgear r7000 initial build
# make V1=$VER- V2=$EXTENDNO r7000init	# AIO initial

# Asus build for RT-N18U, RT-AC56U, RT-AC68U, RT-AC68R, RT-AC68P
# make V1=$VER- V2=$EXTENDNO ac68e	# VPN
# make V1=$VER- V2=$EXTENDNO ac68z	# AIO

# ETC...
