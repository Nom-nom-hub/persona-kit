#!/usr/bin/env bash
set -euo pipefail

# update-version.sh
# Update version in pyproject.toml
# Usage: update-version.sh <new_version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <new_version>" >&2
  exit 1
fi

NEW_VERSION="$1"

# Extract version number without 'v' prefix
VERSION_NO_V=${NEW_VERSION#v}

echo "Updating version in pyproject.toml to $VERSION_NO_V..."

# Update version in pyproject.toml
sed -i "s/^version = \".*\"/version = \"$VERSION_NO_V\"/" pyproject.toml

echo "Successfully updated version to $VERSION_NO_V"