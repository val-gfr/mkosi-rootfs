#!/bin/bash

## remove redpesk packages which are not needed
#dnf --installroot="$BUILDROOT" remove -y \
#     redpesk-repos-config \
#     redpesk-repos \
#     redpesk-config \
#     redpesk-gpg-keys \
#     redpesk-release

## remove others packages
dnf --installroot="$BUILDROOT" remove -y \
      kbd

## only remove policycoreutils
dnf --installroot="$BUILDROOT" remove -y --setopt=clean_requirements_on_remove=0 \
      policycoreutils

## only remove alternatives
dnf --installroot="$BUILDROOT" remove -y --setopt=clean_requirements_on_remove=0 \
      libselinux-utils

## only remove shadow-utils
dnf --installroot="$BUILDROOT" remove -y --setopt=clean_requirements_on_remove=0 \
      passwd \
      shadow-utils

exit 0
