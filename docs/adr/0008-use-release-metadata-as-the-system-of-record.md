# ADR-0008: Use Release Metadata as the System of Record

## Status

Accepted

## Context

Runtime dependency releases are represented by multiple forms of state:

- Git branches.
- Git tags.
- GitHub Releases.
- Release channels.
- Release metadata.

Consumers require a reliable and authoritative mechanism to determine:

- Which release version should be used.
- Which channel a release belongs to.
- Which platform-specific artifacts are available.
- Where artifacts can be downloaded.
- How artifacts should be verified.

Git branches are primarily a software development concept and are not suitable as the authoritative source for runtime dependency selection.

For example:

```text
main
development
feature-gdal-upgrade
feature-perl-5.42
```

describe source code state but do not identify which release consumers
should use.

Similarly, Git tags and GitHub Releases identify published releases but
do not define channel assignments or release promotion status.

An explicit system of record is required.

## Decision

Release metadata stored in `releases.json` is the authoritative source
for runtime dependency selection.

Consumers must determine runtime dependency versions using release
metadata rather than:

- Branch names.
- Workflow definitions.
- Hard-coded version identifiers.
- GitHub Release discovery.

The metadata file defines:

- Available releases.
- Release channels.
- Platform-specific artifacts.
- Artifact checksums.

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
    },
    "v1.1.0": {
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
    },
    "v1.2.0": {
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

Consumers resolve releases entirely through metadata.

Example:

```text
stable
    ↓
v1.0.0
    ↓
platform
    ↓
artifact URL
```

## Branches and Metadata

Branches are used for software development.

Example:

```text
main
development
feature-gdal-upgrade
```

Branches describe:

```text
Work in progress
```

Metadata describes:

```text
Consumable releases
```

A release may be published from a commit that originated on a particular
branch, but once published, consumers must use metadata rather than
branch information.

## Release Lifecycle

The preferred release lifecycle is:

```text
Feature branch
    ↓
Development branch
    ↓
Tag release
    ↓
Build artifacts
    ↓
Create GitHub Release
    ↓
Update releases.json
    ↓
Automatically assign development channel
```

Only metadata determines which published release belongs to a channel.
Publication automatically advances `development`; `testing` and `stable`
are changed through promotion.

## Promotion

Promotion is performed by updating metadata.

Example:

Before:

```json
{
  "channels": {
    "stable": "v1.0.0",
    "testing": "v1.1.0"
  }
}
```

After:

```json
{
  "channels": {
    "stable": "v1.1.0",
    "testing": "v1.1.0"
  }
}
```

No rebuild is required.

No branch change is required.

The metadata becomes the only source of truth for release selection.

## Rationale

Using metadata as the system of record:

- Separates development from release consumption.
- Eliminates hard-coded release references.
- Simplifies promotion workflows.
- Supports release channels.
- Enables rollback without rebuilding releases.
- Provides a single authoritative release definition.
- Decouples consumers from repository structure.

Example:

```text
Consumer
    ↓
Metadata
    ↓
Release
```

rather than:

```text
Consumer
    ↓
Branch
```

## Consequences

### Positive

- Single source of truth for release selection.
- Simplified release promotion.
- Simplified rollback.
- Supports release channels.
- Supports automation.
- Consumers do not need knowledge of repository branches.
- Release behaviour is controlled entirely through metadata.

### Negative

- Metadata accuracy becomes critical.
- Metadata must be maintained automatically and consistently.
- Consumers require metadata parsing logic.

### Neutral

- Git tags remain the mechanism used to create releases.
- GitHub Releases remain the mechanism used to distribute artifacts.
- Development workflows remain branch-based.

## Alternatives Considered

### Use Branches as the System of Record

Example:

```text
main
development
```

#### Pros

- Familiar workflow.

#### Cons

- Branches describe development state rather than release state.
- Poor support for release promotion.
- Difficult rollback workflows.
- Couples consumers to repository implementation details.

### Use GitHub Releases as the System of Record

#### Pros

- Releases already exist.

#### Cons

- No native support for channels.
- No promotion model.
- Consumer logic becomes more complex.

### Use Release Metadata as the System of Record

#### Pros

- Supports channels.
- Supports promotion.
- Supports rollback.
- Easy to automate.
- Separates development from release consumption.

#### Cons

- Requires metadata maintenance.

## Related

- ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository
- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0003: Separate Release Publication from Promotion
- ADR-0004: Use Metadata-Driven Runtime Dependency Selection
- ADR-0005: Use Tag-Triggered Runtime Dependency Releases
- ADR-0006: Use Consistent Runtime Dependency Artifact Naming
- ADR-0007: Use Shared Runtime Configuration Files
