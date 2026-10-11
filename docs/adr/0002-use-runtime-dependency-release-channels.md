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

### Version-only selection

Pros:

- Simpler metadata.

Cons:

- End users must know specific version numbers.
- Promotion workflows rely entirely on version selection.
