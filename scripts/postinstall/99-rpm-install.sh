#!/bin/bash

# systemd-networkd not present in redpesk so manually install it
dnf --installroot="$BUILDROOT" install -y https://dl.fedoraproject.org/pub/epel/9/Everything/aarch64/Packages/s/systemd-networkd-253.4-1.el9.aarch64.rpm

# ncdu not present in redpesk so manually install it
dnf --installroot="$BUILDROOT" install -y https://dl.fedoraproject.org/pub/epel/9/Everything/aarch64/Packages/n/ncdu-1.22-1.el9.aarch64.rpm
