#!/bin/bash

# iproute & iproute-tc instead of systemd-networkd
dnf --installroot="$BUILDROOT" install -y \
	iproute \
	iproute-tc

## install packages which have been previously removed
dnf --installroot="$BUILDROOT" install -y \
	setup \
	shadow-utils

## install red-pak (without libdnf5)
dnf --installroot="$BUILDROOT" install -y \
	redpak-core

# -- DEVELOPMENT PACKAGES -- #
[ -z "$DEV_PKGS" ] &&
	echo "-- /!\ -- Development packages are not installed into this image -- /!\ --" &&
	exit 0

# ncdu not present in redpesk so manually install it
dnf --installroot="$BUILDROOT" install -y https://dl.fedoraproject.org/pub/epel/9/Everything/aarch64/Packages/n/ncdu-1.22-1.el9.aarch64.rpm

exit 0