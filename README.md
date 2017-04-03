# Tomato ML (Multi Language) #

Shibby's Tomato for ARM with full HFS+ support,
USB audio modules and translatable WEB interface.

Supported router models:

* ASUS - RT-N18U, RT-AC56U, RT-AC68U, RT-AC68R, RT-AC68P
* D-Link - DIR868L
* Netgear - R6250, R6300v2, R7000
* Huawei - WS880
* Xiaomi - MiWiFi (R1D)

maybe others...

Included languages:

* Russian
* Chinese (Simplified)

you can make your own ;-)

Compiled fw binaries can be found in [Downloads](https://bitbucket.org/tsynik/tomato-arm/downloads) section.

Linux machine required to build firmware.

Recommended (tested) system:  Ubuntu 14.04 or SuSE 13.2.

In case x64 arch, you need to install those x32 packages for toolchain:

On SuSE x64:
```
sudo zypper install libelf1-32bit
sudo ln -sf /usr/lib/libmpc.so.3 /usr/lib/libmpc.so.2
```
On Ubuntu x64:
```
sudo apt-get install libelf1:i386 zlib1g:i386 lib32stdc++6
```
Essential packages required to build firmware:
```
sudo apt-get install build-essential gcc libncurses5 libncurses5-dev m4 flex bison libtool automake pkg-config texinfo gawk
```
*Check contents of make[\*].sh in root directory, setup PATH, uncomment/add desired TARGET and RUN it.*

For MySQL build follow these instructions:

https://bitbucket.org/pl_shibby/tomato-arm/commits/58c291235d3f7011e8cae87eecaf5d1974b4712d

### Have fun! ###
