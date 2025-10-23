#!/bin/bash

# -- CLEANUP not needed for development -- #
[ -z "$DEV_PKGS" ] &&
	# Note that running rpm recreates the rpm db files which aren't needed for build
    rm -f $BUILDROOT/var/lib/rpm/__db* $BUILDROOT/var/lib/rpm/*.sqlite*
	exit 0
