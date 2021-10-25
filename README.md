About linux-sysroot
===================

Home: http://sources.redhat.com/glibc/

Package license: LGPL-2.0-or-later AND LGPL-2.0-or-later WITH exceptions AND GPL-2.0-or-later AND MPL-2.0

Feedstock license: [BSD-3-Clause](https://github.com/conda-forge/linux-sysroot-feedstock/blob/master/LICENSE.txt)

Summary: (CDT) The GNU libc libraries and header files for the Linux kernel for use by glibc

The glibc package contains standard libraries which are used by multiple
programs on the system. In order to save disk space and memory, as well as to
make upgrading easier, common system code is kept in one place and shared
between programs. This particular package contains the most important sets of
shared libraries: the standard C library and the standard math library.
Without these two libraries, a Linux system will not function.

Kernel-headers includes the C header files that specify the interface between
the Linux kernel and userspace libraries and programs.  The header files
define structures and constants that are needed for building most standard
programs and are also needed for rebuilding the glibc package.


Current build status
====================


<table><tr><td>All platforms:</td>
    <td>
      <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=8889&branchName=master">
        <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/linux-sysroot-feedstock?branchName=master">
      </a>
    </td>
  </tr>
</table>

Current release info
====================

| Name | Downloads | Version | Platforms |
| --- | --- | --- | --- |
| [![Conda Recipe](https://img.shields.io/badge/recipe-_sysroot_linux--64_curr_repodata_hack-green.svg)](https://anaconda.org/conda-forge/_sysroot_linux-64_curr_repodata_hack) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/_sysroot_linux-64_curr_repodata_hack.svg)](https://anaconda.org/conda-forge/_sysroot_linux-64_curr_repodata_hack) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/_sysroot_linux-64_curr_repodata_hack.svg)](https://anaconda.org/conda-forge/_sysroot_linux-64_curr_repodata_hack) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/_sysroot_linux-64_curr_repodata_hack.svg)](https://anaconda.org/conda-forge/_sysroot_linux-64_curr_repodata_hack) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-kernel--headers_linux--64-green.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-64) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/kernel-headers_linux-64.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-64) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/kernel-headers_linux-64.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-64) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/kernel-headers_linux-64.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-64) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-kernel--headers_linux--aarch64-green.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-aarch64) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/kernel-headers_linux-aarch64.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-aarch64) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/kernel-headers_linux-aarch64.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-aarch64) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/kernel-headers_linux-aarch64.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-aarch64) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-kernel--headers_linux--ppc64le-green.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-ppc64le) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/kernel-headers_linux-ppc64le.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-ppc64le) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/kernel-headers_linux-ppc64le.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-ppc64le) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/kernel-headers_linux-ppc64le.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-ppc64le) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-kernel--headers_linux--s390x-green.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-s390x) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/kernel-headers_linux-s390x.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-s390x) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/kernel-headers_linux-s390x.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-s390x) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/kernel-headers_linux-s390x.svg)](https://anaconda.org/conda-forge/kernel-headers_linux-s390x) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-sysroot--cos7--aarch64-green.svg)](https://anaconda.org/conda-forge/sysroot-cos7-aarch64) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/sysroot-cos7-aarch64.svg)](https://anaconda.org/conda-forge/sysroot-cos7-aarch64) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/sysroot-cos7-aarch64.svg)](https://anaconda.org/conda-forge/sysroot-cos7-aarch64) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/sysroot-cos7-aarch64.svg)](https://anaconda.org/conda-forge/sysroot-cos7-aarch64) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-sysroot--cos7--ppc64le-green.svg)](https://anaconda.org/conda-forge/sysroot-cos7-ppc64le) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/sysroot-cos7-ppc64le.svg)](https://anaconda.org/conda-forge/sysroot-cos7-ppc64le) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/sysroot-cos7-ppc64le.svg)](https://anaconda.org/conda-forge/sysroot-cos7-ppc64le) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/sysroot-cos7-ppc64le.svg)](https://anaconda.org/conda-forge/sysroot-cos7-ppc64le) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-sysroot--cos7--s390x-green.svg)](https://anaconda.org/conda-forge/sysroot-cos7-s390x) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/sysroot-cos7-s390x.svg)](https://anaconda.org/conda-forge/sysroot-cos7-s390x) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/sysroot-cos7-s390x.svg)](https://anaconda.org/conda-forge/sysroot-cos7-s390x) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/sysroot-cos7-s390x.svg)](https://anaconda.org/conda-forge/sysroot-cos7-s390x) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-sysroot--cos7--x86_64-green.svg)](https://anaconda.org/conda-forge/sysroot-cos7-x86_64) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/sysroot-cos7-x86_64.svg)](https://anaconda.org/conda-forge/sysroot-cos7-x86_64) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/sysroot-cos7-x86_64.svg)](https://anaconda.org/conda-forge/sysroot-cos7-x86_64) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/sysroot-cos7-x86_64.svg)](https://anaconda.org/conda-forge/sysroot-cos7-x86_64) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-sysroot_linux--64-green.svg)](https://anaconda.org/conda-forge/sysroot_linux-64) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/sysroot_linux-64.svg)](https://anaconda.org/conda-forge/sysroot_linux-64) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/sysroot_linux-64.svg)](https://anaconda.org/conda-forge/sysroot_linux-64) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/sysroot_linux-64.svg)](https://anaconda.org/conda-forge/sysroot_linux-64) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-sysroot_linux--aarch64-green.svg)](https://anaconda.org/conda-forge/sysroot_linux-aarch64) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/sysroot_linux-aarch64.svg)](https://anaconda.org/conda-forge/sysroot_linux-aarch64) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/sysroot_linux-aarch64.svg)](https://anaconda.org/conda-forge/sysroot_linux-aarch64) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/sysroot_linux-aarch64.svg)](https://anaconda.org/conda-forge/sysroot_linux-aarch64) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-sysroot_linux--ppc64le-green.svg)](https://anaconda.org/conda-forge/sysroot_linux-ppc64le) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/sysroot_linux-ppc64le.svg)](https://anaconda.org/conda-forge/sysroot_linux-ppc64le) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/sysroot_linux-ppc64le.svg)](https://anaconda.org/conda-forge/sysroot_linux-ppc64le) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/sysroot_linux-ppc64le.svg)](https://anaconda.org/conda-forge/sysroot_linux-ppc64le) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-sysroot_linux--s390x-green.svg)](https://anaconda.org/conda-forge/sysroot_linux-s390x) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/sysroot_linux-s390x.svg)](https://anaconda.org/conda-forge/sysroot_linux-s390x) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/sysroot_linux-s390x.svg)](https://anaconda.org/conda-forge/sysroot_linux-s390x) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/sysroot_linux-s390x.svg)](https://anaconda.org/conda-forge/sysroot_linux-s390x) |

Installing linux-sysroot
========================

Installing `linux-sysroot` from the `conda-forge` channel can be achieved by adding `conda-forge` to your channels with:

```
conda config --add channels conda-forge
conda config --set channel_priority strict
```

Once the `conda-forge` channel has been enabled, `_sysroot_linux-64_curr_repodata_hack, kernel-headers_linux-64, kernel-headers_linux-aarch64, kernel-headers_linux-ppc64le, kernel-headers_linux-s390x, sysroot-cos7-aarch64, sysroot-cos7-ppc64le, sysroot-cos7-s390x, sysroot-cos7-x86_64, sysroot_linux-64, sysroot_linux-aarch64, sysroot_linux-ppc64le, sysroot_linux-s390x` can be installed with:

```
conda install _sysroot_linux-64_curr_repodata_hack kernel-headers_linux-64 kernel-headers_linux-aarch64 kernel-headers_linux-ppc64le kernel-headers_linux-s390x sysroot-cos7-aarch64 sysroot-cos7-ppc64le sysroot-cos7-s390x sysroot-cos7-x86_64 sysroot_linux-64 sysroot_linux-aarch64 sysroot_linux-ppc64le sysroot_linux-s390x
```

It is possible to list all of the versions of `_sysroot_linux-64_curr_repodata_hack` available on your platform with:

```
conda search _sysroot_linux-64_curr_repodata_hack --channel conda-forge
```


About conda-forge
=================

[![Powered by NumFOCUS](https://img.shields.io/badge/powered%20by-NumFOCUS-orange.svg?style=flat&colorA=E1523D&colorB=007D8A)](http://numfocus.org)

conda-forge is a community-led conda channel of installable packages.
In order to provide high-quality builds, the process has been automated into the
conda-forge GitHub organization. The conda-forge organization contains one repository
for each of the installable packages. Such a repository is known as a *feedstock*.

A feedstock is made up of a conda recipe (the instructions on what and how to build
the package) and the necessary configurations for automatic building using freely
available continuous integration services. Thanks to the awesome service provided by
[CircleCI](https://circleci.com/), [AppVeyor](https://www.appveyor.com/)
and [TravisCI](https://travis-ci.com/) it is possible to build and upload installable
packages to the [conda-forge](https://anaconda.org/conda-forge)
[Anaconda-Cloud](https://anaconda.org/) channel for Linux, Windows and OSX respectively.

To manage the continuous integration and simplify feedstock maintenance
[conda-smithy](https://github.com/conda-forge/conda-smithy) has been developed.
Using the ``conda-forge.yml`` within this repository, it is possible to re-render all of
this feedstock's supporting files (e.g. the CI configuration files) with ``conda smithy rerender``.

For more information please check the [conda-forge documentation](https://conda-forge.org/docs/).

Terminology
===========

**feedstock** - the conda recipe (raw material), supporting scripts and CI configuration.

**conda-smithy** - the tool which helps orchestrate the feedstock.
                   Its primary use is in the construction of the CI ``.yml`` files
                   and simplify the management of *many* feedstocks.

**conda-forge** - the place where the feedstock and smithy live and work to
                  produce the finished article (built conda distributions)


Updating linux-sysroot-feedstock
================================

If you would like to improve the linux-sysroot recipe or build a new
package version, please fork this repository and submit a PR. Upon submission,
your changes will be run on the appropriate platforms to give the reviewer an
opportunity to confirm that the changes result in a successful build. Once
merged, the recipe will be re-built and uploaded automatically to the
`conda-forge` channel, whereupon the built conda packages will be available for
everybody to install and use from the `conda-forge` channel.
Note that all branches in the conda-forge/linux-sysroot-feedstock are
immediately built and any created packages are uploaded, so PRs should be based
on branches in forks and branches in the main repository should only be used to
build distinct package versions.

In order to produce a uniquely identifiable distribution:
 * If the version of a package **is not** being increased, please add or increase
   the [``build/number``](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#build-number-and-string).
 * If the version of a package **is** being increased, please remember to return
   the [``build/number``](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#build-number-and-string)
   back to 0.

Feedstock Maintainers
=====================

* [@beckermr](https://github.com/beckermr/)
* [@isuruf](https://github.com/isuruf/)
* [@scopatz](https://github.com/scopatz/)

