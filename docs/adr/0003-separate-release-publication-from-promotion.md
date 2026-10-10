# ADR-0003: Separate Release Publication from Promotion

## Status

Accepted

## Context

Runtime dependency releases require validation before they become the default dependency stack used by consumers.

Publishing a release and recommending a release are different activities.
Publication automatically advances the `development` channel so active
development can consume the newest release, but does not promote that
release to `testing` or `stable`.

Automatically promoting every new release to `stable` increases the risk
of distributing unvalidated dependency changes.

## Decision

Publishing a release automatically advances the `development` channel.
Promoting a release to `testing` or `stable` is a separate action.

Publishing:

```text
Create release
    ↓
Add release metadata
    ↓
Set development channel to new release
```

Promotion:

```text
Move testing or stable channel pointer
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

In this example:

- `v1.2.0` is the newest published release.
- `v1.1.0` is under test.
- `v1.0.0` remains the stable release.
- `v1.2.0` is assigned to development automatically on publication.

Testing and stable promotion occur only after validation.

## Rationale

This approach:

- Reduces risk.
- Improves rollback capability.
- Supports staged testing.
- Separates release publication from operational adoption.

Preferred workflow:

```text
Publish release
    ↓
Automatically assign to development
    ↓
Promote to testing
    ↓
Validate
    ↓
Promote to stable
```

## Consequences

### Positive

- Safer rollouts.
- Better testing workflows.
- Easier recovery from regressions.
- Clear release lifecycle.
- New releases are immediately available through the development channel.

### Negative

- Promotion becomes an additional step.
- Metadata management becomes slightly more complex.

## Alternatives Considered

### Automatic promotion

Pros:

- Simpler release workflow.

Cons:

- No validation period.
- Higher risk of distributing faulty releases.
- More difficult rollback process.
