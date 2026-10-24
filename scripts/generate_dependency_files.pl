#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use YAML::XS qw(LoadFile);

my $config_file = '.github/runtime-dependency-config.yml';

my $config = LoadFile($config_file);

generate_brewfile($config);
print "Generated runtime/Brewfile\n";

generate_cpanfile($config);
print "Generated runtime/cpanfile\n";

generate_macos_baseline($config);
print "Generated runtime/GENERATED-BASELINE-macos.md\n";

generate_windows_baseline($config);
print "Generated runtime/GENERATED-BASELINE-windows.md\n";

generate_linux_baseline($config);
print "Generated runtime/GENERATED-BASELINE-linux.md\n";

sub generate_brewfile {
    my ($config) = @_;

    my $deps
      = $config->{platforms}{macos}{brew_dependencies}
      || [];

    open my $fh, '>', 'runtime/Brewfile'
      or die "Cannot write runtime/Brewfile: $!";

    print {$fh}
      "# Generated from .github/runtime-dependency-config.yml\n";
    print {$fh}
      "# Do not edit manually.\n\n";

    for my $dep (@$deps) {
        print {$fh} qq{brew "$dep"\n};
    }

    close $fh
      or die "Cannot close runtime/Brewfile: $!";
}

sub generate_cpanfile {
    my ($config) = @_;

    my $deps
      = $config->{perl_dependencies}
      || [];

    open my $fh, '>', 'runtime/cpanfile'
      or die "Cannot write runtime/cpanfile: $!";

    print {$fh}
      "# Generated from .github/runtime-dependency-config.yml\n";
    print {$fh}
      "# Do not edit manually.\n\n";

    for my $dep (@$deps) {
        print {$fh} qq{requires '$dep';\n};
    }

    close $fh
      or die "Cannot close runtime/cpanfile: $!";
}

sub generate_macos_baseline {
    my ($config) = @_;

    my $macos = $config->{platforms}{macos};

    open my $fh, '>', 'runtime/GENERATED-BASELINE-macos.md'
      or die "Cannot write runtime/GENERATED-BASELINE-macos.md: $!";

    print {$fh} <<'END_MD';
# GENERATED - macOS Runtime Dependency Baseline

> This file is generated from:
>
> ```text
> .github/runtime-dependency-config.yml
> ```
>
> Do not edit manually.

END_MD

    print {$fh} "## Platform\n\n";

    print {$fh} "| Property | Value |\n";
    print {$fh} "|----------|----------|\n";
    print {$fh} "| Operating System | macOS |\n";
    print {$fh} "| Architecture | ARM64 |\n";
    print {$fh} "| Perl | $macos->{perl_version} |\n\n";

    print {$fh} "## Homebrew Dependencies\n\n";
    print {$fh} "| Formula |\n";
    print {$fh} "|----------|\n";

    for my $dep (@{ $macos->{brew_dependencies} || [] }) {
        print {$fh} "| $dep |\n";
    }

    print {$fh} "\n";

    print {$fh} "## Perl Dependencies\n\n";
    print {$fh} "| Module |\n";
    print {$fh} "|----------|\n";

    for my $dep (@{ $config->{perl_dependencies} || [] }) {
        print {$fh} "| $dep |\n";
    }

    print {$fh} "\n";

    print {$fh} "## Documented System Dependency Versions\n\n";
    print {$fh} "| Component | Version |\n";
    print {$fh} "|-----------|-----------|\n";

    my $sys = $macos->{system_dependencies} || {};

    for my $name (sort keys %{$sys}) {
        print {$fh} "| $name | $sys->{$name} |\n";
    }

    print {$fh} "\n";

    close $fh
      or die "Cannot close runtime/GENERATED-BASELINE-macos.md: $!";
}

sub generate_windows_baseline {
    my ($config) = @_;

    my $windows = $config->{platforms}{windows};

    open my $fh, '>', 'runtime/GENERATED-BASELINE-windows.md'
      or die "Cannot write runtime/GENERATED-BASELINE-windows.md: $!";

    print {$fh} <<'END_MD';
# GENERATED - Windows Runtime Dependency Baseline

> This file is generated from:
>
> ```text
> .github/runtime-dependency-config.yml
> ```
>
> Do not edit manually.

END_MD

    print {$fh} "## Platform\n\n";

    print {$fh} "| Property | Value |\n";
    print {$fh} "|----------|----------|\n";
    print {$fh} "| Operating System | Windows |\n";
    print {$fh} "| Architecture | x64 |\n";
    print {$fh} "| Perl | $windows->{perl_version} |\n\n";

    print {$fh} "## Perl Distribution\n\n";

    print {$fh} "| Property | Value |\n";
    print {$fh} "|----------|----------|\n";
    print {$fh}
      "| Portable Perl URL | $windows->{perl_portable_url} |\n\n";

    print {$fh} "## Perl Dependencies\n\n";

    print {$fh} "| Module |\n";
    print {$fh} "|----------|\n";

    for my $dep (
        @{ $config->{perl_dependencies} || [] }
      )
    {
        print {$fh} "| $dep |\n";
    }

    print {$fh} "\n";

    close $fh
      or die "Cannot close runtime/GENERATED-BASELINE-windows.md: $!";
}

sub generate_linux_baseline {
    my ($config) = @_;

    my $linux = $config->{platforms}{linux};

    open my $fh, '>', 'runtime/GENERATED-BASELINE-linux.md'
      or die "Cannot write runtime/GENERATED-BASELINE-linux.md: $!";

    print {$fh} <<'END_MD';
# GENERATED - Linux Runtime Dependency Baseline

> This file is generated from:
>
> ```text
> .github/runtime-dependency-config.yml
> ```
>
> Do not edit manually.

END_MD

    print {$fh} "## Platform\n\n";

    print {$fh} "| Property | Value |\n";
    print {$fh} "|----------|----------|\n";
    print {$fh} "| Operating System | Linux |\n";
    print {$fh} "| Architecture | x64 |\n";
    print {$fh} "| Perl | $linux->{perl_version} |\n\n";

    print {$fh} "## Perl Dependencies\n\n";

    print {$fh} "| Module |\n";
    print {$fh} "|----------|\n";

    for my $dep (
        @{ $config->{perl_dependencies} || [] }
      )
    {
        print {$fh} "| $dep |\n";
    }

    print {$fh} "\n";

    close $fh
      or die "Cannot close runtime/GENERATED-BASELINE-linux.md: $!";
}
