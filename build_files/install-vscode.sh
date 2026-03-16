#!/bin/bash

set -ouex pipefail

### Links
# https://code.visualstudio.com/docs/setup/linux
# hhttps://github.com/ublue-os/bazzite-dx/blob/b4ac4255418da91567a920724059807fe4d8e36d/build_files/20-install-apps.sh

### Repo base URL
repo_base_url="https://packages.microsoft.com/yumrepos/vscode"

### Repo ID
repo_id="vscode"

### Package name
package_name="code"

### Enable repo
dnf5 -y config-manager addrepo --set=baseurl="$repo_base_url" --id="$repo_id"

# FIXME: gpgcheck is broken for vscode due to it using `asc` for checking
# seems to be broken on newer rpm security policies.
dnf5 config-manager setopt vscode.gpgcheck=0

### Check if base image packages are being replaced
# Dry run
dnf5 -y install --setopt=tsflags=test --nogpgcheck "$package_name" 2>&1 | tee /tmp/dryrun.log

# Check log for upgrading and downgrading
if grep -qE '^(Upgrading|Downgrading):' /tmp/dryrun.log; then
	echo ":notice::Detected package replacements. Aborting build."
	exit 1
fi

### Install package
dnf5 -y install --nogpgcheck "$package_name"

### Disable repo
dnf5 -y config-manager setopt "*${repo_id}*".enabled=false
