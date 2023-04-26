#!/bin/bash

mkdir -p ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot
pushd ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot > /dev/null 2>&1

mkdir -p usr
cp -Rf "${SRC_DIR}"/binary-glibc-langpacks/* usr/
for dr in $(compgen -G "${SRC_DIR}"'/binary-glibc-langpack-*'); do
    if [[ "$(basename ${dr})" != "binary-glibc-langpack-en" ]]; then
        cp -Rf ${dr}/* usr/
    fi
done

mkdir -p usr/lib64
if [ $(compgen -G 'usr/lib/*') ]; then
    mv usr/lib/* usr/lib64/
fi
rm -rf usr/lib

if [ -d "lib" ]; then
    mv lib/* lib64/
    rm -rf lib
fi

popd
