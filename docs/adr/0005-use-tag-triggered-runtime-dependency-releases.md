# ADR-0005: Use Tag-Triggered Runtime Dependency Releases

## Status

Accepted

## Context

Runtime dependency releases must be created in a consistent, reproducible and auditable manner.

The repository builds runtime dependency stacks for multiple platforms and publishes them as versioned release artifacts.

A release process is required that:

- Produces reproducible runtime dependency releases.
- Supports automated release workflows.
- Provides clear versioning.
- Integrates with release metadata generation.
- Supports automatic maintenance of `releases.json`.

Options considered included:

- Manual release creation.
- Branch-triggered releases.
- Tag-triggered releases.

## Decision

Runtime dependency releases will be triggered by Git tags.

Example:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Pushing a version tag will trigger the release workflow.

The workflow will:

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
Upload release assets
    ↓
Update releases.json and development channel
```

Tags are the authoritative source of runtime dependency release versions.

Release versions must correspond directly to Git tags.

Example:

```text
v1.0.0
v1.1.0
v1.2.0
```

## Rationale

Tag-triggered releases provide:

- Immutable release identifiers.
- Clear correspondence between source code and published artifacts.
- Reproducible release builds.
- Fully automated release workflows.
- Consistent versioning across platforms.
- Compatibility with GitHub Releases.

Using tags separates development activity from release creation.

Only tagged commits generate runtime dependency releases.

## Consequences

### Positive

- Release generation is fully automated.
- Every release is associated with a unique Git reference.
- Release versions are easy to identify and audit.
- Release workflows can update metadata automatically.
- Release metadata remains synchronized with published artifacts.
- The development channel always points to the newest published release.

### Negative

- Releasing requires creation of a tag.
- Incorrect tags may require cleanup if created accidentally.

### Neutral

- Development workflows continue to use normal branches.
- Release promotion remains a separate process.
- Release channels continue to determine consumer behaviour.

## Alternatives Considered

### Manual Release Creation

#### Pros

- Simple implementation.

#### Cons

- Error-prone.
- Difficult to audit.
- Difficult to automate.
- Increased maintenance burden.

### Branch-Triggered Releases

#### Pros

- Releases occur automatically from branch updates.

#### Cons

- No clear release boundary.
- Difficult to identify release versions.
- Increased risk of accidental releases.
- Weaker traceability between source and release artifacts.

### Tag-Triggered Releases

#### Pros

- Explicit release intent.
- Strong auditability.
- Works naturally with GitHub Releases.
- Supports automated metadata generation.
- Provides immutable release identifiers.

#### Cons

- Requires explicit tag creation.

## Example Workflow

```text
Development
    ↓
Merge to main
    ↓
Create tag
    ↓
Publish runtime dependency release
    ↓
Assign channel
    ↓
Validate
    ↓
Promote
```

## Related

- ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository
- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0003: Separate Release Publication from Promotion
- ADR-0004: Use Metadata-Driven Runtime Dependency Selection
