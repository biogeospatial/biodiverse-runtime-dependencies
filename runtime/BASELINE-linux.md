# Linux Runtime Dependency Baseline

## Status

Draft

## Scope

This document defines the approved Linux runtime dependency baseline for Linux runtime dependency release artifacts.

At present, Linux runtime dependency release artifacts are not generated. This baseline establishes the initial approved dependency configuration for future Linux runtime dependency builds.

## Approved Versions

| Component | Version |
|-----------|-----------|
| Perl | 5.38.4 |
| GDAL | TBD |
| PROJ | TBD |
| GEOS | TBD |
| OpenSSL | TBD |
| SQLite | TBD |

## Rationale

### Perl

Perl 5.38.4 is the approved initial Linux Perl version.

This version is defined in:

```text
.github/runtime-dependency-config.yml
