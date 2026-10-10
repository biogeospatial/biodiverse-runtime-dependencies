# ADR-0004: Use Metadata-Driven Runtime Dependency Selection

## Status

Accepted

## Context

Runtime dependency releases are distributed through GitHub Releases and described using release metadata stored in `releases.json`.

Consumers require a mechanism to determine:

- Which runtime dependency release should be used by default.
- Which runtime dependency release should be used for testing.
- Which runtime dependency releases are available.
- Which platform-specific artifacts belong to a release.

Hard-coding runtime dependency versions into workflows or client applications would require software changes whenever runtime releases change.

A metadata-driven approach provides a single source of truth for runtime dependency selection and enables independent release management.

## Decision

Runtime dependency selection will be driven by release metadata stored in `releases.json`.

The metadata file will contain:

- Distribution channels.
- Available runtime dependency releases.
- Platform-specific artifact metadata.
- Checksums for runtime verification.

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

Consumers resolve the selected channel to a release version and then select the appropriate platform artifact.

Example:

```text
stable
    ↓
v1.0.0
    ↓
windows
    ↓
download URL
```

## Metadata Structure

### Channels

Channels provide stable references to release versions.

Initial channels:

```text
stable
testing
development
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

### Releases

Each release is uniquely identified by a version tag.

Example:

```json
{
  "releases": {
    "v1.0.0": {}
  }
}
```

### Platform Metadata

Each release contains platform-specific metadata.

Example:

```json
{
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
```

The URL identifies the downloadable runtime dependency artifact.

The SHA256 checksum is used to verify artifact integrity.

## Runtime Selection

By default, consumers should use:

```text
stable
```

Testing and development workflows may select alternative channels.

Examples:

```text
stable
testing
development
```

Consumers should not require code changes when runtime dependency releases are published or promoted.

Runtime selection should be controlled entirely through metadata.

## Rationale

Using metadata-driven runtime selection:

- Decouples runtime dependency releases from application releases.
- Eliminates hard-coded dependency versions.
- Supports release channels.
- Supports staged promotion workflows.
- Enables runtime dependency updates without application changes.
- Provides a single source of truth for runtime selection.
- Simplifies testing and validation workflows.

Example:

```text
Publish release
    ↓
Assign to testing
    ↓
Validate
    ↓
Promote to stable
```

without requiring any workflow or application modifications.

## Consequences

### Positive

- Runtime dependency releases can be promoted independently.
- Clients require no modification when new releases are published.
- Channels provide stable references to runtime dependency versions.
- Runtime metadata becomes a single source of truth.
- Supports staged rollout and testing workflows.

### Negative

- Metadata must be maintained correctly.
- Clients must implement metadata resolution logic.
- Additional validation is required to ensure metadata consistency.

### Neutral

- Runtime artifacts continue to be distributed through GitHub Releases.
- Platform-specific build processes remain independent.
- Release channels are implemented as metadata rather than Git branches.

## Alternatives Considered

### Hard-coded Runtime Versions

Pros:

- Simple initial implementation.

Cons:

- Requires code changes for every runtime update.
- Difficult to test alternative releases.
- No support for staged promotion.

### Branch-Based Selection

Pros:

- Familiar workflow.

Cons:

- Conflates source control and release management.
- More difficult to automate.
- Does not provide a stable release selection mechanism for consumers.

### Metadata-Driven Selection

Pros:

- Flexible.
- Fully automatable.
- Supports release channels.
- Supports staged promotion.

Cons:

- Requires metadata management.

## Related

- ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository
- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0003: Separate Release Publication from Promotion
