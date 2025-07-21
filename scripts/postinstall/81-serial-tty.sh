#!/bin/bash

mkdir -p $BUILDROOT/etc/systemd/system/getty.target.wants

# manually add systemd service for serial
# following https://git.yoctoproject.org/poky/plain/meta/recipes-core/systemd/systemd-serialgetty.bb

cat << EOF > $BUILDROOT/usr/lib/systemd/system/serial-getty@.service
#  SPDX-License-Identifier: LGPL-2.1-or-later
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

[Unit]
Description=Serial Getty on LF0
Documentation=man:agetty(8) man:systemd-getty-generator(8)
Documentation=http://0pointer.de/blog/projects/serial-console.html
# Removed BindsTo and After=dev-%i.device
After=systemd-user-sessions.service getty-pre.target

# If additional gettys are spawned during boot then we should make
# sure that this is synchronized before getty.target, even though
# getty.target didn't actually pull it in.
Before=getty.target
IgnoreOnIsolate=yes

# IgnoreOnIsolate causes issues with sulogin, if someone isolates
# rescue.target or starts rescue.service from multi-user.target or
# graphical.target.
Conflicts=rescue.service
Before=rescue.service

[Service]
# The '-o' option value tells agetty to replace 'login' arguments with an
# option to preserve environment (-p), followed by '--' for safety, and then
# the entered username.
ExecStart=-/sbin/agetty -o '-p -- \\u' --keep-baud 115200,57600,38400,9600 - $TERM
Type=idle
Restart=always
UtmpIdentifier=%I
StandardInput=tty
StandardOutput=tty
TTYPath=/dev/%I
TTYReset=yes
TTYVHangup=yes
IgnoreSIGPIPE=no
SendSIGHUP=yes

[Install]
WantedBy=getty.target
EOF

# override symbolic link for ttyLF0 but it should be a variable
ln -sf $BUILDROOT/usr/lib/systemd/system/serial-getty@.service \
       $BUILDROOT/etc/systemd/system/getty.target.wants/serial-getty@ttyLF0.service

exit 0
