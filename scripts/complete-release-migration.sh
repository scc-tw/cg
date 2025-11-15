#!/bin/bash
# Complete Release Migration Script
# Run this after the PR is merged to main

set -euo pipefail

# Configuration
REPO_OWNER="scc-tw"
REPO_NAME="cg"
TAG_VERSION="v1.0.2"
TAG_MESSAGE="Release v1.0.2 - Migrate to modern release workflow"

echo "=== Release Migration Script ==="
echo ""
echo "This script will:"
echo "1. Delete the legacy release branch"
echo "2. Create a ${TAG_VERSION} tag on main to trigger a release"
echo ""
echo "Prerequisites:"
echo "- The PR with CI changes and version bump must be merged to main"
echo "- You must have push access to the repository"
echo ""
echo "Press Ctrl+C to cancel, or press Enter to continue..."
read -r

# Ensure we're on main and up to date
echo ""
echo "Step 1: Updating main branch..."

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "Error: You have uncommitted changes in your working directory."
    echo "Please commit or stash your changes before running this script."
    exit 1
fi

git checkout main
git pull origin main

# Delete the remote release branch
echo ""
echo "Step 2: Deleting remote release branch..."
if git ls-remote --exit-code --heads origin release >/dev/null 2>&1; then
    git push origin --delete release
    echo "✓ Remote release branch deleted"
else
    echo "Note: Remote release branch does not exist or was already deleted"
fi

# Delete local release branch if it exists
if git show-ref --verify --quiet refs/heads/release; then
    echo "Deleting local release branch..."
    git branch -D release
fi

# Create and push the tag
echo ""
echo "Step 3: Creating ${TAG_VERSION} tag..."

# Check if tag already exists
if git rev-parse "${TAG_VERSION}" >/dev/null 2>&1; then
    echo "Error: Tag ${TAG_VERSION} already exists."
    echo "If you want to recreate it, delete it first with: git tag -d ${TAG_VERSION} && git push origin :${TAG_VERSION}"
    exit 1
fi

git tag -a "${TAG_VERSION}" -m "${TAG_MESSAGE}"

echo ""
echo "Step 4: Pushing tag to trigger release workflow..."
git push origin "${TAG_VERSION}"

echo ""
echo "=== Migration Complete! ==="
echo ""
echo "✓ Legacy release branch deleted"
echo "✓ Tag ${TAG_VERSION} created and pushed"
echo ""
echo "Next steps:"
echo "1. Go to https://github.com/${REPO_OWNER}/${REPO_NAME}/actions to monitor the release workflow"
echo "2. Once complete, verify the release at https://github.com/${REPO_OWNER}/${REPO_NAME}/releases"
echo ""
echo "Future releases: Just create and push a tag on main"
echo "  git tag -a v1.0.3 -m 'Release v1.0.3'"
echo "  git push origin v1.0.3"
