# macOS Runtime Dependency Baseline

## Status

Draft

## Scope

This document defines the approved macOS runtime dependency baseline used to generate macOS runtime dependency release artifacts.

## Approved Versions

| Component | Version |
|-----------|-----------|
| Perl | 5.38.4 |
| GDAL | 3.13.3 |
| GSL | 2.8 |
| SQLite | 3.53.4 |

## Baseline Source

This baseline is derived from the most recent successful automated macOS runtime dependency build.

## Rationale

The macOS runtime dependency build process has historically been affected by upstream dependency changes, including failures involving:

- Net::SSLeay
- Alien::* modules
- GDAL-related dependencies
- Homebrew package updates

As a result, the approved baseline is based on a known-working configuration rather than automatically tracking current upstream versions.

Dependency updates require validation through the macOS runtime dependency build process before adoption.

## Build Environment

Successful baseline build:

```text
GitHub Actions runner: macos-26-arm64
macOS: 26.6.2
Architecture: ARM64
