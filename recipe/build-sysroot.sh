#!/bin/bash

mkdir -p ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot
pushd ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot > /dev/null 2>&1
cp -Rf "${SRC_DIR}"/binary/* .
mkdir -p usr/include
cp -Rf "${SRC_DIR}"/binary-tzdata/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-headers/include/* usr/include/
cp -Rf "${SRC_DIR}"/binary-glibc-devel/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-common/* .

mv usr/lib/* usr/lib64/
rm -rf usr/lib
ln -s $PWD/lib64 $PWD/lib

ln -s $PWD/usr/lib64 $PWD/usr/lib

popd

if [[ ${ctng_vendor} == "conda_cos6" ]]; then
  mkdir -p ${PREFIX}/${target_machine}-conda-linux-gnu/sysroot
  pushd ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot
  for dn in $(ls -d */); do
    mkdir -p ${PREFIX}/${target_machine}-conda-linux-gnu/sysroot/${dn}
    pushd ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot/${dn}
    for fdn in $(ls -1d *); do
      ln -s ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot/${dn}${fdn} ${PREFIX}/${target_machine}-conda-linux-gnu/sysroot/${dn}${fdn}
    done
    popd
  done
  popd
fi
