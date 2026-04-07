#!/bin/bash

set -ouex pipefail

# Remove following error when installing packages from repos:
# gpg: Fatal: can't create directory '/root/.gnupg': No such file or directory
mkdir -p /var/roothome

# Allow packages to install files into /opt
# These files needs to be copied into an immutable part of the image
mkdir -p /var/opt

# Disable Terra repo
# dnf5 -y config-manager setopt "terra*".enabled=false
# This should fix Anaconda ISO building
# sed -i 's/^enabled=.*/enabled=0/' /etc/yum.repos.d/terra-mesa.repo

### Version lock packages
packages_lock=(
	# localwp dependencies
	nss
	nss-softokn
	nss-softokn-freebl
	nss-sysinit
	nss-util
)

for pkg in "${packages_lock[@]}"; do
	rpm -q "$pkg" | while read -r nevra; do
		dnf5 versionlock add "$nevra"
	done
done
