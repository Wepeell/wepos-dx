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

# Clear cache to prevent this error:
# Failed to load RPM "/var/cache/libdnf5/@commandline-f1fcf1ce45c07955/packages/b33d97cee1a1c6ef-local-10.1.2-linux.rpm": /var/cache/libdnf5/@commandline-f1fcf1ce45c07955/packages/b33d97cee1a1c6ef-local-10.1.2-linux.rpm: not a rpm
rm -rf /var/cache/libdnf5/@commandline-*

# Check log for upgrading and downgrading
if grep -qE '^(Upgrading|Downgrading):' /tmp/dryrun.log; then
    echo "::notice::Detected package replacements. Aborting build."
    exit 1
fi

# Install packages
dnf5 -y install "${packages[@]}"
