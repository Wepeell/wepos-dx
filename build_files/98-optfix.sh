#!/bin/bash

set -ouex pipefail

# Prevent glob from being used literally as a file
shopt -s nullglob

# Variables
VAR_OPT_DIR="/var/opt"
LIB_OPTFIX_DIR="/usr/lib/optfix"
TMPFILESD_CONF="/usr/lib/tmpfiles.d/optfix.conf"

# Check if /var/opt has content
if compgen -G "${VAR_OPT_DIR}/*" > /dev/null; then
	# Create /usr/lib/optfix
	mkdir -p /usr/lib/optfix

	# Move /var/opt to /usr/lib/optfix
	mv "${VAR_OPT_DIR}"/* "${LIB_OPTFIX_DIR}/"

	### Generate tmpfiles.d config
	# Create temporary file and set permissions
	TMPFILE="$(mktemp)"
	chmod 644 "$TMPFILE"

	# Creates symlinks from /var/opt/<installed folder> to /usr/lib/optfix/<installed folder> on boot
	for DIR in "${LIB_OPTFIX_DIR}"/*; do
		NAME_DIR=$(basename "$DIR")
		echo "L+? '${VAR_OPT_DIR}/${NAME_DIR}' - - - - ${LIB_OPTFIX_DIR}/${NAME_DIR}" >> "$TMPFILE"
	done

	# Move temporary file to optfix.conf
	mv "$TMPFILE" "${TMPFILESD_CONF}"
fi
