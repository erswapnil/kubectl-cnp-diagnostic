#!/bin/sh
set -e

# Repository Configuration
OWNER="erswapnil"
REPO="cnp-diagnostic"
# This MUST start with kubectl- to be recognized as a plugin
BINARY="kubectl-edbdiag"
INSTALL_PATH="/usr/local/bin"

echo "Installing $BINARY from $OWNER/$REPO..."

# 1. Download the tool (Ensure the file on GitHub is named kubectl-cnp-diagnostic)
curl -sSfL "https://raw.githubusercontent.com/$OWNER/$REPO/main/$BINARY" -o "$BINARY"

# 2. Make it executable
chmod +x "$BINARY"

# 3. Move to system path
if [ -w "$INSTALL_PATH" ]; then
    mv "$BINARY" "$INSTALL_PATH/"
else
    sudo mv "$BINARY" "$INSTALL_PATH/"
fi

echo "Installation successful! Run it using: kubectl edbdiag"
