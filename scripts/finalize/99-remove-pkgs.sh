#!/bin/bash

## remove packages which are not needed here
dnf --installroot="$BUILDROOT" remove -y \
    acl \
    libacl

dnf --installroot="$BUILDROOT" autoremove -y
