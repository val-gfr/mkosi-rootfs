#!/bin/bash

# the build host needs dropbearkey (which comes from dropbear)
if rpm -qa | grep dropbear &>/dev/null; then
    if ! command -v dropbearkey &>/dev/null; then
        echo "Dropbear is installed but 'dropbearkey' not found in \$PATH."
        exit 1
    fi
    echo "Dropbear is installed, generating SSH keys..."
    if ! dropbearkey -t rsa -f "$BUILDROOT/etc/dropbear/dropbear_rsa_host_key"; then
        echo "Failed to generate Dropbear SSH keys."
        exit 1
    fi
else
    echo "Dropbear is NOT installed, please install it to be able to generate SSH keys"
    exit 1
fi

exit 0
