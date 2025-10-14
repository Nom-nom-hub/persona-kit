#!/usr/bin/env bash
set -euo pipefail

# create-github-release.sh
# Create a GitHub release for the Python package
# Usage: create-github-release.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Remove 'v' prefix from version for release title
VERSION_NO_V=${VERSION#v}

echo "Creating GitHub release for $VERSION..."

# Create GitHub release with Python package files
gh release create "$VERSION" \
  --title "Persona Kit $VERSION_NO_V" \
  --notes-file release_notes.md \
  --latest

echo "Successfully created GitHub release for $VERSION"