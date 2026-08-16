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

### Enable RPM Fusion Repository
# dnf5 -y config-manager setopt "rpmfusion-nonfree".enabled=true
# dnf5 -y config-manager setopt "rpmfusion-free".enabled=true
# dnf5 -y config-manager setopt "*rpmfusion*".enabled=true

# Packages to version lock
packages=(
    nss
    nss-softokn
    nss-softokn-freebl
    nss-sysinit
    nss-util
)
# Version lock packages
dnf5 versionlock add "${packages[@]}"
