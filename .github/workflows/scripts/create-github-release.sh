#!/bin/bash

# create-github-release.sh - Create GitHub release with assets
# Usage: ./create-github-release.sh <version> [release_notes] [options]
# Options:
#   --force-delete-tag    Delete existing tag without prompting (for CI/CD)

set -euo pipefail

# Enable debug mode if DEBUG environment variable is set
if [ "${DEBUG:-false}" = "true" ]; then
    set -x
fi

# Parse command line arguments
FORCE_DELETE_TAG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force-delete-tag)
            FORCE_DELETE_TAG=true
            shift
            ;;
        -*)
            echo "Unknown option: $1"
            echo "Usage: $0 <version> [release_notes] [--force-delete-tag]"
            exit 1
            ;;
        *)
            if [ -z "${VERSION:-}" ]; then
                VERSION=$1
            elif [ -z "${RELEASE_NOTES_FILE:-}" ]; then
                RELEASE_NOTES_FILE=$1
            else
                echo "Too many arguments"
                echo "Usage: $0 <version> [release_notes] [--force-delete-tag]"
                exit 1
            fi
            shift
            ;;
    esac
done

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version> [release_notes] [--force-delete-tag]"
    exit 1
fi

# Validation functions
validate_version() {
    local version=$1
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Version '$version' is not a valid semantic version (expected format: x.y.z)"
        return 1
    fi
    return 0
}

