#!/bin/bash

## remove redpesk packages which are not needed
# dnf --installroot="$BUILDROOT" remove -y \
#     redpesk-repos-config \
#     redpesk-repos \
#     redpesk-config \
#     redpesk-gpg-keys \
#     redpesk-release

## remove others packages
dnf --installroot="$BUILDROOT" remove -y \
      kbd

exit 0