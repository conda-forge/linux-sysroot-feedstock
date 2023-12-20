#!/bin/bash

mkdir -p ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot
pushd ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot > /dev/null 2>&1
mkdir -p usr/include
cp -Rf "${SRC_DIR}"/binary-kernel-headers/include/* usr/include/
popd
