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

url_template = (
    f"https://repo.almalinux.org/vault/{config['alma_version'][0]}"
    # second part intententionally not filled yet
    "/{subfolder}/{arch}/os/Packages"
)

el_ver = "el" + config["alma_version"][0].replace(".", "_")
glibc_string = f"{config['glibc_version'][0]}-{config['glibc_build1'][0]}.{el_ver}.{config['glibc_build2'][0]}"
kernel_headers_string = f"{config['kernel_headers_version'][0]}-{config['kernel_headers_build'][0]}.{el_ver}"

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
    string_jinja = (
        "{{ glibc_string }}" if string == glibc_string else
        "{{ kernel_headers_string }}" if string == kernel_headers_string else string
    )
    # quadruple curly braces to keep {{ }} jinja templates
    out_lines.append(f"    url: {url_jinja}/{pkg}-{string_jinja}.{{{{ centos_machine }}}}.rpm")

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

print("\n".join(out_lines))
