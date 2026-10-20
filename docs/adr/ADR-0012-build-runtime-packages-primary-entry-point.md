# ADR-0012: Build Runtime Packages is the Primary Workflow Entry Point

## Status

Accepted

## Context

Runtime dependency packages are built for multiple platforms:

- Windows
- macOS
- Linux

Previously, platform-specific workflows could be executed directly and acted as both implementation workflows and user-facing entry points.

As workflow functionality expanded to include:

- Platform selection
- Cache management
- Build diagnostics
- Runtime configuration management

it became increasingly difficult to maintain consistent behaviour across multiple independently executed workflows.

A single workflow was required to coordinate and manage runtime package builds across all supported platforms.

## Decision

The primary workflow entry point is:

```text
📦 Build: Runtime Packages
```

This workflow is responsible for:

- Initiating runtime package builds
- Selecting target platforms
- Managing cache reset operations
- Controlling verbose logging
- Coordinating platform-specific workflows
- Managing shared build state

Platform-specific workflows are implementation details and are not considered primary user-facing workflows:

```text
🔧 Internal: Windows Package Build
🔧 Internal: macOS Package Build
🔧 Internal: Linux Package Build
```

These workflows consume configuration and inputs supplied by the primary workflow and should generally be invoked through the top-level build workflow.

## Consequences

### Positive

- Provides a single entry point for runtime package builds.
- Centralises build configuration and workflow controls.
- Simplifies implementation of cross-platform build features.
- Enables coordinated cache management.
- Improves workflow discoverability and usability.
- Reduces duplication of workflow logic.

### Negative

- Platform workflows become dependent on the top-level workflow for certain features.
- Direct execution of internal workflows may not provide access to all orchestration capabilities.
- Build coordination logic is concentrated in a single workflow.

## Alternatives Considered

### Platform-Specific Entry Points

Example:

```text
Windows Package Build
macOS Package Build
Linux Package Build
```

as the primary workflows.

#### Rejected

This approach duplicates user-facing functionality across workflows and makes it more difficult to implement features that span multiple platforms.

Examples include:

- Cache management
- Platform selection
- Shared build configuration
- Cross-platform orchestration

### Hybrid Approach

Allow both the top-level workflow and platform workflows to independently implement all user-facing controls.

#### Rejected

This increases maintenance overhead and risks behaviour drifting between platforms over time.

## Implementation Notes

The following workflow is considered the supported entry point for runtime package builds:

```text
📦 Build: Runtime Packages
```

Internal workflows remain reusable implementation components:

```text
🔧 Internal: Windows Package Build
🔧 Internal: macOS Package Build
🔧 Internal: Linux Package Build
```

New user-facing runtime build functionality should be added to the primary workflow and propagated to internal workflows as required.

