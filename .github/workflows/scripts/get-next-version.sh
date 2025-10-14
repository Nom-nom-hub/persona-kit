#!/bin/bash

# get-next-version.sh - Determine next semantic version for persona-kit
# Usage: ./get-next-version.sh

set -euo pipefail

echo "Determining next version for persona-kit..."

# Ensure we're in the project root
cd "$(git rev-parse --show-toplevel)"

# Get the current version from pyproject.toml
if [ -f "pyproject.toml" ]; then
    CURRENT_VERSION=$(grep '^version = ' pyproject.toml | head -1 | sed 's/version = "\(.*\)"/\1/' | tr -d ' ')
    if [ -n "$CURRENT_VERSION" ]; then
        echo "Current version from pyproject.toml: $CURRENT_VERSION"
    else
        echo "Warning: Could not extract version from pyproject.toml"
        CURRENT_VERSION="0.0.0"
    fi
else
    echo "Warning: pyproject.toml not found, using default version"
    CURRENT_VERSION="0.0.0"
fi

# Get the latest git tag
LATEST_TAG=$(git tag --sort=-version:refname | head -1 | sed 's/^v//' || echo "")

if [ -n "$LATEST_TAG" ]; then
    echo "Latest git tag: v$LATEST_TAG"
    # Use the tag version if it's newer than pyproject.toml version
    if [ "$(printf '%s\n' "$LATEST_TAG" "$CURRENT_VERSION" | sort -V | tail -n1)" = "$LATEST_TAG" ]; then
        CURRENT_VERSION="$LATEST_TAG"
    fi
else
    echo "No git tags found, using pyproject.toml version"
fi

# Parse current version (expects semantic versioning: MAJOR.MINOR.PATCH)
IFS='.' read -r MAJOR MINOR PATCH << EOF
$CURRENT_VERSION
EOF

# Default to 0 if not set
MAJOR=${MAJOR:-0}
MINOR=${MINOR:-0}
PATCH=${PATCH:-0}

echo "Parsed version: $MAJOR.$MINOR.$PATCH"

# Determine version increment based on commit messages since last tag
# Check if there are commits since the last tag
if [ -n "$LATEST_TAG" ] && git rev-list "v$LATEST_TAG"..HEAD &>/dev/null; then
    echo "Analyzing commits since v$LATEST_TAG..."

    # Check for breaking changes (major version bump)
    if git log --oneline "v$LATEST_TAG"..HEAD | grep -qi "BREAKING CHANGE\|breaking change\|major:"; then
        echo "Found breaking changes - incrementing major version"
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
    # Check for features (minor version bump)
    elif git log --oneline "v$LATEST_TAG"..HEAD | grep -qi "feat:\|feature:\|minor:"; then
        echo "Found new features - incrementing minor version"
        MINOR=$((MINOR + 1))
        PATCH=0
    # Default to patch version bump
    else
        echo "No breaking changes or features found - incrementing patch version"
        PATCH=$((PATCH + 1))
    fi
else
    echo "No commits since last tag or no previous tag - starting with patch version"
    PATCH=$((PATCH + 1))
fi

# Generate new version
NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "new_version=$NEW_VERSION" >> "$GITHUB_OUTPUT"
echo "latest_tag=v$LATEST_TAG" >> "$GITHUB_OUTPUT"

echo "Next version determined: $NEW_VERSION"
echo "Previous tag: v$LATEST_TAG"

# Validate the new version
if ! echo "$NEW_VERSION" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' > /dev/null; then
    echo "Error: Generated version '$NEW_VERSION' is not a valid semantic version"
    exit 1
fi

# Check if this version already exists as a tag
if git tag | grep -q "v$NEW_VERSION"; then
    echo "Error: Tag v$NEW_VERSION already exists"
    exit 1
fi

echo "Version determination completed successfully!"