# Release Process

This document describes the process used to publish runtime dependency releases.

## Overview

Runtime dependency releases are published through GitHub Releases and
described in `releases.json`.

Each release may contain platform-specific dependency artifacts,
including:

- Windows x64
- macOS ARM64
- Linux x64

Release metadata is generated automatically as part of the release
workflow.

## Release Workflow

Runtime dependency releases are created from Git tags.

Example:

```bash
git tag -a v1.0.0 -m "Runtime dependency release v1.0.0"
git push origin v1.0.0
```

The release workflow performs the following steps:

```text
Tag release
    ↓
Build Windows dependencies
    ↓
Build macOS dependencies
    ↓
Build Linux dependencies
    ↓
Run validation tests
    ↓
Generate checksums
    ↓
Create GitHub Release
    ↓
Upload release assets
    ↓
Update releases.json and development channel
    ↓
Commit metadata updates
```

## Release Procedure

### 1. Ensure CI Is Passing

Confirm that all relevant dependency build workflows are succeeding.

Current workflows include:

- Windows
- macOS
- Linux

### 2. Create a Release Tag

Create and push a version tag:

```bash
git tag -a v1.0.0
git push origin v1.0.0
```

### 2.1 Use Annotated Tags

Runtime dependency releases should be created using annotated Git tags.

Annotated tags allow release-specific information to be recorded alongside
the release version and provide a permanent release history.

Example:

```bash
git tag -a v1.0.0 -m "Initial runtime dependency release"
git push origin v1.0.0
```

For larger releases, create the tag without a message argument and
provide a multi-line description:

```bash
git tag -a v1.0.0
```

Example tag message:

```text
Initial runtime dependency release

Platforms:
- macOS ARM64

Components:
- Perl 5.40.2
- Geo::GDAL::FFI
- Alien::gdal
- Alien::proj
- Alien::geos::af
```

The tag description becomes part of the release history and should
describe:

- The purpose of the release.
- Major dependency changes.
- Platform support.
- Notable fixes or improvements.

### 2.2 Maintain Release History

Every runtime dependency release should have a corresponding annotated
tag.

The release history is intended to provide a record of:

- Runtime dependency versions.
- Dependency upgrades.
- Platform support changes.
- Significant fixes.
- Channel promotion candidates.

Review release history using:

```bash
git tag -n99
```

or:

```bash
git show v1.0.0
```

Release history forms part of the project's long-term operational record
and should be maintained with meaningful release descriptions.

### 2.3 Create Release Notes

Each release should include a release note document.

Template:

```text
docs/releases/release-note-example.md
```

Recommended location:

```text
docs/releases/v1.0.0.md
docs/releases/v1.0.1.md
docs/releases/v1.1.0.md
```

Release notes should be prepared before creating a release tag and should describe:

- The purpose of the release.
- Significant dependency updates.
- Platform support.
- Validation performed.
- Known issues and limitations.
- Channel recommendations.

Example workflow:

```text
Create release notes
    ↓
Create annotated tag
    ↓
Publish release
```

Release notes form part of the project's permanent release history and should provide sufficient information for future maintainers to understand why a release was created and what changed.

The release note document should be referenced by the release tag annotation where practical.

Example:

```text
Release v1.0.0

See docs/releases/v1.0.0.md
```

Historical release notes should be retained as part of the repository documentation and should not be modified after publication except to correct factual errors.

### 3. Verify Release Build

The release workflow should:

- Build dependency artifacts.
- Run validation tests.
- Package release archives.
- Generate release metadata.
- Generate SHA256 checksums.

### 4. Verify GitHub Release

Confirm that a GitHub Release has been created and that the expected
release assets have been attached.

Examples:

```text
biodiverse-runtime-dependencies_windows_x64_v1.0.0.zip
biodiverse-runtime-dependencies_macos_arm64_v1.0.0.zip
biodiverse-runtime-dependencies_linux_x64_v1.0.0.zip
```

### 5. Verify Automatic Metadata Updates

The release workflow automatically:

- Generates release metadata.
- Generates SHA256 checksums.
- Updates `releases.json`.
- Commits metadata updates back to the repository.

Verify that the workflow successfully:

1. Creates or updates the GitHub Release.
2. Uploads the expected release assets.
3. Updates `releases.json` with the new release entry.
4. Creates a metadata commit.

Example:

```text
github-actions[bot]
Add runtime release to releases.json
```

### 6. Verify Channel Assignment

