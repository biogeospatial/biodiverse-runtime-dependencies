# Contributing

This document describes the development, documentation and review standards used by this repository.

## General Principles

- Keep changes focused on a single objective.
- Prefer small, reviewable pull requests.
- Update documentation alongside implementation changes.
- Record architectural decisions using ADRs.
- Prefer automation over manual processes where practical.
- Keep release metadata synchronized with published releases.

## Branching Model

Long-lived branches:

```text
main
development
```

Short-lived branches:

```text
feature-*
bugfix-*
documentation-*
```

### Feature Development

Create feature branches from:

```text
development
```

Example:

```bash
git checkout development
git pull
git checkout -b feature-gdal-upgrade
```

### Bug Fixes

#### Unreleased Bug

Branch from the feature branch that introduced the issue.

Example:

```text
feature-perl-5.42
    ↓
feature-perl-5.42-fix
```

#### Released Bug

Branch from:

```text
main
```

Example:

```text
main
    ↓
bugfix-v1.0.1
```

After release:

```text
bugfix-v1.0.1
    ↓
main
    ↓
development
```

Back-merge released fixes into development.

## Commit Messages

Commit messages should be concise and use the imperative mood.

Format:

```text
Short description

Issue: #NUMBER
```

Example:

```text
Add macOS dependency build workflow

Issue: #2
```

### Guidelines

Good:

```text
Add release metadata generation

Issue: #4
```

Good:

```text
Fix macOS dependency packaging

Issue: #3
```

Avoid:

```text
Fixed stuff
```

Avoid:

```text
Changes
```

Commit messages should describe what the change introduces rather than
what action was taken.

## Issues

Issues should follow a consistent structure.

Recommended sections:

```text
Summary
Motivation
Tasks
Validation Requirements
Success Criteria
Benefits
Related
```

Example:

```md
## Summary

Add macOS dependency build workflow.

## Motivation

...

## Tasks

- Task
- Task

## Success Criteria

- Result
- Result

## Related

- ADR-0001
```

## Pull Requests

Pull requests should describe the completed implementation and the value
provided.

Recommended structure:

```md
## Summary

## Changes

## Benefits

## Testing

## Related
```

Example:

```md
## Summary

Add macOS dependency build workflow.

## Changes

- Added workflow.
- Added validation.
- Added packaging.

## Benefits

- Faster feedback.

## Testing

- Build completed successfully.

## Related

- Issue #2
```

### Pull Request Guidelines

- Keep pull requests focused.
- Avoid unrelated changes.
- Include documentation updates when required.
- Reference related issues and ADRs.
- Document validation performed.

## Release Notes

Each release should include release notes.

Template:

```text
docs/releases/release-note-example.md
```

Recommended location:

```text
docs/releases/v1.0.0.md
```

Release notes should describe:

- Release purpose.
- Dependency changes.
- Platform support.
- Validation performed.
- Known issues.
- Channel recommendations.

Example workflow:

```text
Create release notes
    ↓
Create annotated tag
    ↓
Publish release
```

## Git Tags

Runtime dependency releases should use annotated tags.

Example:

```bash
git tag -a v1.0.0
```

Example tag message:

```text
Runtime dependency release v1.0.0

Purpose:
Initial macOS dependency release

Changes:
- Perl 5.40.2
- Geo::GDAL::FFI

Channel Recommendation:
- development
```

Use annotated tags for all published releases.

## Code Comments

Prefer comments that explain:

```text
Why
```

rather than:

```text
What
```

Good:

```python
# Retry because startup time varies between runners.
```

Avoid:

```python
# Loop 30 times.
```

Code should remain understandable without excessive comments.

## Documentation

Documentation should be updated whenever behaviour changes.

Update documentation when introducing:

- New workflows.
- New release mechanisms.
- New metadata fields.
- New channels.
- New configuration options.
- New architectural decisions.

Documentation updates should normally be included in the same change as
the implementation.

## Architecture Decision Records

Create an ADR when making decisions about:

- Repository structure.
- Release channels.
- Metadata schema.
- Runtime selection.
- Release publication.
- Artifact naming.
- Configuration strategy.
- Release promotion.

Do not create ADRs for:

- Bug fixes.
- Routine workflow updates.
- Documentation corrections.
- Version bumps.
- Minor implementation details.

ADR filenames should use the following format:

```text
0001-decision-title.md
```

Example:

```text
0005-use-tag-triggered-runtime-dependency-releases.md
```

## Release Workflow Expectations

Published releases should:

- Be created from annotated tags.
- Generate release metadata automatically.
- Generate SHA256 checksums automatically.
- Update `releases.json` automatically.
- Produce GitHub Release assets.
- Follow the artifact naming conventions defined in ADR-0006.

## CI Artifacts vs Release Assets

### CI Artifacts

Generated from commits.

Format:

```text
biodiverse-runtime-dependencies___
```

Example:

```text
biodiverse-runtime-dependencies_macos_arm64_d2ddf75
```

Intended for:

- Development.
- Testing.
- Validation.

### Release Assets

Generated from version tags.

Format:

```text
biodiverse-runtime-dependencies___.zip
```

Example:

```text
biodiverse-runtime-dependencies_macos_arm64_v1.0.0.zip
```

Intended for:

- Distribution.
- Consumption by BiodiverseR runtime packaging workflows.

## Questions

When introducing a substantial change, ask:

```text
Does this require documentation?
Does this require an ADR?
Does this affect releases?
Does this affect metadata?
```

If the answer is yes, update the relevant documentation as part of the
change.