validate_tag_name() {
    local tag_name=$1
    # GitHub tag name requirements:
    # - Cannot be empty
    # - Cannot start with a dot
    # - Cannot contain spaces or special characters except hyphens, underscores, and dots
    # - Cannot end with a dot
    # - Cannot be longer than 100 characters
    if [[ -z "$tag_name" ]]; then
        echo "Error: Tag name cannot be empty"
        return 1
    fi
    if [[ $tag_name =~ ^\. ]]; then
        echo "Error: Tag name cannot start with a dot"
        return 1
    fi
    if [[ $tag_name =~ \.\.$ ]]; then
        echo "Error: Tag name cannot end with a dot"
        return 1
    fi
    if [[ $tag_name =~ [[:space:]] ]]; then
        echo "Error: Tag name cannot contain spaces"
        return 1
    fi
    if [[ ${#tag_name} -gt 100 ]]; then
        echo "Error: Tag name cannot be longer than 100 characters"
        return 1
    fi
    return 0
}

check_git_tag_exists_locally() {
    local tag_name=$1
    if git tag -l | grep -q "^${tag_name}$"; then
        return 0  # Tag exists locally
    else
        return 1  # Tag does not exist locally
    fi
}

check_git_tag_exists_remotely() {
    local tag_name=$1
    if git ls-remote --tags origin | grep -q "refs/tags/${tag_name}$"; then
        return 0  # Tag exists remotely
    else
        return 1  # Tag does not exist remotely
    fi
}

delete_git_tag() {
    local tag_name=$1
    local force=${2:-false}

    echo "Deleting git tag: ${tag_name}"

    # Delete locally
    if [ "$force" = "true" ]; then
        git tag -d "$tag_name" 2>/dev/null || true
    else
        git tag -d "$tag_name"
    fi

    # Delete remotely
    if [ "$force" = "true" ]; then
        git push --delete origin "$tag_name" 2>/dev/null || true
    else
        git push --delete origin "$tag_name"
    fi
}

handle_tag_conflict() {
    local tag_name=$1

    echo ""
    echo "🔍 TAG CONFLICT DETECTED"
    echo "══════════════════════════════════════════════════"
    echo "The git tag '${tag_name}' exists but no GitHub release was found."
    echo ""
    echo "This can happen when:"
    echo "  • A previous release attempt failed after creating the tag"
    echo "  • The tag was created manually without a release"
    echo "  • There was a race condition during release creation"
    echo ""
    echo "Available options:"
    echo "  1. Delete the existing tag and recreate it"
    echo "  2. Use a different version number"
    echo "  3. Manually create the release for the existing tag"
    echo ""

    # Check if force delete is enabled
    if [ "$FORCE_DELETE_TAG" = "true" ]; then
        echo "🔧 FORCE DELETE ENABLED: Automatically deleting existing tag..."
        delete_git_tag "$tag_name"
        return 0
    fi

    # Check if running in interactive mode
    if [ -t 0 ]; then
        echo "Would you like to delete the existing tag and continue? (y/N)"

        read -r response
        case "$response" in
            [yY]|[yY][eE][sS])
                echo "Deleting tag '${tag_name}'..."
                delete_git_tag "$tag_name"
                return 0
                ;;
            *)
                echo "Tag not deleted. Please resolve the conflict manually."
                echo ""
                echo "To resolve manually:"
                echo "  1. Delete the tag: git tag -d ${tag_name}"
                echo "  2. Delete remote tag: git push --delete origin ${tag_name}"
                echo "  3. Run this script again"
                return 1
                ;;
        esac
    else
        echo "Running in non-interactive mode. Tag conflict must be resolved manually."
        echo ""
        echo "To resolve manually:"
        echo "  1. Delete the tag: git tag -d ${tag_name}"
        echo "  2. Delete remote tag: git push --delete origin ${tag_name}"
        echo "  3. Run this script again"
        echo ""
        echo "Alternatively, use --force-delete-tag to automatically delete the tag:"
        echo "  $0 ${VERSION} ${RELEASE_NOTES_FILE:-} --force-delete-tag"
        return 1
    fi
}

debug_log() {
    if [ "${DEBUG:-false}" = "true" ]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Get the repository URL from git remote
REPO_URL=$(git config --get remote.origin.url | sed 's/git@github.com:/https:\/\/github.com\//g' | sed 's/\.git$//')

if [ -z "$REPO_URL" ]; then
    echo "Error: Could not determine repository URL"
    exit 1
fi

echo "Creating GitHub release for version: ${VERSION}"
echo "Repository: ${REPO_URL}"

# Validate version format
if ! validate_version "$VERSION"; then
    exit 1
fi

# Validate tag name format
TAG_NAME="v${VERSION}"
if ! validate_tag_name "$TAG_NAME"; then
    exit 1
fi

debug_log "Version: $VERSION"
debug_log "Tag name: $TAG_NAME"

# Check if git tag already exists (locally and remotely)
echo "Checking if git tag ${TAG_NAME} already exists..."

# Check locally first
if check_git_tag_exists_locally "$TAG_NAME"; then
    echo "✓ Git tag '${TAG_NAME}' exists locally"

    # Check remotely
    if check_git_tag_exists_remotely "$TAG_NAME"; then
        echo "✓ Git tag '${TAG_NAME}' exists remotely"
    else
        echo "⚠ Git tag '${TAG_NAME}' exists locally but not remotely"
        echo "  This may indicate a sync issue between local and remote repositories"
    fi
else
    echo "✓ Git tag '${TAG_NAME}' does not exist locally"
fi

# Check if release already exists
echo "Checking if release ${TAG_NAME} already exists..."
CHECK_API_URL="${REPO_URL}/releases/tags/${TAG_NAME}"

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
    echo "Release ${TAG_NAME} already exists - skipping creation"
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
  "tag_name": "${TAG_NAME}",
  "name": "${TAG_NAME}",
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

# Debug: Show the exact JSON being sent (only in debug mode)
debug_log "JSON payload being sent to GitHub API:"
debug_log "$RELEASE_DATA"

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
        echo "Successfully created GitHub release ${TAG_NAME}"
        ;;
    422)
        echo "Error: Unprocessable Entity (HTTP 422)"
        echo ""
        echo "Debug information:"
        echo "  Tag name: ${TAG_NAME}"
        echo "  Version: ${VERSION}"
        echo "  JSON payload: ${RELEASE_DATA}"
        echo ""
        echo "Full API response: ${body}"

        # Check if this is a tag conflict issue
        if echo "$body" | jq -e '.message // .errors' >/dev/null 2>&1; then
            error_message=$(echo "$body" | jq -r '.message // "Unknown error"' 2>/dev/null)
            if echo "$error_message" | grep -qi "tag.*already exists" || echo "$body" | jq -e '.errors[]? | select(.code == "already_exists")' >/dev/null 2>&1; then
                echo ""
                echo "🔍 DIAGNOSIS: Git tag '${TAG_NAME}' exists but no GitHub release found"
                echo ""
                echo "This commonly occurs when:"
                echo "  • A previous release attempt failed after creating the tag"
                echo "  • The tag was created manually without creating a release"
                echo "  • There was a race condition during release creation"
                echo ""
                echo "🔧 AUTOMATIC RESOLUTION:"
                if handle_tag_conflict "$TAG_NAME"; then
                    echo ""
                    echo "✅ Tag conflict resolved. Please run this script again to create the release."
                    exit 0
                else
                    echo ""
                    echo "❌ Could not resolve tag conflict automatically."
                    exit 1
                fi
            fi
        fi

        echo ""
        echo "This error can also mean:"
        echo "  - Invalid tag name format (must match: ^v?[0-9]+\\.[0-9]+\\.[0-9]+(?:-.*)?$)"
        echo "  - Missing required fields in JSON payload"
        echo "  - Invalid JSON structure"
        echo ""

        # Try to extract specific error details from GitHub's response
        if echo "$body" | jq -e '.errors' >/dev/null 2>&1; then
            echo "Specific errors from GitHub API:"
            echo "$body" | jq -r '.errors[]? | "- \(.field // "unknown"): \(.message // .code)' 2>/dev/null || echo "  Could not parse error details"
        fi
        exit 1
        ;;
    404)
        echo "Error: Not Found (HTTP 404)"
        echo "This usually means the repository doesn't exist or GITHUB_TOKEN is invalid"
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
        echo "Successfully created GitHub release ${TAG_NAME}"
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

echo "GitHub release ${TAG_NAME} created successfully with assets"
echo "new_release=true" >> "$GITHUB_OUTPUT"