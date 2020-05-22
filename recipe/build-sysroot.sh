#!/bin/bash

mkdir -p ${PREFIX}/${target_machine}-conda-linux-gnu/sysroot
pushd ${PREFIX}/${target_machine}-conda-linux-gnu/sysroot > /dev/null 2>&1
cp -Rf ${SRC_DIR}/x86_64-conda_cos6-linux-gnu/sysroot/* .
popd
