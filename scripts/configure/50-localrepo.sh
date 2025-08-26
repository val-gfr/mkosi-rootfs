#!/bin/bash

jsonconf=$(cat)

# consider only one
buildsource=$(echo "$jsonconf" | jq -r '.BuildSources[0].Source')

localrepodir=tmp/mkosi.sandbox.localrepo
destrepo=$SRCDIR/$localrepodir/etc/yum.repos.d
buildrepo=$buildsource/$localrepodir

mkdir -p $destrepo

[ -z "$REDPESK_DISTRO" ] &&
	echo "REDPESK_DISTRO env variable not defined please provide it '-E REDPESK_DISTRO='" >&2 &&
	exit 1

echo "Generate mkosi.repo into $destrepo"  >&2

mkdir -p $destrepo
cat << EOF > $destrepo/mkosi.repo
[redpesk-bsp]
name=RedPesk BSP
baseurl=https://download.redpesk.bzh/redpesk-lts/$REDPESK_DISTRO/packages/$REDPESK_BSP/\$basearch/os/
enabled=1
priority=1
metadata_expire=3h
repo_gpgcheck=0
type=rpm
module_hotfixes=1
gpgcheck=0

[redpesk-config]
name=RedPesk Baseos
baseurl=https://download.redpesk.bzh/redpesk-config/
enabled=1
priority=98
metadata_expire=3h
repo_gpgcheck=0
type=rpm
module_hotfixes=1
gpgcheck=0

[redpesk-baseos]
name=RedPesk Baseos
baseurl=https://download.redpesk.bzh/redpesk-lts/$REDPESK_DISTRO/packages/baseos/\$basearch/os/
enabled=1
priority=2
metadata_expire=3h
repo_gpgcheck=0
type=rpm
module_hotfixes=1
gpgcheck=0
exclude=ca-certificates*,libafb*,pam*,shadow-utils*,passwd*

[redpesk-middleware]
name=RedPesk middle
baseurl=https://download.redpesk.bzh/redpesk-lts/$REDPESK_DISTRO/packages/middleware/\$basearch/os/
enabled=1
priority=98
metadata_expire=3h
repo_gpgcheck=0
type=rpm
module_hotfixes=1
gpgcheck=0
EOF

cat << EOF > $destrepo/redpesk-smack_a9d2c599--redpesk-lts-batz-2.0-update-build.repo
# external repo to have redpesk_smack experimental project (lightweight)
[redpesk-smack_a9d2c599--redpesk-lts-batz-2.0-update-build]
name=redpesk-smack_a9d2c599--redpesk-lts-batz-2.0-update-build
baseurl=https://aquarium-app.redpesk.bzh/kbuild/repos//redpesk-smack_a9d2c599--redpesk-lts-batz-2.0-update-build/latest/\$basearch?token=69dcf1e8-122f-4eea-8276-ab955fdf3e0a_f2311232-7af6-4ff6-b9d5-c84e703877a2
priority=1
module_hotfixes=1
skip_if_unavailable=False
metadata_expire=3h
repo_gpgcheck=0
enabled=1
EOF

echo "$jsonconf" | jq -c '.SandboxTrees+=[{"Source": '"\"$buildrepo\""', "Target": null}]'