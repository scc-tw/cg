# Migration to Modern Release Workflow

This repository has been updated to use a modern release workflow where releases are triggered by tags on the `main` branch, rather than using a separate `release` branch.

## Changes Made

1. **Removed release branch ignore rule** from `.github/workflows/ci.yml`
   - The CI workflow no longer ignores the release branch since it will be deleted
   - All pushes to any branch will now trigger CI

2. **Release workflow already configured** (`.github/workflows/release.yml`)
   - The workflow triggers on tags matching `v*` pattern
   - No changes needed - it's already set up for the modern approach

## Steps to Complete Migration

### 1. Delete the Legacy Release Branch

Run the following command with appropriate permissions:

```bash
git push origin --delete release
```

Or use the GitHub web interface:
1. Go to https://github.com/scc-tw/cg/branches
2. Find the `release` branch
3. Click the trash icon to delete it

### 2. Create a New Release Tag

To trigger a new release, create and push a tag on the `main` branch:

```bash
# Ensure you're on the latest main branch
git checkout main
git pull origin main

# Create a new tag (use semantic versioning)
git tag -a v1.0.2 -m "Release v1.0.2"

# Push the tag to trigger the release workflow
git push origin v1.0.2
```

### 3. Verify the Release

After pushing the tag:
1. Go to https://github.com/scc-tw/cg/actions
2. You should see the "Release binary" workflow running
3. Once complete, check https://github.com/scc-tw/cg/releases for the new release

## Tag Naming Convention

Moving forward, use semantic versioning for tags:
- `v1.0.2` - Patch release (bug fixes)
- `v1.1.0` - Minor release (new features, backward compatible)
- `v2.0.0` - Major release (breaking changes)

The previous tag format (`v1.0.1-62-bf69087...`) included commit hashes, which is no longer necessary with this modern approach.
