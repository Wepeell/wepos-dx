#!/bin/bash

set -ouex pipefail

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
scripts=(
    /ctx/00-pre.sh
    /ctx/install-fedora-pkgs.sh
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
