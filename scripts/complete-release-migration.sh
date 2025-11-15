#!/bin/bash
# Complete Release Migration Script
# Run this after the PR is merged to main

set -e

echo "=== Release Migration Script ==="
echo ""
echo "This script will:"
echo "1. Delete the legacy release branch"
echo "2. Create a v1.0.2 tag on main to trigger a release"
echo ""
echo "Prerequisites:"
echo "- The PR with CI changes and version bump must be merged to main"
echo "- You must have push access to the repository"
echo ""
echo "Press Ctrl+C to cancel, or press Enter to continue..."
read

# Ensure we're on main and up to date
echo ""
echo "Step 1: Updating main branch..."
git checkout main
git pull origin main

# Delete the remote release branch
echo ""
echo "Step 2: Deleting remote release branch..."
git push origin --delete release || echo "Note: Release branch may already be deleted"

# Delete local release branch if it exists
if git show-ref --verify --quiet refs/heads/release; then
    echo "Deleting local release branch..."
    git branch -D release
fi

# Create and push the tag
echo ""
echo "Step 3: Creating v1.0.2 tag..."
git tag -a v1.0.2 -m "Release v1.0.2 - Migrate to modern release workflow"

echo ""
echo "Step 4: Pushing tag to trigger release workflow..."
git push origin v1.0.2

echo ""
echo "=== Migration Complete! ==="
echo ""
echo "✓ Legacy release branch deleted"
echo "✓ Tag v1.0.2 created and pushed"
echo ""
echo "Next steps:"
echo "1. Go to https://github.com/scc-tw/cg/actions to monitor the release workflow"
echo "2. Once complete, verify the release at https://github.com/scc-tw/cg/releases"
echo ""
echo "Future releases: Just create and push a tag on main"
echo "  git tag -a v1.0.3 -m 'Release v1.0.3'"
echo "  git push origin v1.0.3"
