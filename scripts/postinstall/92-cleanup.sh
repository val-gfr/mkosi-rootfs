#!/bin/bash

# based on https://github.com/redpesk-infra/rp-kickstarts/blob/batz-2.0-update/distro/redpesk-core.ks

echo "import gpg keys"
rpm --installroot="$BUILDROOT" --import $BUILDROOT/etc/pki/rpm-gpg/RPM-GPG-KEY*

# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f $BUILDROOT/var/lib/rpm/__db*

# Build image date in /etc/os-release
echo "BUILD_DATE=\"$(TZ='UTC+2' date '+%Y-%m-%d %H:%M:%S')\"" >> $BUILDROOT/etc/os-release

# setup systemd to boot to the right runlevel
#echo -n "Setting default runlevel to multiuser text mode"
#rm -f $BUILDROOT/etc/systemd/system/default.target
#ln -s $BUILDROOT/lib/systemd/system/multi-user.target $BUILDROOT/etc/systemd/system/default.target

# remove random seed, the newly installed instance should make it's own
rm -f $BUILDROOT/var/lib/systemd/random-seed
