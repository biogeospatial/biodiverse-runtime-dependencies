# Biodiverse Runtime Dependencies

This repository builds, tests, packages and publishes pre-built Perl
runtime dependency stacks used by BiodiverseR.

The published artifacts contain Perl and associated runtime dependencies
required to build BiodiverseR runtime packages.

The published dependency releases are consumed by BiodiverseR runtime
packaging workflows and are not intended for direct use by end users.

## Purpose

Building runtime dependencies during every CI run is slow, resource
intensive and can introduce variability between builds.

This repository separates runtime dependency construction from runtime
packaging.

Instead of rebuilding dependency stacks during every runtime build,
BiodiverseR runtime packaging workflows download and use pre-built
runtime dependency releases.

Benefits include:

- Reduced CI build times.
- Improved reproducibility.
- Simplified runtime packaging workflows.
- Independent testing of runtime dependencies.
- Consistent dependency versions across platforms.

## Supported Platforms

Current platform targets include:

- Windows x64
- macOS ARM64
- Linux x64

Additional platforms may be added in future releases.

## Repository Architecture

Runtime dependency releases are created from Git tags.

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
Generate release metadata
    ↓
Generate checksums
    ↓
Create GitHub Release
    ↓
Update releases.json
```

## Release Metadata

Runtime dependency metadata is stored in:

```text
releases.json
```

The metadata contains:

- Release channels.
- Available release versions.
- Platform-specific download URLs.
- SHA256 checksums.

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

Runtime release metadata is generated automatically as part of the
release workflow.

## Release Channels

Runtime dependency releases are managed using channels.

Current channels:

```text
stable
testing
development
```

### Stable

The recommended release for general use.

### Testing

A release that is undergoing validation before promotion.

### Development

A release intended for active development and experimentation.

Publishing a release does not automatically change channel assignments.

## Release Publication and Promotion

Publishing a runtime dependency release and promoting a runtime
dependency release are separate actions.

Publishing:

```text
Create release
    ↓
Add release metadata
```

Promotion:

```text
Move channel pointer
```

Example:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0"
  }
}
```

In this example:

- `v1.1.0` has been published.
- `v1.1.0` is being tested.
- `v1.0.0` remains the stable release.

Promotion occurs only after validation.

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

The version component must exactly match the Git tag used to create the
release.

## Runtime Selection

Consumers should resolve runtime dependency versions using release
metadata rather than hard-coded versions.

Example:

```text
Channel
    ↓
Release version
    ↓
Platform
    ↓
Download URL
```

This allows runtime dependency releases to be updated and promoted
independently of consuming applications.

## Release Workflow

Runtime dependency releases are created from Git tags.

Example:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The automated release workflow:

1. Builds runtime dependency stacks.
2. Runs validation tests.
3. Packages release artifacts.
4. Generates release metadata and SHA256 checksums.
5. Creates or updates GitHub Releases.
6. Uploads release assets.
7. Updates `releases.json`.
8. Commits metadata updates.

## Current Status

- Windows dependency build: planned
- macOS ARM64 dependency build: planned
- Linux dependency build: planned
- Automated release workflow: planned
- Automated GitHub Release publication: planned
- Automated SHA256 generation: planned
- Automated `releases.json` updates: planned

## Documentation

Additional documentation is available in:

```text
docs/
```

Including:

```text
docs/architecture.md
docs/release-process.md
docs/channels.md
docs/development-workflow.md
docs/releases.json
docs/adr/
```

## Architecture Decision Records

Architectural decisions are recorded in:

```text
docs/adr/
```

Current ADRs:

- ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository
- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0003: Separate Release Publication from Promotion
- ADR-0004: Use Metadata-Driven Runtime Dependency Selection
- ADR-0005: Use Tag-Triggered Runtime Dependency Releases
- ADR-0006: Use Consistent Runtime Dependency Artifact Naming

## Relationship to BiodiverseR

This repository builds and publishes runtime dependency releases used by
BiodiverseR runtime packaging workflows.

BiodiverseR runtime packaging workflows consume these dependency
releases rather than rebuilding the complete dependency stack during
every CI run.

This separation:

- Reduces build times.
- Improves reproducibility.
- Simplifies runtime packaging workflows.
- Allows runtime dependencies to be tested and released independently.

## License

See the repository license file for licensing information.
