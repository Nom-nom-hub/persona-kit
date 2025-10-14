#!/usr/bin/env bash
set -euo pipefail

# generate-release-notes.sh
# Generate release notes based on commits since the last release
# Usage: generate-release-notes.sh <new_version> <latest_tag>

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <new_version> <latest_tag>" >&2
  exit 1
fi

NEW_VERSION="$1"
LATEST_TAG="$2"

echo "Generating release notes for $NEW_VERSION..."

# Generate release notes from git log
git log --pretty=format:"- %s (%h)" ${LATEST_TAG}..HEAD > release_notes.md

# Add version header
sed -i "1i## Changes in ${NEW_VERSION}" release_notes.md

echo "Release notes generated in release_notes.md"