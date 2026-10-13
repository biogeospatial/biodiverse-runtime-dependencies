# ADR-0009: Use Versioned and Reproducible Runtime Dependency Baselines

## Status

Proposed

## Context

The `biodiverse-runtime-dependencies` repository produces platform-specific runtime dependency artifacts for:

- Linux x64
- macOS ARM64
- Windows x64

Currently,runtime builds depend on external systems that change independently of the repository, including:

- CPAN module releases.
- Homebrew package updates.
- Debian package updates.
- GitHub Actions runner updates.
- GDAL dependency updates.
- OpenSSL updates.
- Native library dependency changes.

As a result:

- Builds may fail without repository changes.
- Identical workflow executions may produce different outputs over time.
- Dependency upgrades may occur unintentionally.
- Published releases may become difficult to reproduce.
- Release metadata may reference releases whose dependency composition is not fully documented.

Examples include:

- Net::SSLeay build failures.
- Alien::* dependency failures.
- GDAL dependency incompatibilities.
- Unexpected CPAN dependency upgrades.
- Environment changes in hosted CI runners.

A reproducible release process requires runtime dependency inputs to be:

- Version controlled.
- Reviewable.
- Traceable to source control.
- Consistently applied across all workflows.
- Traceable from release metadata to runtime contents.

## Decision

The repository will use versioned and reproducible release baselines.

Every runtime dependency release shall be built from an explicit dependency baseline stored in source control.

A release baseline defines the approved versions of runtime dependencies used to generate a release.

Runtime dependency releases shall be derived through the following model:

```text
Shared Configuration
        ↓
Dependency Baseline
        ↓
Dependency Lock Files
        ↓
Tagged Release Build
        ↓
Release Artifacts
        ↓
Release Metadata
        ↓
Channel Assignment
        ↓
Consumer Resolution
```

Build workflows must not depend on the latest available upstream dependency versions.

Dependency changes must occur through normal source-control processes and be reviewed before release.

Dependency versions used by build workflows should be defined through shared runtime configuration files wherever practical.

## Dependency Baseline Sources

The repository shall maintain dependency baseline information using:

```text
.github/runtime-dependency-config.yml
runtime/
├── BASELINE-linux.md
├── BASELINE-macos.md
├── BASELINE-windows.md
├── Brewfile
├── cpanfile
└── cpanfile.snapshot
```

These files collectively define the dependency baseline used to generate a release.

Configuration files define dependency intent.

Lock files define dependency selection.

Baseline files document the approved dependency set.

Together they provide the dependency definition associated with a release.

## Release Baselines

A release baseline defines the approved dependency set used to build a release.

A baseline may contain platform-specific dependency versions where required.

Examples include:

- Perl.
- GDAL.
- PROJ.
- GEOS.
- OpenSSL.
- SQLite.
- GSL.

A release baseline must be:

- Documented.
- Version controlled.
- Reviewable.
- Reproducible.

Dependency upgrades:

- Require source-control changes.
- Require review.
- Require validation.
- Must not occur automatically.

## Perl Dependency Management

Perl dependency management shall use:

```text
cpanfile
cpanfile.snapshot
Carton
```

Dependencies shall be installed using:

```bash
carton install --deployment
```

Direct installation of unpinned dependencies using:

```bash
cpanm Module::Name
```

is not permitted in release build workflows.

This ensures a reproducible Perl dependency graph across all supported platforms.

## Platform Dependency Management

### Linux

Linux builds shall:

- Use a documented Debian baseline.
- Use documented snapshot repositories where applicable.
- Prefer reproducible containerised build environments.

### macOS

macOS builds shall:

- Use a committed Brewfile.
- Define system dependencies in source control.
- Avoid unmanaged dependency installation.

### Windows

Windows builds shall:

- Standardise on documented Perl distributions.
- Bundle required runtime DLLs.
- Avoid relying on globally installed dependencies.

## Build Verification

All platform builds shall execute validation tests before producing release artifacts.

Examples include:

```bash
perl -MPDL -e 1
perl -MFFI::Platypus -e 1
perl -MGeo::GDAL::FFI -e 1
gdalinfo --version
```

Builds that fail validation must not publish release artifacts.

## Build Auditing

Every build shall generate:

```text
BUILDINFO.txt
```

containing information such as:

