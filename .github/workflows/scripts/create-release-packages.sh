#!/bin/bash

# create-release-packages.sh - Generate multiple package formats for persona-kit
# Usage: ./create-release-packages.sh [version]

set -euo pipefail

VERSION=${1:-}

echo "Creating release packages for persona-kit..."

# Ensure we're in the project root
cd "$(git rev-parse --show-toplevel)"

# Clean any existing dist directory
if [ -d "dist" ]; then
    echo "Cleaning existing dist directory..."
    rm -rf dist
fi

# Create dist directory
mkdir -p dist

# Install build dependencies if not already installed
if ! command -v python &> /dev/null; then
    echo "Error: Python is not installed or not in PATH"
    exit 1
fi

# Check if build package is installed
if ! python -c "import build" &> /dev/null; then
    echo "Installing build package..."
    python -m pip install build
fi

# Build source distribution (sdist) and wheel
echo "Building source distribution and wheel..."
python -m build

# Verify packages were created
if [ ! -d "dist" ]; then
    echo "Error: dist directory was not created"
    exit 1
fi

# List created packages
echo "Created packages:"
ls -la dist/

# Validate packages (optional but recommended)
if command -v twine &> /dev/null; then
    echo "Validating packages with twine..."
    twine check dist/*
else
    echo "Warning: twine not installed - skipping package validation"
    echo "Install twine with: pip install twine"
fi

# Create additional package formats if needed
# For Python packages, sdist and wheel are typically sufficient

# Generate checksums for packages
echo "Generating checksums..."
cd dist
if command -v sha256sum &> /dev/null; then
    sha256sum * > checksums.sha256
    echo "Created checksums.sha256"
elif command -v shasum &> /dev/null; then
    shasum -a 256 * > checksums.sha256
    echo "Created checksums.sha256"
else
    echo "Warning: sha256sum/shasum not available - skipping checksum generation"
fi

# List final packages with checksums
echo "Final release packages:"
ls -la
if [ -f "checksums.sha256" ]; then
    echo "With checksums file"
    ls -la checksums.sha256
fi

echo "Package creation completed successfully!"
echo "Packages ready for upload in: $(pwd)"