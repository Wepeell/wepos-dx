#!/bin/bash

set -ouex pipefail

### Links
# https://github.com/ublue-os/bazzite-dx/blob/main/build_files/20-install-apps.sh
# https://docs.docker.com/engine/install/fedora/
# https://docs.docker.com/engine/install/linux-postinstall

### Packages array
packages=(
	https://cdn.localwp.com/releases-stable/10.0.0+6907/local-10.0.0-linux.rpm
)

### Check if base image packages are being replaced
# Dry run
dnf5 -y install --setopt=tsflags=test "${packages[@]}" 2>&1 | tee /tmp/dryrun.log

# Check log for upgrading and downgrading
if grep -qE '^(Upgrading|Downgrading):' /tmp/dryrun.log; then
	echo "::notice::Detected package replacements. Aborting build."
	exit 1
fi

### Install packages
dnf5 -y install "${packages[@]}"
