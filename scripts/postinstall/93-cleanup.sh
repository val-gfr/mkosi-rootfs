#!/bin/bash

# based on https://github.com/redpesk-infra/rp-kickstarts/blob/batz-2.0-update/distro/redpesk-core.ks

echo "import gpg keys"
rpm --installroot="$BUILDROOT" --import $BUILDROOT/etc/pki/rpm-gpg/RPM-GPG-KEY*

# clean image installation cache
rm -rf $BUILDROOT/var/cache

# clean image installation logs
rm -rf $BUILDROOT/var/log/*

# clean dev/null created (by a package)?
rm -rf $BUILDROOT/dev/

# Extract buildroot SMACK labels (install the required package) only if SMACK labelling is supported at the build host
# for now, not possible because the apps aren't installed in the rootfs cpio:
#/buildroot/etc/mtab     security.SMACK64        _
#/buildroot/etc/skel/app-data    security.SMACK64        User:App-Shared
#/buildroot/home/0/app-data      security.SMACK64        User:App-Shared
#if [ -f /usr/bin/sec-xattr-extract ]; then
#    /usr/bin/sec-xattr-extract -d -m '^security.SMACK' $BUILDROOT/usr/smack_labels_rootfs $BUILDROOT/
#else
#    echo "sec-xattr-extract is NOT installed, please install it to be able to extract SMACK labels!"
#    exit 1
#fi
# This is currently coming from the S32G2 target so only copy the xattr labels file
cp ./scripts/postinstall/smack_labels_rootfs $BUILDROOT/usr/smack_labels_rootfs

# Remove all SELinux modules than PAM requires (not here in SMACK image)
for pam_file in afm-user-session login remote systemd-user; do
    sed -i '/pam_selinux.so/ s/^#*/#/' "$BUILDROOT/etc/pam.d/$pam_file"
done

# Delete unneeded documentation, manpages, licenses, etc
for dir_remove in bash-completion doc info licenses man zoneinfo ; do
    rm -rf "$BUILDROOT/usr/share/$dir_remove"
done

# setup systemd to boot to the right runlevel
#echo -n "Setting default runlevel to multiuser text mode"
#rm -f $BUILDROOT/etc/systemd/system/default.target
#ln -s $BUILDROOT/lib/systemd/system/multi-user.target $BUILDROOT/etc/systemd/system/default.target

# Remove modprobe modules which are no longer here
rm -f $BUILDROOT/usr/lib/systemd/system/modprobe*

# Remove useless systemd services
rm -f $BUILDROOT/usr/lib/systemd/system/systemd-firstboot.service
rm -f $BUILDROOT/usr/lib/systemd/system/systemd-logind.service

# remove random seed, the newly installed instance should make it's own
rm -f $BUILDROOT/var/lib/systemd/random-seed

[ -z "$DEV_PKGS" ] &&
    exit 0

# Build image date in /etc/os-release
echo "BUILD_DATE=\"$(TZ='UTC+2' date '+%Y-%m-%d %H:%M:%S')\"" >> $BUILDROOT/etc/os-release