Confirm that the newly published release is assigned automatically to
`development`, and that `testing` and `stable` still reference the
expected versions.

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

Publishing a release automatically advances the `development` channel.
It does not change `testing` or `stable`; those channels are updated
separately after validation.

### 7. Promote the Release

After validation, update the appropriate channel.

Promotion is performed separately from release publication.

This may be done by:

- Manually updating `releases.json`, or
- Running a dedicated channel promotion workflow.

Example:

Before:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0"
  }
}
```

After promotion:

```json
{
  "channels": {
    "stable": "v1.1.0",
    "testing": "v1.1.0"
  }
}
```

Promotion does not require rebuilding or republishing release artifacts.

## Release Metadata

Runtime dependency metadata is stored in:

```text
releases.json
```

Example:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0",
    "development": "v1.2.0"
  },

  "releases": {
    "v1.0.0": {
      "windows": {
        "url": "...",
        "sha256": "..."
      },

      "macos": {
        "url": "...",
        "sha256": "..."
      },

      "linux": {
        "url": "...",
        "sha256": "..."
      }
    }
  }
}
```

## Channel Definitions

### Stable

The recommended dependency release for general use.

### Testing

A release undergoing validation before promotion.

### Development

A release intended for active development and experimentation.

## Artifact Naming

The repository generates two categories of artifacts:

- CI Artifacts
- Release Assets

### Release Assets

Release assets are generated from version tags and published through
GitHub Releases.

Format:

```text
biodiverse-runtime-dependencies___.zip
```

Examples:

```text
biodiverse-runtime-dependencies_windows_x64_v1.0.0.zip
biodiverse-runtime-dependencies_macos_arm64_v1.0.0.zip
biodiverse-runtime-dependencies_linux_x64_v1.0.0.zip
```

The version component must exactly match the Git tag used to create the
release.

Example:

```text
Tag: v1.0.0

Release Asset:
biodiverse-runtime-dependencies_macos_arm64_v1.0.0.zip
```

### CI Artifacts

CI artifacts are generated from source commits during development and
validation workflows.

Format:

```text
biodiverse-runtime-dependencies___
```

Examples:

```text
biodiverse-runtime-dependencies_windows_x64_d2ddf75
biodiverse-runtime-dependencies_macos_arm64_d2ddf75
biodiverse-runtime-dependencies_linux_x64_d2ddf75
```

CI artifacts are intended for:

- Development.
- Testing.
- Validation.
- Build traceability.

CI artifacts are not considered published releases and are not
referenced by `releases.json`.

## Checksums

Every published release asset must have an associated SHA256 checksum.

Checksums are generated automatically as part of the release workflow and
published in `releases.json`.

Consumers must verify downloaded artifacts before use.

## Validation

Before promoting a release to the `stable` channel, verify that:

- Dependency artifacts were built successfully.
- Validation tests passed.
- Metadata was generated successfully.
- Checksums were generated successfully.
- GitHub Release assets are available.
- `releases.json` was updated correctly.

## CI Artifacts vs Release Assets

CI artifacts and release assets serve different purposes.

### CI Artifacts

Generated from source commits.

Example:

```text
Commit
    ↓
biodiverse-runtime-dependencies_macos_arm64_d2ddf75
```

CI artifacts are intended for:

- Development.
- Validation.
- Troubleshooting.
- Build verification.

### Release Assets

Generated from version tags.

Example:

```text
Tag v1.0.0
    ↓
biodiverse-runtime-dependencies_macos_arm64_v1.0.0.zip
```

Release assets are:

- Published through GitHub Releases.
- Referenced by `releases.json`.
- Intended for consumption by BiodiverseR runtime packaging workflows.

Release assets represent officially published runtime dependency
releases.

## Related Documentation

- `README.md`
- `docs/architecture.md`
- `docs/channels.md`
- `docs/releases-json.md`
- `docs/development-workflow.md`
- `docs/adr/0001-use-shared-cross-platform-runtime-dependency-repository.md`
- `docs/adr/0002-use-runtime-dependency-release-channels.md`
- `docs/adr/0003-separate-release-publication-from-promotion.md`
- `docs/adr/0004-use-metadata-driven-runtime-dependency-selection.md`
- `docs/adr/0005-use-tag-triggered-runtime-dependency-releases.md`
- `docs/adr/0006-use-consistent-runtime-dependency-artifact-naming.md`
- `docs/adr/0007-use-shared-runtime-configuration-files.md`
- `docs/adr/0008-use-release-metadata-as-the-system-of-record.md`
