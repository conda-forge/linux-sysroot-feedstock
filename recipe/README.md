# glibc 2.35 sysroots

This recipe is intended for a dedicated `v2.35` maintenance branch, following
this feedstock's existing version branches. It adds an optional glibc 2.35
build target; it does not propose changing conda-forge's default glibc baseline.

Ubuntu Jammy supplies glibc 2.35 for x86-64 and aarch64. The recipe repackages
`libc6`, `libc6-dev`, `libc-bin`, and `locales`, plus `linux-libc-dev` in the
separate kernel-header output. Ubuntu's multiarch paths are normalized to the
existing Conda compiler sysroot layout. Upstream copyright notices, complete
GPL/LGPL texts, and the kernel syscall exception are included (see `licenses/README.md` for provenance).
The system loader and runtime libc remain in use when applications execute.

## Refresh sources

From this directory:

```sh
python update.py --glibc-version 2.35-0ubuntu3.15 --kernel-version 5.15.0-191.201
```

The updater reads both Jammy update indices, requires the specified package
versions, and writes URLs/SHA-256 checksums for both architectures. Increment
`build_number` when updating packages within the same glibc version. Keep the
sysroot and kernel-header outputs synchronized. If a revision has left Ubuntu's
rolling archive, update to its replacement and rerun the tests.

## Validate

Rerender with `conda smithy rerender`. Use the generated `build-locally.py`
configurations to build each target, including both `with_features` variants:

```sh
python build-locally.py linux_64_cross_target_platformlinux-64target_machinex86_64
python build-locally.py linux_64_cross_target_platformlinux-aarch64target_machineaarch64
```

Existing file-content tests cover both architectures. On x86-64, additional
Conda GCC/G++ 11.4 tests compile and execute a call to `_dl_find_object` (added in
glibc 2.35) and a C++ thread/exception probe. The tests check the compiler sysroot,
normal ELF interpreter, and the maximum required GLIBC symbol version.

ARM package-content checks can run on an x86 builder because the outputs are
cross-compilation sysroots. They do not establish ARM runtime compatibility.
Native ARM validation is still required before claiming that qualification.

## Review scope

This proposal needs maintainer agreement on a new `v2.35` version branch and
Ubuntu binary repackaging. The existing feedstock also repackages distribution
binaries; this proposal changes their source distribution for this version.
It retains the existing sysroot output names, `noarch: generic` cross-sysroot
layout, feature variants, and glibc run exports. Other version branches retain
their architecture support; this new branch initially supplies x86-64/aarch64.

The generated AlmaLinux 10 image can execute the glibc 2.35 test programs;
AlmaLinux 9's glibc 2.34 cannot. The image's newer glibc does not become the
compiler sysroot. Consumer tests must also cover Ubuntu 22.04's glibc 2.35.
The GCC/G++ 11.4 test pins deliberately exercise the downstream compatibility
case motivating this version, rather than changing conda-forge's compiler pins.
