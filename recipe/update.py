"""
run this in recipe/ folder like
python update.py
or
python update.py -log=INFO
"""
import argparse
import gzip
import hashlib
import logging
import pathlib
import re
import requests
import os
import xml.etree.ElementTree as ET
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

distro_version = "10.0"
rocky_base_url = f"https://dl.rockylinux.org/pub/rocky/{distro_version}"

# second part intententionally not filled yet
url_template = rocky_base_url + "/{subfolder}/{arch}/os/Packages"

# since the rockylinux repodata is >20MB, we cache the result, so that iterative runs
# during development don't always need to redownload the whole thing; we know from above
# that we're running in recipe folder, where we can add an appropriate .gitignore without
# the bot touching it (as opposed to the .gitignore in the feedstock root)
cache_dir = pathlib.Path("./.cache")
cache_dir.mkdir(exist_ok=True)
cache_file = cache_dir / f"rocky_repodata_{distro_version}.cache"
if cache_file.exists():
    logging.info(f"Loading cached {cache_file}")
    rocky_repodata_raw = cache_file.read_bytes()
else:
    logging.info("getting rockylinux channel metadata")
    r = requests.get(rocky_base_url + "/BaseOS/x86_64/os/repodata/repomd.xml")
    r.raise_for_status()
    rocky_meta_repodata = ET.fromstring(r.content)
    meta_ns = {"repo": "http://linux.duke.edu/metadata/repo"}
    # Find the <data type="primary"> element
    rocky_repodata_xml = rocky_meta_repodata.find("repo:data[@type='primary']", meta_ns)
    # Extract its <location> child
    rocky_repodata_rel_url = rocky_repodata_xml.find("repo:location", meta_ns).get("href")
    rocky_repodata_url = rocky_base_url + "/BaseOS/x86_64/os/" + rocky_repodata_rel_url

    logging.info("getting rockylinux repodata")
    r = requests.get(rocky_repodata_url)
    r.raise_for_status()
    rocky_repodata_raw = r.content
    cache_file.write_bytes(rocky_repodata_raw)

rocky_repodata = ET.fromstring(gzip.decompress(rocky_repodata_raw))

def rpm_urls():
    repo_ns = {"common": "http://linux.duke.edu/metadata/common"}
    for loc in rocky_repodata.findall(".//common:location", repo_ns):
        href = loc.get("href")
        if href:
            yield href

el_ver = "el" + distro_version.replace(".", "_")

# glibc artefacts have two build numbers plus the alma version, e.g.
#   2.39-43.el10_0.x86_64.rpm
#   ↑    ↑     ↑
#   └glibc_ver └distro_version
#        └build1
glibc_build1 = 0
glibc_version = 0
kernel_headers_build = Version("0.0.0")
kernel_headers_version = 0

for url in rpm_urls():
    if el_ver not in url:
        continue

    if not url.endswith("x86_64.rpm"):
        continue

    artefact = re.sub(r"Packages\/[a-z]\/(.*)", r"\1", url)
    name, version, build = artefact.rsplit("-", 2)
    # glibc-2.39-43.el10_0.x86_64.rpm
    if name == "glibc":
        glibc_build1 = max(glibc_build1, int(build.split(".")[0]))
        glibc_version = version

    # kernel-6.12.0-55.41.1.el10_0.x86_64.rpm
    if name == "kernel":
        kernel_headers_build = max(kernel_headers_build, Version(build.rsplit(".", 3)[0]))
        kernel_headers_version = version

if glibc_version == 0:
    raise ValueError("could not determine glibc version!")
if kernel_headers_version == 0:
    raise ValueError("could not determine kernel-headers version!")

glibc_string = f"{glibc_version}-{glibc_build1}.{el_ver}"
kernel_headers_string = f"{kernel_headers_version}-{kernel_headers_build}.{el_ver}"

logging.info(f"Determined {glibc_string=}")
logging.info(f"Determined {kernel_headers_string=}")

out_lines = []

name2string = {
    # package name to build string
    "glibc": glibc_string,
    "glibc-all-langpacks": glibc_string,
    "glibc-common": glibc_string,
    "glibc-devel": glibc_string,
    "glibc-gconv-extra": glibc_string,
    "glibc-static": glibc_string,
    "kernel": kernel_headers_string,
}

def get_subfolder(pkg, string):
    # find in which subfolder the rpm lives on the alma vault;
    # we assume that the layout for x86_64 works for all arches
    pkg_template = url_template + f"/{pkg[0]}/{pkg}-{string}.x86_64.rpm"
    for sf in ["BaseOS", "CRB", "AppStream"]:
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
        "{{ crb_rpm_url }}" if subfolder == "CRB" else
        "{{ appstream_rpm_url }}"
    )
    # quadruple curly braces to keep {{ }} jinja templates
    out_lines.append(f"    url: {url_jinja}/{pkg}-{string}.{{{{ centos_machine }}}}.rpm")

    for rpm_arch, conda_arch in zip(rpm_arches, conda_arches):
        rpm_url = (
            url_template.format(arch=rpm_arch, subfolder=subfolder)
            + f"/{pkg[0]}/{pkg}-{string}.{rpm_arch}.rpm"
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
    if line.startswith("{% set distro_version"):
        line = f'{{% set distro_version = "{distro_version}" %}}'
    elif line.startswith("{% set glibc_version"):
        line = f'{{% set glibc_version = "{glibc_version}" %}}'
    elif line.startswith("{% set kernel_headers_version"):
        line = f'{{% set kernel_headers_version = "{kernel_headers_version}" %}}'
    elif line.startswith("  # END source"):
        skip = False
        # skip empty line at the end
        new_meta.extend(out_lines[:-1])

    if not skip:
        new_meta.append(line.rstrip())
        if line.startswith("  # START source"):
            skip = True

new_meta.append("")

with open("meta.yaml", "w") as f:
    f.write("\n".join(new_meta))
