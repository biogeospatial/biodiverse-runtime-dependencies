# Windows Runtime Dependency Baseline

## Status

Draft

## Scope

This document defines the approved Windows runtime dependency baseline used to generate Windows runtime dependency release artifacts.

The baseline represents the validated and supported dependency set for Windows runtime releases.

## Approved Versions

| Component | Version |
|------------|------------|
| Perl | 5.38.4 |
| GDAL | TBD |
| PROJ | TBD |
| GEOS | TBD |
| OpenSSL | TBD |
| SQLite | TBD |

## Rationale

### Perl

Perl 5.38.4 is the approved Windows Perl version.

This version aligns with the dependency stack used to build the Biodiverse GUI.

Maintaining alignment between the Biodiverse GUI and the runtime dependency distribution reduces compatibility risk and simplifies support.

## Dependency Sources

The Windows baseline is defined using the following repository files:

```text
.github/runtime-dependency-config.yml
runtime/cpanfile
runtime/cpanfile.snapshot
