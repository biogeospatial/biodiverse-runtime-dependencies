# Release vX.Y.Z

## Purpose

Brief description of the reason for the release.

Example:

```text
Initial macOS runtime dependency release.
```

or:

```text
Upgrade dependency stack to Perl 5.42 and GDAL 3.11.
```

## Release Classification

Channel recommendation:

```text
development
```

Allowed values:

```text
development
testing
stable
```

## Platforms

Supported platforms included in this release:

- [ ] Windows x64
- [ ] macOS ARM64
- [ ] Linux x64

## Dependency Stack

### Perl

```text
5.40.2
```

### Biodiverse Dependencies

List significant dependency versions and upgrades.

Examples:

```text
Geo::GDAL::FFI
Alien::gdal
Alien::proj
Alien::geos::af
```

## Changes

### Added

- Item
- Item

### Changed

- Item
- Item

### Fixed

- Item
- Item

### Removed

- Item
- Item

## Validation

Completed validation activities:

- [ ] Dependency build completed successfully.
- [ ] Dependency artifact packaged successfully.
- [ ] Artifact checksum generated successfully.
- [ ] Release metadata generated successfully.
- [ ] Release asset uploaded successfully.
- [ ] `releases.json` updated successfully.

## Artifact Details

Expected release assets:

```text
biodiverse-runtime-dependencies_windows_x64_vX.Y.Z.zip
biodiverse-runtime-dependencies_macos_arm64_vX.Y.Z.zip
biodiverse-runtime-dependencies_linux_x64_vX.Y.Z.zip
```

## Known Issues

Document any known limitations or unresolved issues.

Example:

```text
Linux dependency release not yet available.
```

## Upgrade Notes

Describe any actions required by consuming repositories.

Example:

```text
No consumer changes required.
```

or:

```text
Update runtime dependency configuration to use Perl 5.42.
```

## Related

- Issue #
- ADR-0001
- ADR-0002
- ADR-0003
