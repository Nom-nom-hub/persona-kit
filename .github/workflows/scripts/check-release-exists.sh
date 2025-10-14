#!/bin/bash

# check-release-exists.sh - Check if a release already exists for the given version
# Usage: ./check-release-exists.sh <version>

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

# Get the repository URL from git remote
REPO_URL=$(git config --get remote.origin.url | sed 's/git@github.com:/https:\/\/github.com\//g' | sed 's/\.git$//')

if [ -z "$REPO_URL" ]; then
    echo "Error: Could not determine repository URL"
    exit 1
fi

# Check if release exists using GitHub API
API_URL="${REPO_URL}/releases/tags/v${VERSION}"

echo "Checking if release exists for version: ${VERSION}"
echo "API URL: ${API_URL}"

if [ -n "${GITHUB_TOKEN:-}" ]; then
    response=$(curl -s -w "%{http_code}" -o /tmp/release_check.json \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/vnd.github.v3+json" \
        "${API_URL}")
else
    response=$(curl -s -w "%{http_code}" -o /tmp/release_check.json \
        -H "Accept: application/vnd.github.v3+json" \
        "${API_URL}")
fi

http_code=$(echo "$response" | tail -n1)
body=$(cat /tmp/release_check.json)

# Clean up temporary file
rm -f /tmp/release_check.json

if [ "$http_code" = "200" ]; then
    echo "exists=true" >> "$GITHUB_OUTPUT"
    echo "Release for version v${VERSION} already exists"
    exit 0
elif [ "$http_code" = "404" ]; then
    echo "exists=false" >> "$GITHUB_OUTPUT"
    echo "Release for version v${VERSION} does not exist - proceeding with release"
    exit 0
else
    echo "Error: Failed to check release status (HTTP ${http_code})"
    echo "Response: ${body}"
    exit 1
fi