# Build a minimal redpesk rootfs with mkosi

## Statement

My goal here is to easily build a rootfs (cpio format) which will be used as a ramdisk (like an initramfs).

At IoT.bzh, we're currently working on rootless builds for redpesk OS thanks to [mkosi](https://mkosi.systemd.io).

The issue with our [build method](https://docs.redpesk.bzh/docs/en/master/redpesk-factory/images-management/01-create-an-image.html#creation-of-a-custom-redpesk-os-image) is that this is not fully integrated on a standard host (outside a redpesk Factory stack).

So even our work with `mkosi` has not been released yet, I chose mkosi because:
- the redpesk rootfs must be easily customizable (scripts, packages...)
- the build can be done on my Linux host (Fedora 42 + rootless or with root privileges)
- the build method must be fast as possible (more than redpesk Factory + Anaconda/kickstarts)
- the output must be a cpio archive (and compress method must be a standard for U-Boot/Kernel)

## What is mkosi?

mkosi is a systemd tool that generates disk images [https://mkosi.systemd.io](https://mkosi.systemd.io).

For redpesk OS, the main goal is that it uses systemd-repart for making gpt
partitionning without any priviledge using libfdisk [https://www.freedesktop.org/software/systemd/man/latest/systemd-repart.html](https://www.freedesktop.org/software/systemd/man/latest/systemd-repart.html).

Have a look on the man page for more information:

```bash
mkosi --help
```

or directly online on mkosi github
[https://github.com/systemd/mkosi/blob/main/mkosi/resources/man/mkosi.1.md](https://github.com/systemd/mkosi/blob/main/mkosi/resources/man/mkosi.1.md)

## Build rootfs (cpio format)

### NXP S32G2 (my target is a [aarch64 architecture](https://docs.redpesk.bzh/docs/en/master/download/boards/docs/boards/nxp-s32g2.html) so it could be another one)

```bash
sudo mkosi --debug --debug-workspace \
--force \
-I mkosi-s32g2.conf \
-E REDPESK_DISTRO=batz-2.0-update \
--profile smack,minimal,localrepo \
--environment=MKOSI_DNF=dnf4
```

Please note I had issues with `dnf5` (on Fedora 42) that's why I moved the environment to `dnf4`.
This concerned some specific options of `mkosi` INI configuration files.

This build is not rootless because of SMACK labelling.

## Organisation

The idea is to have a configuration file by board/bsp and have different
configuration files into mkosi.conf.d/.

There is a default configuration file, load by everybody and after variations
are handled with mkosi profiles.

* `mkosi-*board*.conf` the entry config file for a specfic board
* `mkosi.conf.d` the directory of snippet of configuration files,
many of then can be activated passing profiles
    * `default.conf` default/common configuration
* `repart.d` the directory of snippet of partitions for systemd-repart
* `scripts` the directory of scripts executed during the image build

## Troubleshooting

### *Dynamic* Profiles/Include

In snippet configuration, if a new profile is wanted, it needs to be set and
included, indeed conf files are only parsed once so if the minimal profile
needs to be append see the example below:

```
# myconf.conf that append minimal
[Config]
Profiles=minimal # add minimal profile in the profiles list

[Include]
Include=mkosi.conf.d/minimal.conf # load minimal.conf
```

It also works for conditionnal includes, see the afb example to load the
afb-app-manager either for smack nor selinux:

```
# afb.conf
[Config]
Profiles=afb

[Include]
Include=mkosi.conf.d/afb-smack.conf
Include=mkosi.conf.d/afb-selinux.conf
...

# afb-selinux.conf

...
[TriggerMatch]
Profiles=selinux
Profiles=afb
```

In this example, the two files afb-smack and afb-selinux are included
but as it is written in the `TriggerMatch` of afb-selinux,
it needs the afb and the selinux profile to be triggered.

### For development

```bash
sudo mkosi --debug --debug-workspace \
--force \
-I mkosi-s32g2.conf \
-E REDPESK_DISTRO=batz-2.0-update \
--profile smack,minimal,localrepo,rpm-manual,dev \
--environment=MKOSI_DNF=dnf4
```