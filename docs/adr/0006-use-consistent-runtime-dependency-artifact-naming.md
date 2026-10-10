# ADR-0006: Use Consistent Runtime Dependency Artifact Naming

## Status

Accepted

## Context

Runtime dependency releases are distributed as platform-specific artifacts through GitHub Releases.

Artifacts must be:

- Easy to identify.
- Predictable for automated workflows.
- Simple to reference from release metadata.
- Consistent across all supported platforms.
- Stable across release versions.

A consistent naming convention is required so that release workflows, metadata generation and consuming repositories can reliably determine artifact names without platform-specific logic.

## Decision

Runtime dependency artifacts will use a consistent platform-based naming convention.

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

Artifact filenames must:

- Include the repository purpose.
- Include the target platform.
- Include the target architecture.
- Include the release version.
- Use the same version identifier as the Git tag used to create the release.

The version segment must match the release tag exactly.

Example:

```text
Tag: v1.0.0

Artifact:
biodiverse-runtime-dependencies_macos_arm64_v1.0.0.zip
```

## Rationale

Consistent artifact naming:

- Simplifies automated release workflows.
- Simplifies release metadata generation.
- Reduces platform-specific workflow logic.
- Makes artifacts self-describing.
- Supports predictable download URLs.
- Improves traceability between releases and artifacts.

Example:

```text
Release tag
    ↓
Artifact name
    ↓
Metadata generation
    ↓
Consumer download
```

without requiring special handling for individual platforms.

## Consequences

### Positive

- Predictable artifact names.
- Simplified metadata generation.
- Easier debugging and troubleshooting.
- Reduced workflow complexity.
- Improved consistency across platforms.
- Easier integration with consuming repositories.

### Negative

- Artifact names are longer than minimal alternatives.
- Future naming changes may require compatibility considerations.

### Neutral

- Platform-specific build processes remain unchanged.
- Artifact contents remain platform dependent.
- Release channels are unaffected.

## Alternatives Considered

### Platform-Specific Naming Conventions

Examples:

```text
windows-runtime.zip
macos-runtime.zip
linux-runtime.zip
```

#### Pros

- Short filenames.
- Easy for humans to read.

#### Cons

- Version information is missing.
- Architecture information is missing.
- Less suitable for automation.
- Increased risk of ambiguity.

### Platform-Specific Custom Naming

Examples:

```text
bd-runtime-win.zip
bd-runtime-mac.zip
```

#### Pros

- Compact filenames.

#### Cons

- Inconsistent naming rules.
- Harder to automate.
- Requires platform-specific workflow logic.

### Consistent Platform and Version Naming

#### Pros

- Predictable.
- Self-describing.
- Easy to automate.
- Easy to generate metadata for.
- Supports future platforms and architectures.

#### Cons

- Longer filenames.

## Examples

Example release:

```text
v1.2.0
```

Generated artifacts:

```text
biodiverse-runtime-dependencies_windows_x64_v1.2.0.zip
biodiverse-runtime-dependencies_macos_arm64_v1.2.0.zip
biodiverse-runtime-dependencies_linux_x64_v1.2.0.zip
```

Example metadata:

```json
{
  "windows": {
    "url": ".../biodiverse-runtime-dependencies_windows_x64_v1.2.0.zip"
  },
  "macos": {
    "url": ".../biodiverse-runtime-dependencies_macos_arm64_v1.2.0.zip"
  },
  "linux": {
    "url": ".../biodiverse-runtime-dependencies_linux_x64_v1.2.0.zip"
  }
}
```

## Related

- ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository
- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0004: Use Metadata-Driven Runtime Dependency Selection
- ADR-0005: Use Tag-Triggered Runtime Dependency Releases
