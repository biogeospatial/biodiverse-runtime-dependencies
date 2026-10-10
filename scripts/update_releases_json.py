#!/usr/bin/env python3

import json
import sys
from pathlib import Path

if len(sys.argv) != 8:
    print(
        "Usage: update_releases_json.py "
        "<version> "
        "<windows_url> <windows_sha256> "
        "<macos_url> <macos_sha256> "
        "<linux_url> <linux_sha256>"
    )
    sys.exit(1)

(
    version,
    windows_url,
    windows_sha256,
    macos_url,
    macos_sha256,
    linux_url,
    linux_sha256,
) = sys.argv[1:]

releases_file = Path("releases.json")

with releases_file.open() as f:
    data = json.load(f)

# Ensure expected metadata structure exists.
data.setdefault(
    "channels",
    {
        "stable": "",
        "testing": "",
        "development": "",
    },
)

data.setdefault("releases", {})

data["releases"][version] = {
    "windows": {
        "url": windows_url,
        "sha256": windows_sha256,
    },
    "macos": {
        "url": macos_url,
        "sha256": macos_sha256,
    },
    "linux": {
        "url": linux_url,
        "sha256": linux_sha256,
    },
}

# First release automatically becomes the development release.
if not data["channels"].get("development"):
    data["channels"]["development"] = version

with releases_file.open("w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")

print(f"Added release {version}")
