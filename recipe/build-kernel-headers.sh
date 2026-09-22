#!/bin/bash
set -euxo pipefail
source "${RECIPE_DIR}/extract-deb.sh"
extract_deb linux-libc-dev
sysroot="${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot"
mkdir -p "${sysroot}/usr/include"
cp -a "${SRC_DIR}/binary-linux-libc-dev/root/usr/include/." "${sysroot}/usr/include/"
# Flatten Ubuntu's architecture-specific headers into the compiler include path.
cp -a "${sysroot}/usr/include/${target_machine}-linux-gnu/." "${sysroot}/usr/include/"
rm -r "${sysroot}/usr/include/${target_machine}-linux-gnu"
