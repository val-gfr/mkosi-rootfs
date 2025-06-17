#!/bin/bash

# systemd-networkd not present in redpesk so manually install it
dnf --installroot="$BUILDROOT" install -y https://dl.fedoraproject.org/pub/epel/9/Everything/aarch64/Packages/s/systemd-networkd-253.4-1.el9.aarch64.rpm

# systemd-networkd configuration (DHCP eth0)
cat << EOF > $BUILDROOT/etc/systemd/network/01-eth0.network
[Match]
Name=eth0

[Network]
DHCP=ipv4
EOF

# ncdu not present in redpesk so manually install it
dnf --installroot="$BUILDROOT" install -y https://dl.fedoraproject.org/pub/epel/9/Everything/aarch64/Packages/n/ncdu-1.22-1.el9.aarch64.rpm
