"""A script to compute the source entries for the conda_2_28 sysroots.

You feed it the name of an alma8 rpm like this:

    $ python gen_rpm_shas.py glibc-nss-devel-2.28-211.el8.x86_64.rpm
        url: {{ powertools_rpm_url }}/glibc-nss-devel-2.28-211.el8.{{ centos_machine }}.rpm
        sha256: 8196e6a5e3a8c4b6841de581bc2967cc0034e90ee25bc9a86a12f2d278ce129c  # [cross_target_platform == "linux-64"]
        sha256: 711978f2952ea5eb9ff1a92cc0941ceb0e0acdfae493a7455d07a6dadf7497cd  # [cross_target_platform == "linux-aarch64"]
        sha256: 32bf2c1a57bde3f278b629ca20d3a363afc6322b1524eaadf6a85400bda22706  # [cross_target_platform == "linux-ppc64le"]
        sha256: 95bc39e60907e8a10850c692a547a0584c1617d1155dd4c73d61f969f0ae3a37  # [cross_target_platform == "linux-s390x"]

and it prints the correct source details for the rpm.
"""  # noqa
import sys
import os
import hashlib
import copy
import requests


def _hash_it(url):
    """compute the sha256 of a url"""
    r = requests.get(url)
    r.raise_for_status()
    h = hashlib.sha256(r.content)
    return h.hexdigest()


# map centos_machine to cross_target_platform in recipe/conda
machine_to_platform = {
    "x86_64": "linux-64",
    "aarch64": "linux-aarch64",
    "ppc64le": "linux-ppc64le",
    "s390x": "linux-s390x",
}

rpm_name = sys.argv[1]

# handle common input templates to get back to a regular string
if "{{ centos_machine }}" in rpm_name:
    rpm_name = rpm_name.replace("{{ centos_machine }}", "x86_64")
if "{centos_machine}" in rpm_name:
    rpm_name = rpm_name.replace("{centos_machine}", "x86_64")

# this copy is used for the jinja2 template later
rpm_tmpl = copy.copy(rpm_name)

# make our first template which uses `.format(centos_machine=centos_machine)`
# in python
for centos_machine in [
    "x86_64",
    "aarch64",
    "ppc64le",
    "s390x",
]:
    rpm_name = rpm_name.replace(centos_machine, "{centos_machine}")

# figure out which base url we want
centos_machine = "x86_64"
for rpm_kind, base_url in [
    ("rpm_url", (
        "https://repo.almalinux.org/almalinux/8/BaseOS/"
        "{centos_machine}/os/Packages"
    )),
    ("appstream_rpm_url",  (
        "https://repo.almalinux.org/almalinux/8/AppStream/"
        "{centos_machine}/os/Packages"
    )),
    ("powertools_rpm_url",  (
        "https://repo.almalinux.org/almalinux/8/PowerTools/"
        "{centos_machine}/os/Packages"
    ))
]:
    try:
        _hash_it(
            os.path.join(
                base_url,
                rpm_name
            ).format(centos_machine=centos_machine)
        )
    except Exception as e:
        if "Client Error" not in str(e):
            print(e)
    else:
        break

# now build the url jinja2 template for the recipe
for centos_machine in [
    "x86_64",
    "aarch64",
    "ppc64le",
    "s390x",
]:
    rpm_tmpl = rpm_tmpl.replace(centos_machine, "{{ centos_machine }}")
print("    url: {{ %s }}/%s" % (rpm_kind, rpm_tmpl))

# and build the sha256 entries
for centos_machine in [
    "x86_64",
    "aarch64",
    "ppc64le",
    "s390x",
]:
    url = os.path.join(
        base_url,
        rpm_name
    ).format(centos_machine=centos_machine)
    h = _hash_it(url)

    print("""\
    sha256: %s  # [cross_target_platform == "%s"]""" % (
        h,
        machine_to_platform[centos_machine]
    ))
