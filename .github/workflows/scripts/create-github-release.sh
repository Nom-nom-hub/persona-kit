#!/bin/bash

# create-github-release.sh - Create GitHub release with assets
# Usage: ./create-github-release.sh <version> [release_notes]

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <version> [release_notes]"
    exit 1
fi

VERSION=$1
RELEASE_NOTES_FILE=${2:-}

# Get the repository URL from git remote
REPO_URL=$(git config --get remote.origin.url | sed 's/git@github.com:/https:\/\/github.com\//g' | sed 's/\.git$//')

if [ -z "$REPO_URL" ]; then
    echo "Error: Could not determine repository URL"
    exit 1
fi

# Prepare release data
RELEASE_DATA=$(cat <<EOF
{
  "tag_name": "v${VERSION}",
  "name": "v${VERSION}",
  "body": $(jq -Rs . <(if [ -f "${RELEASE_NOTES_FILE:-}" ]; then cat "${RELEASE_NOTES_FILE}"; else echo "Release v${VERSION}"; fi)),
  "draft": false,
  "prerelease": false
}
EOF
)

echo "Creating GitHub release for version: ${VERSION}"
echo "Repository: ${REPO_URL}"

# Create the release using GitHub API
API_URL="${REPO_URL}/releases"

if [ -n "${GITHUB_TOKEN:-}" ]; then
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Content-Type: application/json" \
        -d "${RELEASE_DATA}" \
        "${API_URL}")
else
    echo "Error: GITHUB_TOKEN is required to create releases"
    exit 1
fi

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
    echo "Successfully created GitHub release v${VERSION}"

    # Extract upload URL for assets
    upload_url=$(echo "$body" | jq -r '.upload_url' | sed 's/{?name,label}$//')

    if [ "$upload_url" != "null" ] && [ -d "dist" ]; then
        echo "Uploading release assets..."

        # Upload distribution packages as release assets
        for file in dist/*; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                echo "Uploading: $filename"

                # Upload asset
                asset_response=$(curl -s -w "\n%{http_code}" \
                    -H "Authorization: token ${GITHUB_TOKEN}" \
                    -H "Accept: application/vnd.github.v3+json" \
                    -H "Content-Type: application/octet-stream" \
                    --data-binary @"$file" \
                    "${upload_url}?name=${filename}&label=${filename}")

                asset_http_code=$(echo "$asset_response" | tail -n1)
                if [ "$asset_http_code" -ge 200 ] && [ "$asset_http_code" -lt 300 ]; then
                    echo "Successfully uploaded asset: $filename"
                else
                    echo "Warning: Failed to upload asset $filename (HTTP ${asset_http_code})"
                fi
            fi
        done
    fi

    echo "GitHub release v${VERSION} created successfully with assets"
else
    echo "Error: Failed to create GitHub release (HTTP ${http_code})"
    echo "Response: ${body}"
    exit 1
fi