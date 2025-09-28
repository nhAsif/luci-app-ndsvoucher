include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ndsvoucher
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=RoseNet Team <team@rosenet.example.com>

LUCI_TITLE:=LuCI Support for NDS Voucher System
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+nodogsplash +jsonfilter +curl

define Package/$(PKG_NAME)/conffiles
/etc/config/ndsvoucher
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature