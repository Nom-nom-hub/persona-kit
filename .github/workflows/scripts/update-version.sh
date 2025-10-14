#!/bin/bash

# update-version.sh - Update version in project files for persona-kit
# Usage: ./update-version.sh <new_version>

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <new_version>"
    exit 1
fi

NEW_VERSION=$1

echo "Updating version to $NEW_VERSION in project files..."

# Ensure we're in the project root
cd "$(git rev-parse --show-toplevel)"

# Update version in pyproject.toml
if [ -f "pyproject.toml" ]; then
    echo "Updating version in pyproject.toml..."

    # Update the main project version
    sed -i.bak "s/^version = \"[^\"]*\"/version = \"${NEW_VERSION}\"/" pyproject.toml

    # Update version in tool.persona-kit section if it exists
    if grep -q "tool\.persona-kit" pyproject.toml; then
        sed -i.bak "s/version = \"[^\"]*\"/version = \"${NEW_VERSION}\"/" pyproject.toml
    fi

    echo "Updated pyproject.toml"
else
    echo "Warning: pyproject.toml not found"
fi

# Update version in __init__.py if it exists
if [ -f "src/persona_kit_cli/__init__.py" ]; then
    echo "Updating version in __init__.py..."

    # Check if __version__ is defined
    if grep -q "__version__" src/persona_kit_cli/__init__.py; then
        sed -i.bak "s/__version__ = \"[^\"]*\"/__version__ = \"${NEW_VERSION}\"/" src/persona_kit_cli/__init__.py
        echo "Updated __init__.py"
    else
        echo "No __version__ found in __init__.py - skipping"
    fi
else
    echo "Warning: src/persona_kit_cli/__init__.py not found"
fi

# Update version in README.md if it exists and contains version references
if [ -f "README.md" ]; then
    echo "Checking for version references in README.md..."

    # Look for version badges or references that need updating
    if grep -q "persona-kit" README.md; then
        # Update PyPI badge URL if present
        if grep -q "pypi.org/project/persona-kit" README.md; then
            echo "README.md contains version references - manual update may be needed"
        else
            echo "No version-specific references found in README.md"
        fi
    fi
else
    echo "Warning: README.md not found"
fi

# Update version in CHANGELOG.md if needed
if [ -f "CHANGELOG.md" ]; then
    echo "Checking CHANGELOG.md for version updates..."

    # Check if the new version is already in the changelog
    if ! grep -q "^## \[${NEW_VERSION}\]" CHANGELOG.md; then
        echo "New version not found in CHANGELOG.md - you may need to add an entry"
    else
        echo "Version ${NEW_VERSION} already exists in CHANGELOG.md"
    fi
else
    echo "Warning: CHANGELOG.md not found"
fi

# Create a backup of modified files
echo "Creating backup of modified files..."
find . -name "*.bak" -type f | while IFS= read -r file; do
    echo "Backup created: $file"
done

# Verify the version was updated correctly
echo "Verifying version updates..."

if [ -f "pyproject.toml" ]; then
    UPDATED_VERSION=$(grep '^version = ' pyproject.toml | head -1 | sed 's/version = "\(.*\)"/\1/' | tr -d ' ')
    if [ "$UPDATED_VERSION" = "$NEW_VERSION" ]; then
        echo "✓ Version successfully updated in pyproject.toml"
    else
        echo "✗ Version update failed in pyproject.toml"
        echo "Expected: $NEW_VERSION, Found: $UPDATED_VERSION"
        exit 1
    fi
fi

# Clean up backup files (optional - remove if you want to keep them)
echo "Cleaning up backup files..."
find . -name "*.bak" -type f -delete

echo "Version update completed successfully!"
echo "Updated to version: $NEW_VERSION"
echo "You may need to manually update CHANGELOG.md if not already done"