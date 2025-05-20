#!/bin/bash

rpm -qa --root $BUILDROOT > $OUTPUTDIR/manifest.log

# ln -s $BUILDROOT/sbin/init $BUILDROOT/init