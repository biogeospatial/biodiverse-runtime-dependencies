# ADR-0003: Separate Release Publication from Promotion

## Status

Accepted

## Context

Runtime dependency releases require validation before they become the default dependency stack used by consumers.

Publishing a release and recommending a release are different activities.

Automatically promoting every new release increases the risk of distributing unvalidated dependency changes.

## Decision

Release publication and release promotion are separate actions.

Publishing:

```text
Create release
    ↓
Add release metadata
```

Promotion:

```text
Move channel pointer
```

Example:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0"
  }
}
```

In this example:

- `v1.1.0` is published.
- `v1.1.0` is under test.
- `v1.0.0` remains the stable release.

Promotion occurs only after validation.

## Rationale

This approach:

- Reduces risk.
- Improves rollback capability.
- Supports staged testing.
- Separates release publication from operational adoption.

Preferred workflow:

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

- Safer rollouts.
- Better testing workflows.
- Easier recovery from regressions.
- Clear release lifecycle.

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
