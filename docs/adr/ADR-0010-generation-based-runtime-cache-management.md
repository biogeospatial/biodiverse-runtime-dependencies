# ADR-0010: Generation-based Runtime Cache Management

## Status

Accepted

## Context

Runtime dependency builds use GitHub Actions caches to avoid repeatedly rebuilding Perl runtimes and large native dependencies such as PDL and GDAL.

The repository builds runtime dependencies across multiple platforms:

- Windows
- macOS
- Linux

Cache resets should establish a new cache baseline for future builds while maintaining consistency across all supported platforms.

## Decision

Runtime cache management will use generation-based cache versioning.

Cache generations are represented by:

```yaml
globals:
  cache_generation: 1
```

in:

```text
.github/runtime-dependency-config.yml
```

Cache keys include:

- Platform
- Perl version
- Cache generation
- Runtime configuration hash
- Dependency definition hash

Examples:

```text
strawberry-perl-Windows-5.38.4-gen1-...
```

```text
perlbrew-macOS-5.38.4-gen1-...
```

```text
perlbrew-Linux-5.38.4-gen1-...
```

When a cache reset is requested:

1. A new cache generation is calculated.
2. All platform builds use the new generation.
3. New caches are created for that generation.
4. The new generation is persisted.
5. Future builds use the new generation as the active cache baseline.

Cache generations are repository-wide and apply to all supported platforms.

## Consequences

### Positive

- Cache resets establish a new long-term cache baseline.
- Cache state is explicit, versioned, and traceable.
- Windows, macOS, and Linux caches remain aligned.
- Cache management aligns with ADR-0009 principles of reproducibility and explicit version management.
- Previous cache generations remain available until automatically expired by GitHub.

### Negative

- Cache management requires generation tracking.
- Cache resets require rebuilding all platform runtimes before the new generation is persisted.

## Alternatives Considered

### Platform-Specific Cache Generations

Example:

```yaml
globals:
  cache_generation:
    windows: 1
    macos: 1
    linux: 1
```

#### Rejected

Cache resets are intended to apply to the runtime build system as a whole rather than individual platforms.

A single repository-wide cache generation provides simpler configuration and consistent cache behaviour across platforms.

## Implementation Notes

- `📦 Build: Runtime Packages` is responsible for determining the effective cache generation.
- Platform-specific workflows consume the cache generation supplied by the top-level workflow.
- Cache generation changes become effective immediately for the build performing the reset.
- Cache generation is persisted only after successful completion of all platform builds.
- Cache resets require rebuilding all supported platforms and are therefore only valid when `Platform = all`.

