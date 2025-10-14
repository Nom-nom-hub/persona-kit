#!/bin/bash

# generate-release-notes.sh - Create detailed changelog/release notes for persona-kit
# Usage: ./generate-release-notes.sh <new_version> <previous_version>

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <new_version> <previous_version>"
    exit 1
fi

NEW_VERSION=$1
PREVIOUS_VERSION=${2:-}

echo "Generating release notes for persona-kit v${NEW_VERSION}"

# Ensure we're in the project root
cd "$(git rev-parse --show-toplevel)"

# Check if CHANGELOG.md exists
if [ ! -f "CHANGELOG.md" ]; then
    echo "Warning: CHANGELOG.md not found, generating basic release notes"
    cat > release_notes.md << EOF
## v${NEW_VERSION}

### Added
- Release v${NEW_VERSION}

### Changes
- See commit history for details

### Contributors
- $(git log --format='%an' --since="${PREVIOUS_VERSION}" | sort -u | paste -sd ',' -)
EOF
    echo "Generated basic release notes"
    exit 0
fi

# Extract release notes for the specific version from CHANGELOG.md
RELEASE_NOTES=""

# Try to find the version section in CHANGELOG.md
if [ -n "$PREVIOUS_VERSION" ]; then
    # Extract content between current and previous version
    awk "/^## \[${NEW_VERSION}\]/,/^## \[${PREVIOUS_VERSION}\]/" CHANGELOG.md | head -n -1
else
    # Extract content from current version to end of file
    awk "/^## \[${NEW_VERSION}\]/{flag=1} flag{print} /^\s*$/ && flag{exit}" CHANGELOG.md
fi | grep -v "^## \[" | while IFS= read -r line; do
    if [ -n "$line" ]; then
        RELEASE_NOTES="${RELEASE_NOTES}\n${line}"
    fi
done

# If we couldn't extract from CHANGELOG, generate basic notes with git history
if [ -z "$RELEASE_NOTES" ]; then
    echo "Could not extract release notes from CHANGELOG.md, generating from git history..."

    # Get commit history since last version
    if [ -n "$PREVIOUS_VERSION" ] && git tag --list | grep -q "v${PREVIOUS_VERSION}"; then
        SINCE_TAG="v${PREVIOUS_VERSION}"
    else
        # Get last 10 commits if no previous version
        SINCE_TAG="HEAD~10"
    fi

    # Generate release notes from git commits
    cat > release_notes.md << EOF
## v${NEW_VERSION}

### What's Changed

EOF

    # Add commit history
    git log --oneline --since="$SINCE_TAG" --pretty=format="- %s" >> release_notes.md

    # Add contributors
    CONTRIBUTORS=$(git log --format='%an' --since="$SINCE_TAG" | sort -u | grep -v "dependabot" | paste -sd ', ' -)
    if [ -n "$CONTRIBUTORS" ]; then
        echo -e "\n### Contributors\n- $CONTRIBUTORS" >> release_notes.md
    fi

else
    # Use extracted release notes
    cat > release_notes.md << EOF
## v${NEW_VERSION}${RELEASE_NOTES}

### Repository
- [View on GitHub]($(git config --get remote.origin.url | sed 's/\.git$//'))
- [Compare changes](https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:\/]//; s/\.git$//')/compare/v${PREVIOUS_VERSION}...v${NEW_VERSION})
EOF
fi

# Display generated release notes
echo "Generated release notes:"
echo "=========================="
cat release_notes.md

echo "Release notes saved to: release_notes.md"