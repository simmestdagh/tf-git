#!/usr/bin/env bash
set -e

BIN_DIR="${HOME}/.local/bin"
WRAPPER="$BIN_DIR/terraform"
REAL_TF="$BIN_DIR/terraform-real"

if [ -f "$WRAPPER" ]; then
  rm "$WRAPPER"
  echo "Removed wrapper: $WRAPPER"
fi

if [ -f "$REAL_TF" ]; then
  echo "Found terraform-real at: $REAL_TF"
  read -p "Do you want to restore it to the original location? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    ORIGINAL_LOCATION=$(which terraform-real 2>/dev/null || echo "/usr/local/bin/terraform")
    echo "Restoring terraform-real to: $ORIGINAL_LOCATION"
    sudo cp "$REAL_TF" "$ORIGINAL_LOCATION"
    echo "Restored terraform to: $ORIGINAL_LOCATION"
  else
    echo "Keeping terraform-real at: $REAL_TF"
  fi
fi

echo "Uninstall complete"

