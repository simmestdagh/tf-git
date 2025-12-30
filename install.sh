#!/usr/bin/env bash
set -e

BIN_DIR="${HOME}/.local/bin"
REAL_TF="$(command -v terraform || true)"

if [ -z "$REAL_TF" ]; then
  echo "terraform not found on PATH"
  exit 1
fi

mkdir -p "$BIN_DIR"

# Move real terraform aside (safe)
if [ ! -f "$BIN_DIR/terraform-real" ]; then
  cp "$REAL_TF" "$BIN_DIR/terraform-real"
fi

# Install wrapper
curl -fsSL https://raw.githubusercontent.com/<org>/tf-git/main/terraform \
  -o "$BIN_DIR/terraform"

chmod +x "$BIN_DIR/terraform"

echo "Installed tf-git wrapper"
echo "Make sure $BIN_DIR is before terraform in PATH"

