#!/bin/bash

mkdir -p ${PREFIX}/${target_machine}-conda-linux-gnu/sysroot
pushd ${PREFIX}/${target_machine}-conda-linux-gnu/sysroot > /dev/null 2>&1
cp -Rf "${SRC_DIR}"/binary/* .
mkdir -p usr/include
cp -Rf "${SRC_DIR}"/binary-kernel-headers/include/* usr/include/
popd
