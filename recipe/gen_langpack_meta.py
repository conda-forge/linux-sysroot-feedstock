import os
import hashlib
import requests
from bs4 import BeautifulSoup
import joblib


def _hash_it(url):
    r = requests.get(url)
    h = hashlib.sha256(r.content)
    return h.hexdigest()


for centos_machine in [
    "x86_64",
    "aarch64",
    "ppc64le",
    "s390x",
]:
    base_url = (
        "https://repo.almalinux.org/almalinux/8/BaseOS/"
        f"{centos_machine}/os/Packages"
    )
    r = requests.get(base_url)
    r.raise_for_status()

    soup = BeautifulSoup(r.text, 'html.parser')

    langpacks = []
    for tag in soup.find_all("a"):
        if tag.text.startswith("glibc-langpack-"):
            langpacks.append(tag.text)

    langpacks = sorted(langpacks)
    jobs = [
        joblib.delayed(_hash_it)(os.path.join(base_url, langpack))
        for langpack in langpacks
    ]
    with joblib.Parallel(n_jobs=8, backend="threading", verbose=0) as par:
        shas = par(jobs)

    print("{% set langpacks_" + centos_machine + " = [")
    vals = []
    for lp, sh in zip(langpacks, shas):
        nm = "-".join(lp.split("-")[0:3])
        vals.append(f"    (\"{nm}\", \"{lp}\", \"{sh}\")")
    print(",\n".join(vals))
    print("] %}")
