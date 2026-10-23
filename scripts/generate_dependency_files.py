#!/usr/bin/env python3

from pathlib import Path
import yaml

CONFIG_FILE = ".github/runtime-dependency-config.yml"
RUNTIME_DIR = Path("runtime")


def load_config():
    with open(CONFIG_FILE, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh)


def generate_brewfile(config):
    deps = config["platforms"]["macos"].get(
        "brew_dependencies", []
    )

    output = [
        "# Generated from .github/runtime-dependency-config.yml",
        "# Do not edit manually.",
        "",
    ]

    for dep in deps:
        output.append(f'brew "{dep}"')

    path = RUNTIME_DIR / "Brewfile"

    with open(path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(output) + "\n")

    print(f"Generated {path}")


def generate_cpanfile(config):
    deps = config.get(
        "perl_dependencies", []
    )

    output = [
        "# Generated from .github/runtime-dependency-config.yml",
        "# Do not edit manually.",
        "",
    ]

    for dep in deps:
        output.append(f"requires '{dep}';")

    path = RUNTIME_DIR / "cpanfile"

    with open(path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(output) + "\n")

    print(f"Generated {path}")


def generate_macos_baseline(config):
    macos = config["platforms"]["macos"]

    path = RUNTIME_DIR / "GENERATED-BASELINE-macos.md"

    with open(path, "w", encoding="utf-8") as fh:

        fh.write(
            "# GENERATED - macOS Runtime Dependency Baseline\n\n"
        )

        fh.write("> This file is generated from:\n>\n")
        fh.write("> ```text\n")
        fh.write("> .github/runtime-dependency-config.yml\n")
        fh.write("> ```\n>\n")
        fh.write("> Do not edit manually.\n\n")

        fh.write("## Platform\n\n")
        fh.write("| Property | Value |\n")
        fh.write("|----------|----------|\n")
        fh.write("| Operating System | macOS |\n")
        fh.write("| Architecture | ARM64 |\n")
        fh.write(
            f"| Perl | {macos['perl_version']} |\n\n"
        )

        fh.write("## Homebrew Dependencies\n\n")
        fh.write("| Formula |\n")
        fh.write("|----------|\n")

        for dep in macos.get(
            "brew_dependencies", []
        ):
            fh.write(f"| {dep} |\n")

        fh.write("\n")

        fh.write("## Perl Dependencies\n\n")
        fh.write("| Module |\n")
        fh.write("|----------|\n")

        for dep in config.get(
            "perl_dependencies", []
        ):
            fh.write(f"| {dep} |\n")

        fh.write("\n")

    print(f"Generated {path}")


def generate_linux_baseline(config):
    linux = config["platforms"]["linux"]

    path = RUNTIME_DIR / "GENERATED-BASELINE-linux.md"

    with open(path, "w", encoding="utf-8") as fh:

        fh.write(
            "# GENERATED - Linux Runtime Dependency Baseline\n\n"
        )

        fh.write("> This file is generated from:\n>\n")
        fh.write("> ```text\n")
        fh.write("> .github/runtime-dependency-config.yml\n")
        fh.write("> ```\n>\n")
        fh.write("> Do not edit manually.\n\n")

        fh.write("## Platform\n\n")
        fh.write("| Property | Value |\n")
        fh.write("|----------|----------|\n")
        fh.write("| Operating System | Linux |\n")
        fh.write("| Architecture | x64 |\n")
        fh.write(
            f"| Perl | {linux['perl_version']} |\n\n"
        )

        fh.write("## Perl Dependencies\n\n")
        fh.write("| Module |\n")
        fh.write("|----------|\n")

        for dep in config.get(
            "perl_dependencies", []
        ):
            fh.write(f"| {dep} |\n")

        fh.write("\n")

    print(f"Generated {path}")


def generate_windows_baseline(config):
    windows = config["platforms"]["windows"]

    path = RUNTIME_DIR / "GENERATED-BASELINE-windows.md"

    with open(path, "w", encoding="utf-8") as fh:

        fh.write(
            "# GENERATED - Windows Runtime Dependency Baseline\n\n"
        )

        fh.write("> This file is generated from:\n>\n")
        fh.write("> ```text\n")
        fh.write("> .github/runtime-dependency-config.yml\n")
        fh.write("> ```\n>\n")
        fh.write("> Do not edit manually.\n\n")

        fh.write("## Platform\n\n")
        fh.write("| Property | Value |\n")
        fh.write("|----------|----------|\n")
        fh.write("| Operating System | Windows |\n")
        fh.write("| Architecture | x64 |\n")
        fh.write(
            f"| Perl | {windows['perl_version']} |\n\n"
        )

        fh.write("## Perl Distribution\n\n")
        fh.write("| Property | Value |\n")
        fh.write("|----------|----------|\n")
        fh.write(
            f"| Portable Perl URL | {windows['perl_portable_url']} |\n\n"
        )

        fh.write("## Perl Dependencies\n\n")
        fh.write("| Module |\n")
        fh.write("|----------|\n")

        for dep in config.get(
            "perl_dependencies", []
        ):
            fh.write(f"| {dep} |\n")

        fh.write("\n")

    print(f"Generated {path}")


def main():
    config = load_config()

    generate_brewfile(config)
    generate_cpanfile(config)

    generate_linux_baseline(config)
    generate_macos_baseline(config)
    generate_windows_baseline(config)


if __name__ == "__main__":
    main()
