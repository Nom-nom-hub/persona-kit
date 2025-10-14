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

echo "Creating GitHub release for version: ${VERSION}"
echo "Repository: ${REPO_URL}"

# Check if release already exists
echo "Checking if release v${VERSION} already exists..."
CHECK_API_URL="${REPO_URL}/releases/tags/v${VERSION}"

if [ -n "${GITHUB_TOKEN:-}" ]; then
    check_response=$(curl -s -w "%{http_code}" -o /tmp/release_check.json \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/vnd.github.v3+json" \
        "${CHECK_API_URL}")
else
    echo "Error: GITHUB_TOKEN is required to create releases"
    exit 1
fi

check_http_code=$(echo "$check_response" | tail -n1)
check_body=$(cat /tmp/release_check.json 2>/dev/null || echo "")

# Clean up temporary file
rm -f /tmp/release_check.json

if [ "$check_http_code" = "200" ]; then
    echo "Release v${VERSION} already exists - skipping creation"
    echo "existing=true" >> "$GITHUB_OUTPUT"
    exit 0
elif [ "$check_http_code" != "404" ]; then
    echo "Error: Failed to check release status (HTTP ${check_http_code})"
    echo "Response: ${check_body}"
    exit 1
fi

# Prepare release notes content
if [ -f "${RELEASE_NOTES_FILE:-}" ]; then
    RELEASE_BODY=$(cat "$RELEASE_NOTES_FILE" | jq -Rs .)
else
    RELEASE_BODY=$(echo "Release v${VERSION}" | jq -Rs .)
fi

# Validate JSON before sending
if ! echo "$RELEASE_BODY" | jq empty 2>/dev/null; then
    echo "Error: Invalid release notes content"
    exit 1
fi

# Prepare release data with all recommended fields
RELEASE_DATA=$(cat <<EOF
{
  "tag_name": "v${VERSION}",
  "name": "v${VERSION}",
  "body": ${RELEASE_BODY},
  "draft": false,
  "prerelease": false,
  "generate_release_notes": false
}
EOF
)

# Validate the complete JSON payload
if ! echo "$RELEASE_DATA" | jq empty 2>/dev/null; then
    echo "Error: Invalid JSON payload"
    exit 1
fi

echo "Release data prepared successfully"

# Create the release using GitHub API
API_URL="${REPO_URL}/releases"

response=$(curl -s -w "\n%{http_code}" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Content-Type: application/json" \
    -d "${RELEASE_DATA}" \
    "${API_URL}")

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

# Handle different HTTP status codes
case $http_code in
    201)
        echo "Successfully created GitHub release v${VERSION}"
        ;;
    422)
        echo "Error: Unprocessable Entity (HTTP 422)"
        echo "This usually means:"
        echo "  - Release already exists"
        echo "  - Invalid tag name or release data"
        echo "  - Missing required fields"
        echo "Response: ${body}"
        exit 1
        ;;
    404)
        echo "Error: Not Found (HTTP 404)"
        echo "This usually means the repository or tag doesn't exist"
        echo "Response: ${body}"
        exit 1
        ;;
    401)
        echo "Error: Unauthorized (HTTP 401)"
        echo "GITHUB_TOKEN may be invalid or expired"
        echo "Response: ${body}"
        exit 1
        ;;
    403)
        echo "Error: Forbidden (HTTP 403)"
        echo "Insufficient permissions to create releases"
        echo "Response: ${body}"
        exit 1
        ;;
    409)
        echo "Error: Conflict (HTTP 409)"
        echo "Release already exists or there are conflicts"
        echo "Response: ${body}"
        exit 1
        ;;
    2*)
        echo "Successfully created GitHub release v${VERSION}"
        ;;
    *)
        echo "Error: Failed to create GitHub release (HTTP ${http_code})"
        echo "Response: ${body}"
        exit 1
        ;;
esac

# Extract upload URL for assets
upload_url=$(echo "$body" | jq -r '.upload_url // empty' | sed 's/{?name,label}$//')

if [ -n "$upload_url" ] && [ "$upload_url" != "null" ] && [ -d "dist" ]; then
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
echo "new_release=true" >> "$GITHUB_OUTPUT"