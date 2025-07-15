#!/bin/bash

rpm -qa --root $BUILDROOT | sort > $OUTPUTDIR/manifest.log
