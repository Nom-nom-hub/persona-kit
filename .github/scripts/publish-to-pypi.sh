#!/usr/bin/env bash
set -euo pipefail

# publish-to-pypi.sh
# Publish Python package to PyPI
# Usage: publish-to-pypi.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

echo "Publishing version $VERSION to PyPI..."

# Upload to PyPI using twine
twine upload dist/*

echo "Successfully published $VERSION to PyPI"