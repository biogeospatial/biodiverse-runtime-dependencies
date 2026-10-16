# Perl Dependency Definition

The repository uses:

```text
runtime/cpanfile
```

to define intended Perl runtime dependencies.

The cpanfile records dependency intent and provides the foundation for:

- CPAN dependency management.
- Dependency locking.
- Carton support.
- Runtime dependency reproducibility.

Current dependencies:

```perl
requires 'App::cpanminus';
```
