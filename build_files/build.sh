#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

# systemctl enable podman.socket



### Install scripts

# Run script function
function run_script() {
	local script="$1"

	echo "Running $script..."

	if "$script"; then
		echo "$script completed!"
	else
		echo "$script failed! Exiting."
		exit 1
	fi
}

# Build scripts array
# Target scripts as elements
scripts=(
	/ctx/00-pre.sh
	/ctx/install-docker.sh
	/ctx/install-localwp.sh
	/ctx/install-vscode.sh
	/ctx/98-optfix.sh
	/ctx/99-post.sh
)

# Run each script in array
for script_element in "${scripts[@]}"; do
	run_script "$script_element"
done
