# Release Channels

Runtime dependency releases are managed using channels.

Channels provide stable references to runtime dependency releases.
Publication automatically advances `development`, while promotion to
`testing` and `stable` remains separate.

A channel references a release version rather than containing release
metadata directly.

## Overview

Runtime dependency releases are published using version tags.

Example:

```text
v1.0.0
v1.1.0
v1.2.0
```

Channels identify which releases should be used in specific situations.

Current channels:

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

In this example:

- `v1.0.0` is the recommended release.
- `v1.1.0` is undergoing validation.
- `v1.2.0` is intended for active development.

## Channel Definitions

### Stable

The `stable` channel represents the recommended runtime dependency
release.

Consumers should use this channel by default.

Example:

```json
{
  "stable": "v1.0.0"
}
```

The release assigned to this channel should:

- Have completed validation.
- Be suitable for general use.
- Be considered the current recommended version.

### Testing

The `testing` channel represents a release undergoing validation.

Example:

```json
{
  "testing": "v1.1.0"
}
```

Typical uses include:

- Runtime validation.
- Integration testing.
- Pre-release evaluation.
- Verification of dependency updates.

Releases assigned to this channel are candidates for promotion to
`stable`.

### Development

The `development` channel represents the newest release intended for
active development and experimentation.

Example:

```json
{
  "development": "v1.2.0"
}
```

Typical uses include:

- Development builds.
- Experimental dependency upgrades.
- Validation of new dependency stacks.
- Early testing of upcoming releases.

Releases assigned to this channel should not be considered stable.

## Release Lifecycle

The preferred release lifecycle is:

```text
Publish release
    ↓
Automatically assign to development
    ↓
Validate
    ↓
Assign to testing
    ↓
Validate
    ↓
Assign to stable
```

This allows releases to progress through increasing levels of validation
before becoming the recommended version.

## Release Publication

Publishing a release automatically assigns it to the `development`
channel. Promotion to `testing` or `stable` remains a separate action.

Publishing:

```text
Create release and metadata entry
    ↓
Set development channel to the new release
```

Promotion:

```text
Move channel assignment
```

Example:

Before publishing:

```json
{
  "channels": {
    "stable": "v1.0.0"
  }
}
```

After publishing:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "development": "v1.1.0"
  }
}
```

The release is available through `development`; it has not yet been
promoted to `testing` or `stable`.

## Promotion Example

Initial state:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0"
  }
}
```

After validation:

```json
{
  "channels": {
    "stable": "v1.1.0",
    "testing": "v1.1.0"
  }
}
```

The promoted release becomes the recommended version.

## Rollback

Channels make rollback straightforward.

Example:

Before rollback:

```json
{
  "channels": {
    "stable": "v1.2.0"
  }
}
```

After rollback:

```json
{
  "channels": {
    "stable": "v1.1.0"
  }
}
```

No new release is required.

Only the channel assignment changes.

## Benefits

Using channels provides:

- Stable release references.
- Separation of publication and promotion.
- Safer release validation workflows.
- Simple rollback procedures.
- Consistent release management across platforms.
- Simplified consumer configuration.

## Example Metadata

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0",
    "development": "v1.2.0"
  },

  "releases": {
    "v1.0.0": {},
    "v1.1.0": {},
    "v1.2.0": {}
  }
}
```

The `channels` section identifies which releases should be used in
different situations, while the `releases` section contains the actual
release metadata.

## Related

- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0003: Separate Release Publication from Promotion
- ADR-0004: Use Metadata-Driven Runtime Dependency Selection
