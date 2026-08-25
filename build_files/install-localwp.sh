#!/bin/bash

set -ouex pipefail

### Links
# https://localwp.com/releases/

# Packages to install
packages=(
    https://cdn.localwp.com/releases-stable/10.1.2+7004/local-10.1.2-linux.rpm
)

# Check if base image packages are being replaced with a dry run
dnf5 --setopt=tsflags=test -y install "${packages[@]}" 2>&1 | tee /tmp/dryrun.log

# Check log for upgrading and downgrading
if grep -qE '^(Upgrading|Downgrading):' /tmp/dryrun.log; then
    echo "::notice::Detected package replacements. Aborting build."
    exit 1
fi

# Install packages
dnf5 -y install "${packages[@]}"
