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

The repository generates two distinct categories of artifacts:

- CI Artifacts.
- Release Assets.

These artifacts serve different purposes and therefore use different naming conventions.

## Decision

Runtime dependency artifacts will use a consistent platform-based naming convention.

### Release Assets

Release assets are generated from version tags and published through GitHub Releases.

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

Release asset filenames must:

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

### CI Artifacts

CI artifacts are generated from commits during development and validation workflows.

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

CI artifacts are not considered published releases and are not referenced by `releases.json`.

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
Release asset name
    ↓
Metadata generation
    ↓
Consumer download
```

without requiring special handling for individual platforms.

Separate naming conventions for CI artifacts and release assets also make it clear whether an artifact originated from:

```text
Commit
    ↓
CI Artifact
```

or:

```text
Tag
    ↓
Release Asset
```

## Consequences

### Positive

- Predictable artifact names.
- Simplified metadata generation.
- Easier debugging and troubleshooting.
- Reduced workflow complexity.
- Improved consistency across platforms.
- Easier integration with consuming repositories.
- Clear distinction between development artifacts and published releases.

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

Generated release assets:

```text
biodiverse-runtime-dependencies_windows_x64_v1.2.0.zip
biodiverse-runtime-dependencies_macos_arm64_v1.2.0.zip
biodiverse-runtime-dependencies_linux_x64_v1.2.0.zip
```

Generated CI artifacts:

```text
biodiverse-runtime-dependencies_windows_x64_d2ddf75
biodiverse-runtime-dependencies_macos_arm64_d2ddf75
biodiverse-runtime-dependencies_linux_x64_d2ddf75
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
