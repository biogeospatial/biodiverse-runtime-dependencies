# Architecture

## Overview

`biodiverse-runtime-dependencies` builds, tests, packages and publishes
pre-built Perl runtime dependency stacks used by BiodiverseR.

The published dependency releases are consumed by BiodiverseR runtime
packaging workflows and are not intended for direct use by end users.

The repository exists to separate dependency construction from runtime
packaging.

Instead of rebuilding Perl, CPAN modules and supporting geospatial
libraries during every runtime packaging workflow, BiodiverseR can
consume versioned dependency releases produced by this repository.

## Runtime Dependency Stack

Current dependency stacks primarily consist of:

- Perl
- CPAN modules required by Biodiverse
- CPAN modules required by BiodiverseR
- Geo::GDAL::FFI
- Alien::gdal
- Alien::proj
- Alien::geos::af
- Supporting geospatial and system libraries

The exact contents may differ between platforms, but all dependency
stacks are published through a common release and metadata model.

## High-Level Architecture

```text
biodiverse-runtime-dependencies
        │
        ▼
 Build dependency stacks
        │
        ▼
 Create platform artifacts
        │
        ▼
 Generate metadata
        │
        ▼
 Publish GitHub Release
        │
        ▼
 Update releases.json
        │
        ▼
 Promote channels
```

Consumers resolve a channel to a release version and then download the
appropriate platform-specific dependency artifact.

```text
stable
    ↓
v1.0.0
    ↓
platform
    ↓
download URL
```

## Repository Responsibilities

This repository is responsible for:

- Building runtime dependency stacks.
- Running dependency validation tests.
- Packaging dependency releases.
- Publishing GitHub Releases.
- Maintaining release metadata.
- Managing release channels.
- Publishing checksums.

This repository is not responsible for:

- Building BiodiverseR runtime packages.
- Installing runtime dependencies for end users.
- Managing BiodiverseR releases.
- Managing BiodiverseR runtime startup behaviour.

Those responsibilities belong to BiodiverseR runtime packaging
workflows and BiodiverseR itself.

## Supported Platforms

The repository maintains a shared release stream for multiple platforms.

Current targets include:

```text
Windows x64
macOS ARM64
Linux x64
```

Every release version may contain one or more platform-specific
dependency artifacts.

Example:

```text
v1.0.0
├── Windows dependency release
├── macOS dependency release
└── Linux dependency release
```

## Release Model

Runtime dependency releases are generated from Git tags.

Example:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The release workflow:

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
Update releases.json
```

Git tags are the authoritative source of release version numbers.

## Metadata Architecture

Release metadata is stored in:

```text
releases.json
```

The metadata contains:

- Release channels.
- Available releases.
- Platform-specific download URLs.
- Platform-specific SHA256 checksums.

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

Metadata is generated automatically during release publication.

## Release Channels

Release promotion is managed using channels.

Current channels:

```text
stable
testing
development
```

### Stable

The recommended dependency release.

### Testing

A dependency release currently undergoing validation prior to promotion.

### Development

A dependency release intended for active development and experimentation.

Channels reference release versions rather than containing release
metadata themselves.

Example:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0"
  }
}
```

## Publication and Promotion

Publishing a release and promoting a release are separate actions.

Publishing:

```text
Create release
    ↓
Update releases.json
```

Promotion:

```text
Move channel pointer
```

Example:

```text
stable   → v1.0.0
testing  → v1.1.0
```

After validation:

```text
stable   → v1.1.0
```

This approach allows validation before broad adoption and supports
staged rollout of runtime dependency updates.

## Artifact Naming

Runtime dependency artifacts use a consistent naming convention.

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

Artifact names are generated automatically and correspond directly to
the release version.

## Consumer Workflow

A BiodiverseR runtime packaging workflow performs the following steps:

```text
Resolve channel
    ↓
Resolve release version
    ↓
Download dependency artifact
    ↓
Verify checksum
    ↓
Build runtime package
```

This removes the need to rebuild the complete Perl dependency stack
during every runtime packaging workflow.

## Design Principles

### Separation of Concerns

Dependency construction is separated from runtime packaging.

### Metadata-Driven Selection

Consumers use metadata rather than hard-coded versions.

### Reproducibility

Dependency releases should be reproducible and versioned.

### Automation

Release publication and metadata maintenance should be automated.

### Platform Independence

Platform-specific artifacts use a common release and metadata model.

## Related ADRs

- ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository
- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0003: Separate Release Publication from Promotion
- ADR-0004: Use Metadata-Driven Runtime Dependency Selection
- ADR-0005: Use Tag-Triggered Runtime Dependency Releases
- ADR-0006: Use Consistent Runtime Dependency Artifact Naming
