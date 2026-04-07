#!/bin/bash

set -ouex pipefail

### Links
# https://github.com/ublue-os/bazzite-dx/blob/main/build_files/20-install-apps.sh
# https://docs.docker.com/engine/install/fedora/
# https://docs.docker.com/engine/install/linux-postinstall

### Repofile
repofile="https://download.docker.com/linux/fedora/docker-ce.repo"

### Packages array
packages=(
    containerd.io
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
)

# Add repo
dnf5 config-manager addrepo --from-repofile="$repofile"

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

# Disable repo
dnf5 config-manager setopt docker-ce-stable.enabled=0

# Load iptable_nat module for docker-in-docker.
# See:
#   - https://github.com/ublue-os/bluefin/issues/2365
#   - https://github.com/devcontainers/features/issues/1235
mkdir -p /etc/modules-load.d && cat >>/etc/modules-load.d/ip_tables.conf <<EOF
iptable_nat
EOF

# Start Docker Engine service
systemctl enable docker
