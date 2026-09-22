"""Refresh Jammy package URLs/checksums: run from recipe/ with Python 3."""
import argparse
import gzip
from pathlib import Path
import re
import urllib.request

ARCHES = {
    "amd64": ("linux-64", "https://archive.ubuntu.com/ubuntu"),
    "arm64": ("linux-aarch64", "https://ports.ubuntu.com/ubuntu-ports"),
}
PACKAGES = ("libc6", "libc6-dev", "libc-bin", "locales", "linux-libc-dev")


def package_index(base, arch):
    url = f"{base}/dists/jammy-updates/main/binary-{arch}/Packages.gz"
    with urllib.request.urlopen(url, timeout=60) as response:
        data = gzip.decompress(response.read()).decode()
    packages = {}
    for paragraph in data.split("\n\n"):
        fields = dict(
            line.split(": ", 1)
            for line in paragraph.splitlines()
            if ": " in line and not line.startswith(" ")
        )
        if fields.get("Package") in PACKAGES:
            packages[fields["Package"]] = fields
    return packages


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--glibc-version", default="2.35-0ubuntu3.15")
    parser.add_argument("--kernel-version", default="5.15.0-191.201")
    args = parser.parse_args()
    if not args.glibc_version.startswith("2.35-"):
        parser.error("this branch packages glibc 2.35")
    indices = {arch: package_index(base, arch) for arch, (_, base) in ARCHES.items()}
    lines = []
    for package in PACKAGES:
        lines.extend([f"  - folder: binary-{package}", f"    fn: {package}.deb"])
        expected = args.kernel_version if package == "linux-libc-dev" else args.glibc_version
        for arch, (platform, base) in ARCHES.items():
            record = indices[arch][package]
            if record["Version"] != expected:
                raise ValueError(f"{arch}/{package}: expected {expected}, found {record['Version']}")
            selector = f'  # [cross_target_platform == "{platform}"]'
            lines.append(f"    url: {base}/{record['Filename']}{selector}")
            lines.append(f"    sha256: {record['SHA256']}{selector}")
        lines.append("")
    recipe = Path("meta.yaml")
    text = recipe.read_text()
    text = re.sub(r"  # START source\n.*?  # END source", "  # START source\n" + "\n".join(lines) + "  # END source", text, flags=re.S)
    text = re.sub(r'{% set kernel_headers_version = ".*?" %}', '{% set kernel_headers_version = "' + args.kernel_version.split('-')[0] + '" %}', text)
    recipe.write_text(text)
    print("Updated source pins. Bump build_number before publishing changed artifacts.")


if __name__ == "__main__":
    main()
