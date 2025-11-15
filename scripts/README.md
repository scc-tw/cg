# Scripts Directory

This directory contains utility scripts for the cg repository.

## complete-release-migration.sh

This script completes the migration from the legacy release branch workflow to the modern tag-based release workflow.

### Usage

After the PR that updates the CI workflow and bumps the version is merged to main:

```bash
./scripts/complete-release-migration.sh
```

### What it does

1. Ensures you're on the latest main branch
2. Deletes the legacy `release` branch from remote and local
3. Creates an annotated tag `v1.0.2` on the current main commit
4. Pushes the tag to trigger the release workflow

### Requirements

- Git must be configured with push access to the repository
- The PR with version bump and CI changes must be merged to main first
