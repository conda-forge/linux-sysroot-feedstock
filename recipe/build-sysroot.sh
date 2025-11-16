#!/bin/bash

mkdir -p ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot
pushd ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot > /dev/null 2>&1
cp -Rf "${SRC_DIR}"/binary-glibc/* .
mkdir -p usr/include
cp -Rf "${SRC_DIR}"/binary-glibc-devel/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-static/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-common/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-gconv-extra/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-all-langpacks/* usr/

mkdir -p usr/lib64
if [[ $(compgen -G 'usr/lib/*') != "" ]]; then
    mv usr/lib/* usr/lib64/
fi
rm -rf usr/lib
ln -s $PWD/usr/lib64 $PWD/usr/lib

if [ -d "lib64" ]; then
    mv lib64/* usr/lib64/
    rm -rf lib64
fi
if [ -d "lib" ]; then
    mv lib/* usr/lib64/
    rm -rf lib
fi
ln -s $PWD/usr/lib64 $PWD/lib64
ln -s $PWD/usr/lib64 $PWD/lib

## Linking or building against libsnsl produces binaries that don't run on recent Linux distributions.
## Libraries and headers removed here to prevent this. See
## https://github.com/conda-forge/rasterio-feedstock/issues/220
rm -f lib64/libnsl*.so*
rm -f usr/lib64/libnsl.{a,so}
rm -f usr/include/rpcsvc/ypclnt.h
rm -f usr/include/rpcsvc/yp.h
rm -f usr/include/rpcsvc/yppasswd.h
rm -f usr/include/rpcsvc/yppasswd.x
rm -f usr/include/rpcsvc/yp_prot.h
rm -f usr/include/rpcsvc/ypupd.h
rm -f usr/include/rpcsvc/yp.x

if [[ "$target_machine" == "s390x" ]]; then
   rm -rf $PWD/usr/lib64/ld64.so.1
   ln -s $PWD/usr/lib64/ld-* $PWD/usr/lib64/ld64.so.1
fi

mkdir -p usr/share
ln -sf ${PREFIX}/share/zoneinfo usr/share/zoneinfo

# we don't need these
rm -rf usr/share/man
rm -rf usr/lib/systemd
rm -rf usr/share/doc

popd

mkdir -p ${PREFIX}/bin
echo "--sysroot=${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot" >> ${PREFIX}/bin/${target_machine}-${ctng_vendor}-linux-gnu.cfg
