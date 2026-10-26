#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${PERL_VERSION:-}" ]]; then
    echo "PERL_VERSION is not set"
    exit 1
fi

echo "Setting up Perl ${PERL_VERSION}"

# Install perlbrew if necessary.
if [[ ! -f "${HOME}/perl5/perlbrew/etc/bashrc" ]]; then
    curl -L https://install.perlbrew.pl | bash
fi

source "${HOME}/perl5/perlbrew/etc/bashrc"

# Install Perl if it is not already available.
if ! perlbrew list | grep -q "perl-${PERL_VERSION}"; then
    perlbrew install --notest "perl-${PERL_VERSION}"
fi

perlbrew use "perl-${PERL_VERSION}"

echo "Using Perl:"
perl -v

# Install cpanminus if necessary.
if ! command -v cpanm >/dev/null 2>&1; then
    curl -L https://cpanmin.us | perl - App::cpanminus
fi

CPANM=$(command -v cpanm)

echo "Using cpanm:"
"${CPANM}" --version

# Install Carton if necessary.
if ! command -v carton >/dev/null 2>&1; then
    "${CPANM}" ${VERBOSE_FLAG:-} Carton
fi

echo "Using Carton:"
carton --version

# Export paths for subsequent workflow steps.
{
    echo "CPANM=${CPANM}"
    echo "CPANM_HOME=${HOME}/.cpanm"
} >> "${GITHUB_ENV}"
