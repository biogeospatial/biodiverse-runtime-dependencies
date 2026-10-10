# Development Workflow

This document describes how runtime dependency changes are developed, tested, released and promoted.

## Branch Structure

The repository uses the following long-lived branches:

```text
main
development
```

### main

Contains production-ready configurations and release workflows.

Only validated changes should be merged to `main`.

### development

Used for active runtime dependency development.

Examples:

```text
feature-perl-5.42
feature-gdal-upgrade
feature-linux-runtime
feature-macos-runtime
```

Feature branches should be merged into `development`.

## Development Process

### 1. Create a Feature Branch

Create a feature branch from `development`.

Example:

```bash
git checkout development
git pull
git checkout -b feature-gdal-upgrade
```

### 2. Implement Changes

Examples:

- Perl version upgrades.
- CPAN dependency updates.
- GDAL upgrades.
- Platform-specific fixes.

### 3. Validate Changes

Confirm that:

- Dependency builds succeed.
- Validation tests pass.
- Release workflows complete successfully.

### 4. Merge Into Development

After validation:

```text
feature branch
    ↓
development
```

### 5. Create a Development Release

After feature PRs are merged into `development`, create a release from
the development branch.

Example:

```bash
git checkout development

git tag -a v1.2.0 -m "Runtime dependency release v1.2.0"

git push origin v1.2.0
```

The release workflow will:

```text
Build dependencies
    ↓
Create release
    ↓
Add release metadata and update development channel
```

### 6. Verify Automatic Development Assignment

When the release workflow publishes the tag, it automatically updates
the `development` channel to reference the new release. Confirm that
`releases.json` contains the new release and that the channel points to
it.

Example:

```json
{
  "channels": {
    "development": "v1.2.0"
  }
}
```

### 7. Validate Release

Test the released dependency stack through consuming workflows.

Confirm:

- Dependencies download correctly.
- Checksums validate.
- Runtime packages build successfully.
- Runtime tests pass.

### 8. Promote to Testing

After validation:

```json
{
  "channels": {
    "testing": "v1.2.0"
  }
}
```

### 9. Promote to Stable

After broader validation:

```json
{
  "channels": {
    "stable": "v1.2.0"
  }
}
```

## Release Lifecycle

```text
Feature branch
    ↓
Development branch
    ↓
Release
    ↓
Development channel
    ↓
Testing channel
    ↓
Stable channel
```
## Channel Lifecycle

A release typically progresses through the following channels:

```text
development
    ↓
testing
    ↓
stable
```

Example:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0",
    "development": "v1.2.0"
  }
}
```

After validation:

```json
{
  "channels": {
    "stable": "v1.1.0",
    "testing": "v1.2.0",
    "development": "v1.3.0"
  }
}
```

This process allows validation to occur before a release becomes the recommended runtime dependency version.

## Rollback

If a release is unsuitable:

```text
Move channel back to previous release
```

Example:

Before:

```json
{
  "stable": "v1.2.0"
}
```

After rollback:

```json
{
  "stable": "v1.1.0"
}
```

A new release is not required.

## Bug Fix Workflow

Bug fixes are handled differently depending on whether the bug exists in a released version or only in unreleased development work.

### Bug Fixes in Unreleased Development Work

If a bug is identified in a feature branch or unreleased development work, create a fix branch from the branch that introduced the issue.

Example:

```text
development
    ↓
feature-perl-5.42
    ↓
feature-perl-5.42-fix
```

Workflow:

```text
feature-perl-5.42
        ↓
feature-perl-5.42-fix
        ↓
feature-perl-5.42
        ↓
development
```

This avoids introducing unrelated changes from other development work.

### Bug Fixes in Released Versions

If a bug exists in a published release, create the fix branch from `main`.

Example:

```text
main
    ↓
bugfix-v0.2.1
```

Workflow:

```text
main
    ↓
bugfix-v0.2.1
    ↓
main
    ↓
tag v0.2.1
```

The bug-fix release should contain only the required fix and no unrelated development work.

### Back-Merge After a Maintenance Release

After a bug fix has been released from `main`, merge the released changes back into `development`.

Workflow:

```text
bugfix-v0.2.1
    ↓
main
    ↓
tag v0.2.1
    ↓
development
```

This ensures that future releases inherit all bug fixes from previously released versions.

Without the back-merge, development branches may continue from code that does not contain the production fix.

### Example

Initial state:

```text
main
 └── v0.2.0 released

development
 ├── feature-perl-5.42
 ├── feature-gdal-upgrade
 └── feature-linux-runtime
```

A bug is discovered in `v0.2.0`.

Create:

```text
bugfix-v0.2.1
```

Apply the fix and merge:

```text
bugfix-v0.2.1
    ↓
main
```

Create release:

```text
tag v0.2.1
```

Then back-merge:

```text
main
    ↓
development
```

Result:

```text
main
 └── v0.2.1

development
 ├── fix from v0.2.1
 ├── feature-perl-5.42
 ├── feature-gdal-upgrade
 └── feature-linux-runtime
```

### Development Rule

Use the following rule of thumb:

```text
Bug exists only in unreleased work
    ↓
Branch from the relevant feature branch

Bug exists in a released version
    ↓
Branch from main
```

This keeps maintenance releases small and prevents unreleased development work from accidentally being included in production fixes.


## Principles

- Development is performed in branches.
- Consumption is controlled through channels.
- Publication and promotion are separate actions.
- Releases are immutable.
- Channel assignments are reversible.
