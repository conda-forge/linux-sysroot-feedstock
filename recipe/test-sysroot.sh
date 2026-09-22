#!/bin/bash
set -euxo pipefail
compiler="${PREFIX}/bin/x86_64-conda-linux-gnu"
sysroot="${PREFIX}/x86_64-conda-linux-gnu/sysroot"
test "$(readlink -f "$("${compiler}-gcc" -print-sysroot)")" = "$sysroot"
"${compiler}-gcc" test-sysroot.c -Wl,--no-allow-shlib-undefined -o test-c
"${compiler}-g++" test-sysroot.cpp -pthread -Wl,--no-allow-shlib-undefined -o test-cxx
"${compiler}-readelf" --version-info test-c | grep 'GLIBC_2.35'
for executable in test-c test-cxx; do
    # The compiler must not pick up newer libc headers or libraries from the host.
    newest=$("${compiler}-readelf" --version-info "$executable" | grep -oE 'GLIBC_[0-9.]+' | sort -Vu | tail -n 1)
    test "$(printf '%s\n' "$newest" GLIBC_2.35 | sort -V | tail -n 1)" = GLIBC_2.35
    "${compiler}-readelf" -l "$executable" | grep '/lib64/ld-linux-x86-64.so.2'
    "./$executable"
done
