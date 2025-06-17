#!/bin/bash

# systemd-networkd configuration (DHCP eth0)
cat << EOF > $BUILDROOT/etc/systemd/network/01-eth0.network
[Match]
Name=eth0

[Network]
DHCP=ipv4
EOF

# Dropbear default configuration (root/root port 22 -> to change later)
cat << EOF > $BUILDROOT/etc/systemd/system/dropbear.service
[Unit]
Description=Dropbear SSH server (IoT.bzh - basic configuration)
After=network.target

[Service]
ExecStartPre=/bin/sh -c 'mkdir -p /etc/dropbear && [ -f /etc/dropbear/dropbear_rsa_host_key ] || /bin/dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key'
ExecStart=/usr/sbin/dropbear -E -F -p 22 -r /etc/dropbear/dropbear_rsa_host_key
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# no systemd service for Dropbear by default
mkdir -p $BUILDROOT/etc/systemd/system-preset
cat << EOF > $BUILDROOT/etc/systemd/system-preset/00-dropbear.preset
enable dropbear.service
EOF