- Perl version.
- Installed Perl modules.
- GDAL version.
- Dependency versions.
- Build environment details.

`BUILDINFO.txt` shall be included in both CI artifacts and release assets.

This provides traceability between:

```text
Release Metadata
        ↓
Release
        ↓
Dependency Baseline
        ↓
Build Output
```

## Release Metadata Consistency

Every release entry published in `releases.json` shall be traceable to a documented dependency baseline.

For every release:

```text
Release Metadata
        ↓
Release Version
        ↓
Artifacts
        ↓
Checksums
        ↓
Dependency Baseline
```

must be auditable.

This ensures:

- Metadata remains trustworthy.
- Releases remain reproducible.
- Promotion decisions remain auditable.
- Build provenance remains available.
- Metadata remains the authoritative system of record.

## Branch Workflow

Dependency changes shall follow the repository branching model:

```text
feature/*
        ↓
development
        ↓
main
```

Examples:

```text
feature/perl-upgrade
feature/gdal-upgrade
feature/cpan-refresh
feature/update-system-dependencies
```

Dependency upgrades must be reviewed and validated before release.

Branches describe development activity.

Release selection remains metadata driven.

## Release Artifacts

Artifacts shall follow the naming conventions defined in ADR-0006.

Examples:

```text
biodiverse-runtime-dependencies_windows_x64_v1.2.0.zip
biodiverse-runtime-dependencies_macos_arm64_v1.2.0.zip
biodiverse-runtime-dependencies_linux_x64_v1.2.0.zip
```

Release artifacts shall include:

```text
Runtime Dependencies
BUILDINFO.txt
Release Baseline Reference
```

CI artifacts shall continue to use the CI naming conventions defined in ADR-0006.

## Rationale

Versioned dependency baselines ensure:

```text
Configuration
        ↓
Dependency Definitions
        ↓
Release
        ↓
Metadata
        ↓
Consumer
```

remains deterministic and auditable.

The approach:

- Reduces failures caused by upstream dependency changes.
- Improves build reproducibility.
- Improves release traceability.
- Supports controlled upgrades.
- Supports shared configuration management.
- Supports metadata-driven release selection.
- Supports release metadata as the system of record.
- Supports tag-triggered release generation.
- Supports channel-based promotion workflows.
- Provides a clear relationship between metadata, release identity and dependency composition.

## Consequences

### Positive

- Reproducible runtime builds.
- Centralised dependency configuration.
- Reduced workflow drift.
- Better auditing and traceability.
- Easier rollback to previous releases.
- Improved confidence in release metadata.
- Strong alignment between metadata and release contents.
- Consistent behaviour across platforms.

### Negative

- Additional baseline maintenance.
- Configuration changes affect multiple workflows.
- Dependency upgrades require planning and validation.
- Initial migration effort.

### Neutral

- Repository structure remains governed by ADR-0001.
- Channel management remains governed by ADR-0002.
- Promotion remains governed by ADR-0003.
- Runtime selection remains governed by ADR-0004.
- Release triggering remains governed by ADR-0005.
- Artifact naming remains governed by ADR-0006.
- Configuration management remains governed by ADR-0007.
- Release metadata remains governed by ADR-0008.

## Alternatives Considered

### Continue Using Current Upstream Versions

#### Pros

- Minimal configuration.
- Automatic access to new dependency versions.

#### Cons

- Non-reproducible builds.
- Unexpected CI failures.
- Difficult troubleshooting.
- Uncontrolled upgrades.

### Use Release Metadata to Define Dependency Versions

#### Pros

- Single storage location.

#### Cons

- Confuses release metadata with dependency management.
- Conflicts with ADR-0008 separation of concerns.
- Makes metadata responsible for build configuration.
- Reduces maintainability.

### Store Versions Only in Workflow Files

#### Pros

- Simple implementation.

#### Cons

- Conflicts with ADR-0007.
- Configuration duplication.
- Reduced auditability.
- Increased workflow drift.

## Related

- ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository
- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0003: Separate Release Publication from Promotion
- ADR-0004: Use Metadata-Driven Runtime Dependency Selection
- ADR-0005: Use Tag-Triggered Runtime Dependency Releases
- ADR-0006: Use Consistent Runtime Dependency Artifact Naming
- ADR-0007: Use Shared Runtime Configuration Files
- ADR-0008: Use Release Metadata as the System of Record
