# ADR-0002: Use Runtime Dependency Release Channels

## Status

Accepted

## Context

Runtime dependency releases require testing before becoming the default version used by end users.

Using explicit version numbers for all testing activities does not scale well as the number of releases increases.

A mechanism is needed to distinguish:

- Stable releases.
- Validation releases.
- Ongoing development releases.

## Decision

Runtime dependency releases will be managed using channels.

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

Channels reference releases rather than containing release metadata.

Releases remain uniquely identified by version tags.

When a release is published, the release workflow automatically assigns
it to the `development` channel. The `testing` and `stable` channels are
updated separately through promotion.

## Rationale

Channels provide:

- Stable release management.
- Pre-release testing.
- Development validation.
- Simple promotion workflows.

Example:

```text
Create release
    ↓
Assign to testing
    ↓
Validate
    ↓
Promote to stable
```

## Consequences

### Positive

- Users do not need to know specific version numbers.
- Releases can move between channels.
- Promotion workflows become simpler.
- Testing workflows become more predictable.

### Negative

- Additional metadata management.
- Additional channel resolution logic.

## Alternatives Considered

### Single Current Release Pointer

Example:

```json
{
  "current": "v0.1.0-alpha",

  "releases": {
    "v0.1.0-alpha": {},
    "v0.1.0-test32": {}
  }
}
```

#### Pros

- Simple metadata structure.
- Easy to implement.
- Provides a single default release for consumers.

#### Cons

- Supports only a single release pointer.
- No distinction between stable, testing and development releases.
- No promotion model.
- Requires changing the current pointer whenever a different release should be consumed.
- Makes it difficult to support staged validation workflows.
- Uses release URLs and release identifiers directly rather than channel-based version selection.
- Consumers cannot easily determine whether a release is intended for development, testing or stable use.

The channel-based approach was preferred because it allows multiple release states to coexist simultaneously:

```text
stable
    ↓
v1.0.0

testing
    ↓
v1.1.0

development
    ↓
v1.2.0
```

This supports validation, promotion and rollback workflows without requiring consumers to switch between explicit release versions.

### Version-only selection

Pros:

- Simpler metadata.

Cons:

- End users must know specific version numbers.
- Promotion workflows rely entirely on version selection.
