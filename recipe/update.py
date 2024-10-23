"""
run this in recipe/ folder like
python update.py
or
python update.py -log=INFO
"""
import argparse
import hashlib
import logging
import requests
import os
from ruamel_yaml import BaseLoader, load
from packaging.version import Version

parser = argparse.ArgumentParser()
parser.add_argument('-log', '--loglevel', default='warning')

args = parser.parse_args()
logging.basicConfig(level=args.loglevel.upper())

cbc = os.path.join(".", "conda_build_config.yaml")
if not os.path.exists(cbc):
    raise ValueError("cannot load conda_build_config.yaml; execute script in recipe folder!")

with open(cbc, "r", encoding="utf-8") as f:
    cbc_content = "".join(f.readlines())

config = load(cbc_content, Loader=BaseLoader)
rpm_arches = config["centos_machine"]
conda_arches = config["cross_target_platform"]

alma_version = "8.9"

url_template = (
    f"https://repo.almalinux.org/vault/{alma_version}"
    # second part intententionally not filled yet
    "/{subfolder}/{arch}/os/Packages"
)

el_ver = "el" + alma_version.replace(".", "_")

a = requests.get(url_template.format(subfolder="BaseOS", arch="x86_64")).content.decode('utf-8')

glibc_build1 = 0
glibc_build2 = 0
glibc_version = 0
kernel_headers_build = Version("0.0.0")
kernel_headers_version = 0

for line in a.splitlines():
    if not line.startswith("<a href=\""):
        continue
    line = line[len("<a href=\""):]
    url = line[:line.index("\">")]

    if el_ver not in url:
        continue

    if not url.endswith("x86_64.rpm"):
        continue

    name, version, build = url.rsplit("-", 2)
    # glibc-2.28-236.el8.7.x86_64.rpm
    if name == "glibc":
        glibc_build1 = max(glibc_build1, int(build.split(".")[0]))
        glibc_build2 = max(glibc_build2, int(build.split(".")[2]))
        glibc_version = version

    # kernel-headers-4.18.0-513.24.1.el8_9.x86_64.rpm
    if name == "kernel-headers":
        kernel_headers_build = max(kernel_headers_build, Version(build.rsplit(".", 3)[0]))
        kernel_headers_version = version

glibc_string = f"{glibc_version}-{glibc_build1}.{el_ver}.{glibc_build2}"
kernel_headers_string = f"{kernel_headers_version}-{kernel_headers_build}.{el_ver}"

out_lines = []

name2string = {
    # package name to build string
    "glibc": glibc_string,
    "glibc-all-langpacks": glibc_string,
    "glibc-common": glibc_string,
    "glibc-devel": glibc_string,
    "glibc-gconv-extra": glibc_string,
    "glibc-headers": glibc_string,
    "glibc-nss-devel": glibc_string,
    "glibc-static": glibc_string,
    "kernel-headers": kernel_headers_string,
    "nss_db": glibc_string,
    # manual versions
    # TODO: calculate them automatically as well
    "nss_nis": "3.0-8.el8",
    "nss-softokn-freebl": "3.90.0-6.el8_9",
}

def get_subfolder(pkg, string):
    # find in which subfolder the rpm lives on the alma vault;
    # we assume that the layout for x86_64 works for all arches
    pkg_template = url_template + f"/{pkg}-{string}.x86_64.rpm"
    for sf in ["BaseOS", "PowerTools", "AppStream"]:
        url = pkg_template.format(arch="x86_64", subfolder=sf)
        logging.info(f"Testing if {url} exists")
        if requests.get(url).status_code == 200:
            return sf
    raise ValueError(f"could not find valid artefact for {pkg}-{string}!")

for pkg, string in name2string.items():
    out_lines.append(f"  - folder: binary-{pkg}")
    subfolder = get_subfolder(pkg, string)
    url_jinja = (
        "{{ rpm_url }}" if subfolder == "BaseOS" else
        "{{ powertools_rpm_url }}" if subfolder == "PowerTools" else
        "{{ appstream_rpm_url }}"
    )
    # quadruple curly braces to keep {{ }} jinja templates
    out_lines.append(f"    url: {url_jinja}/{pkg}-{string}.{{{{ centos_machine }}}}.rpm")

    for rpm_arch, conda_arch in zip(rpm_arches, conda_arches):
        rpm_url = (
            url_template.format(arch=rpm_arch, subfolder=subfolder)
            + f"/{pkg}-{string}.{rpm_arch}.rpm"
        )
        logging.info(f"Downloading {rpm_url}")
        r = requests.get(rpm_url)
        if r.status_code != 200:
            logging.warning(f"Could not download rpm for {pkg} from {rpm_url}!")
            continue
        sha = hashlib.sha256(r.content).hexdigest();
        out_lines.append(f'    sha256: {sha}  # [cross_target_platform == "{conda_arch}"]')
    out_lines.append("")

new_meta = []

with open("meta.yaml") as f:
    old_meta = f.readlines()

skip = False
for line in old_meta:
    if line.startswith("{% set alma_version"):
        line = "{% set alma_version = \"" + alma_version + "\" %}"
    if line.startswith("{% set glibc_version"):
        line = "{% set glibc_version = \"" + glibc_version + "\" %}"
    if line.startswith("{% set kernel_headers_version"):
        line = "{% set kernel_headers_version = \"" + kernel_headers_version + "\" %}"
    if line.startswith("  # END source"):
        skip = False
        new_meta.extend(out_lines)
    if not skip:
        new_meta.append(line.rstrip())
    if line.startswith("  # START source"):
        skip = True

new_meta.append("")

with open("meta.yaml", "w") as f:
    f.write("\n".join(new_meta))
