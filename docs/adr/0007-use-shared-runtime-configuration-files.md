# ADR-0007: Use Shared Runtime Configuration Files

## Status

Accepted

## Context

Runtime dependency build workflows require a number of configuration
values that may change over time.

Examples include:

- Perl versions.
- Platform architectures.
- Dependency versions.
- Build settings.
- Release workflow behaviour.
- Channel assignment defaults.
- Platform-specific environment settings.

Hard-coding configuration values directly into GitHub Actions workflows
makes maintenance more difficult and increases the risk of configuration
drift between workflows.

As additional platforms are supported, configuration values may need to
be shared across multiple workflows.

A consistent mechanism is required to centralise build and release
configuration.

## Decision

Runtime configuration will be stored in a shared configuration file.

Initial location:

```text
.github/runtime-dependency-config.yml
```

Workflows will load configuration values from the shared configuration
file rather than embedding configuration values directly in workflow
definitions.

Example:

```yaml
platforms:

  macos:
    perl_version: "5.40.2"

  windows:
    perl_version: "5.38.4"

  linux:
    perl_version: "5.40.2"
```

Workflow values should be loaded from the configuration file wherever
practical.

## Example Workflow

```text
Runtime configuration
        ↓
Release workflow
        ↓
Build workflow
        ↓
Dependency release
```

Instead of:

```text
Workflow A
  Perl version = 5.40.2

Workflow B
  Perl version = 5.40.2

Workflow C
  Perl version = 5.40.2
```

the repository will use:

```text
runtime-config.yml
        ↓
All workflows
```

## Rationale

Using a shared configuration file:

- Reduces duplication.
- Simplifies version upgrades.
- Improves consistency across workflows.
- Makes configuration changes easier to review.
- Reduces the likelihood of workflow drift.
- Allows new platforms to adopt existing configuration patterns.
- Separates configuration from workflow implementation.

## Consequences

### Positive

- Centralised configuration management.
- Reduced workflow complexity.
- Easier platform onboarding.
- Easier dependency version updates.
- Improved consistency across workflows.
- Better maintainability.

### Negative

- Workflows require logic to load configuration values.
- Invalid configuration changes can affect multiple workflows.

### Neutral

- Workflow functionality remains unchanged.
- Platform-specific build processes continue to differ where required.
- Configuration values remain version-controlled.

## Initial Configuration Areas

The configuration file may contain:

```yaml
globals:
  release:
  channels:

platforms:
  windows:
  macos:
  linux:
```

Examples of managed values include:

- Perl versions.
- Architecture identifiers.
- Build options.
- Release defaults.
- Channel behaviour.
- Platform-specific environment variables.

## Alternatives Considered

### Hard-Code Configuration in Workflows

#### Pros

- Simple initial implementation.
- No configuration file required.

#### Cons

- Configuration duplication.
- More difficult maintenance.
- Greater risk of inconsistency.
- More complicated upgrades.

### Shared Configuration File

#### Pros

- Single source of truth.
- Easier maintenance.
- Consistent workflow behaviour.
- Simplified configuration updates.

#### Cons

- Requires configuration loading logic.

## Related

- ADR-0001: Use a Shared Cross-Platform Runtime Dependency Repository
- ADR-0002: Use Runtime Dependency Release Channels
- ADR-0004: Use Metadata-Driven Runtime Dependency Selection
- ADR-0005: Use Tag-Triggered Runtime Dependency Releases
- ADR-0006: Use Consistent Runtime Dependency Artifact Naming
