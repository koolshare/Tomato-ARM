include ../common.mak
include $(SRCBASE)/router/.config

PKG_NAME:=hfsprogs
PKG_VERSION:=332.25

PKG_SOURCE:=diskdev_cmds-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.opensource.apple.com/tarballs/diskdev_cmds/
PKG_MD5SUM:=261c3de5ec0dcf5244e3f60d79c1d6f1

SRC_NAME=diskdev_cmds-$(PKG_VERSION)

THISDIR = $(shell pwd)

CFLAGS += \
	-DDEBUG_BUILD=0 \
	-D_FILE_OFFSET_BITS=64 \
	-DLINUX=1 -DBSD=1 \
	-I$(THISDIR)/$(SRC_NAME)/include \

LDFLAGS += -Wl,--as-needed \

all: config_test compile

config_test:
	( if [ -f ./config_done ]; then \
		echo "the same configuration"; \
	else \
		make configure && touch config_done; \
	fi )

configure:
	( test -d $(SRC_NAME) || tar -xzf $(PKG_SOURCE); \
	cd $(SRC_NAME) ; \
	patch -p1 < ../patches/0001-Create-short-Makefiles-for-Debian.patch ; \
	patch -p1 < ../patches/0002-Add-exclude-Darwin-specific-code.patch ; \
	patch -p1 < ../patches/0003-Add-helper-include-files-absent-from-the-upstream-pa.patch ; \
	patch -p1 < ../patches/0004-Fix-compilation-on-64-bit-arches.patch ; \
	patch -p1 < ../patches/0005-Remove-Apple-specific-p-from-strings.patch ; \
	patch -p1 < ../patches/0006-Adjust-types-for-printing.patch ; \
	patch -p1 < ../patches/0007-Fix-path-for-HFS-wrapper-block.patch ; \
	patch -p1 < ../patches/0008-Provide-command-line-option-a.patch ; \
	patch -p1 < ../patches/0009-Rename-dprintf-to-dbg_printf.patch ; \
	patch -p1 < ../patches/0010-Rename-custom-macro-nil-with-NULL.patch ; \
	patch -p1 < ../patches/0011-Fix-types.patch ; \
	patch -p1 < ../patches/0012-Fix-mkfs-not-creating-UUIDs-for-new-filesystems.patch ; \
	patch -p1 < ../patches/0013-Fix-manpages.patch ; \
	patch -p1 < ../patches/0014-uClibc_no_loadavg.patch ; \
	patch -p1 < ../patches/0015-sysctl-only-on-glibc.patch ; \
	)

compile:
	( cd $(SRC_NAME) ; \
	$(MAKE) -f Makefile.lnx CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" CC="$(CC)" \
	)

mkclean:
	if [ -f $(SRC_NAME)/Makefile.lnx ] ; then \
		$(MAKE) -C $(SRC_NAME) -f Makefile.lnx clean ; \
	fi ; \
	rm -f config_done

clean: mkclean
	-@rm -rf diskdev_cmds-332.25/*
	-@rmdir diskdev_cmds-332.25

romfs:
ifeq ($(TCONFIG_HFS),y)
	install -D $(THISDIR)/$(SRC_NAME)/fsck_hfs.tproj/fsck_hfs $(INSTALLDIR)/hfsprogs/sbin/fsck_hfs
	$(STRIP) $(INSTALLDIR)/hfsprogs/sbin/fsck_hfs
	cd $(INSTALLDIR)/hfsprogs/sbin && ln -sf fsck_hfs fsck.hfs
	cd $(INSTALLDIR)/hfsprogs/sbin && ln -sf fsck_hfs fsck.hfsplus
ifneq ($(NO_MKTOOLS),y)
	install -D $(THISDIR)/$(SRC_NAME)/newfs_hfs.tproj/newfs_hfs $(INSTALLDIR)/hfsprogs/sbin/newfs_hfs
	$(STRIP) $(INSTALLDIR)/hfsprogs/sbin/newfs_hfs
	cd $(INSTALLDIR)/hfsprogs/sbin && ln -sf newfs_hfs mkfs.hfs
endif
endif

