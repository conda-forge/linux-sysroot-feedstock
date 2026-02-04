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
import re
from ruamel.yaml import YAML
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

yaml = YAML(typ='rt')

config = yaml.load(cbc_content)
rpm_arches = config["centos_machine"]
conda_arches = config["cross_target_platform"]

rocky_version = "9.5"

url_template = (
    f"https://download.rockylinux.org/vault/rocky/{rocky_version}"
    # second part intentionally not filled yet
    "/{subfolder}/{arch}/os/Packages/{letter}"
)

el_ver = "el" + rocky_version.replace(".", "_")

# determine version of glibc & kernel-headers; in different subfolders as of rocky 9

baseos_frontpage = url_template.format(subfolder="BaseOS", arch="x86_64", letter="g")
logging.info(f"Fetching content of {baseos_frontpage}")
baseos_pkgs_html = requests.get(baseos_frontpage).content.decode("utf-8")

appstream_frontpage = url_template.format(subfolder="AppStream", arch="x86_64", letter="k")
logging.info(f"Fetching content of {appstream_frontpage}")
appstream_pkgs_html = requests.get(appstream_frontpage).content.decode("utf-8")

pkg_pages = [
    # most glibc
    url_template.format(subfolder="BaseOS", arch="x86_64", letter="g"),
    # glibc-headers
    url_template.format(subfolder="AppStream", arch="x86_64", letter="g"),
    # glibc-static
    url_template.format(subfolder="devel", arch="x86_64", letter="g"),
    # kernel headers
    url_template.format(subfolder="AppStream", arch="x86_64", letter="k"),
]

page_html = ""
for page in pkg_pages:
    logging.info(f"Fetching content of {page}")
    page_html += requests.get(page).content.decode("utf-8")

# glibc artefacts have two build numbers plus the rocky version, e.g.
#   2.28-236.el8_9.13.x86_64.rpm
#   ↑    ↑     ↑   ↑
#   └glibc_ver └rocky_version
#        └build1   └build2
glibc_build1 = 0
glibc_build2 = 0
glibc_version = 0
kernel_headers_build = Version("0.0.0")
kernel_headers_version = 0

# Get content of https://download.rockylinux.org/vault/rocky/8.9/BaseOS/x86_64/os/Packages/g/,
# which looks something like:
# ```
# <html>
# <head><title>Index of /vault/8.9/BaseOS/x86_64/os/Packages/</title></head>
# <body>
# <h1>Index of /vault/8.9/BaseOS/x86_64/os/Packages/</h1>
# <table ...>
# <tr><td ...><a href="{pkg}-{string}.x86_64.rpm" title="...">{pkg}-{string}.x86_64.rpm</a></td>... {size} {date}</tr>
# ...
# </table>
# ...
# ```
for line in page_html.splitlines():
    line = line.strip()
    mo = re.match(r".*<a href=\"([^\"]+)\" title=.*", line)
    if not mo:
        continue
    url = mo.group(1)

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
    # kernel-headers-4.18.0-513.11.1.el8_9.0.1.x86_64.rpm
    if name == "kernel-headers":
        kernel_headers_build = max(kernel_headers_build, Version(build.rsplit(".", build.count(".") - 2)[0]))
        kernel_headers_version = version

if glibc_version == 0:
    raise ValueError("could not determine glibc version!")
if kernel_headers_version == 0:
    raise ValueError("could not determine kernel-headers version!")

glibc_string = f"{glibc_version}-{glibc_build1}.{el_ver}.{glibc_build2}"
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
    "glibc-headers": glibc_string,
    "glibc-static": glibc_string,
    "kernel-headers": kernel_headers_string,
}

def get_subfolder(pkg, string):
    # find in which subfolder the rpm lives on the rocky vault;
    # we assume that the layout for x86_64 works for all arches
    pkg_template = url_template + f"/{pkg}-{string}.x86_64.rpm"
    for sf in ["BaseOS", "AppStream", "devel"]:
        url = pkg_template.format(arch="x86_64", subfolder=sf, letter=pkg[0])
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
    out_lines.append(f"    url: {url_jinja}/{pkg[0]}/{pkg}-{string}.{{{{ centos_machine }}}}.rpm")

    for rpm_arch, conda_arch in zip(rpm_arches, conda_arches):
        rpm_url = (
            url_template.format(arch=rpm_arch, subfolder=subfolder, letter=pkg[0])
            + f"/{pkg}-{string}.{rpm_arch}.rpm"
        )
        logging.info(f"Downloading {rpm_url}")
        r = requests.get(rpm_url)
        if r.status_code != 200:
            logging.warning(f"{r.status_code}: Could not download rpm for {pkg} from {rpm_url}!")
            continue
        sha = hashlib.sha256(r.content).hexdigest();
        out_lines.append(f'    sha256: {sha}  # [cross_target_platform == "{conda_arch}"]')
    out_lines.append("")

new_meta = []

with open("meta.yaml") as f:
    old_meta = f.readlines()

skip = False
for line in old_meta:
    if line.startswith("{% set rocky_version"):
        line = f'{{% set rocky_version = "{rocky_version}" %}}'
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
