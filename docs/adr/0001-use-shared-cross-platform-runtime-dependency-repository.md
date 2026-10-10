# ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository

## Status

Accepted

## Context

Runtime dependency stacks currently require substantial build effort, particularly on macOS where Perl and geospatial dependencies such as GDAL-related libraries are built during CI.

The runtime packaging repository should consume pre-built runtime dependency releases rather than rebuilding the complete dependency stack during every workflow execution.

An architectural decision is required regarding how runtime dependencies are organised and distributed.

Options include:

- Separate repositories for each platform.
- A single repository containing all platform dependency releases.

## Decision

Use a single shared repository to build and distribute runtime dependencies for all supported platforms.

Repository:

```text
biodiverse-runtime-dependencies
```

The repository will:

- Build platform-specific dependency stacks.
- Publish platform-specific artifacts.
- Maintain a single release workflow.
- Maintain a single `releases.json`.
- Use a single version stream across all platforms.

Example:

```text
Tag v1.0.0
    ↓
Build Windows dependencies
    ↓
Build macOS dependencies
    ↓
Build Linux dependencies
    ↓
Create release
    ↓
Update releases.json
```

## Consequences

### Positive

- Single source of truth for runtime dependencies.
- Consistent versioning across platforms.
- Simplified metadata management.
- Reduced repository sprawl.
- Simplified testing and release promotion workflows.

### Negative

- A release may contain platform artifacts that are not used by all consumers.
- Platform-specific fixes may require a new cross-platform release.

## Alternatives Considered

### Separate repositories per platform

Examples:

```text
biodiverse-runtime-windows
biodiverse-runtime-macos
biodiverse-runtime-linux
```

Pros:

- Complete platform independence.

Cons:

- Multiple version streams.
- Multiple metadata files.
- Additional operational complexity.
- More difficult release coordination.
