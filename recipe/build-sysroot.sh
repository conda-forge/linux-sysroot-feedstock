#!/bin/bash

mkdir -p ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot
pushd ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot > /dev/null 2>&1
cp -Rf "${SRC_DIR}"/binary/* .
mkdir -p usr/include
cp -Rf "${SRC_DIR}"/binary-glibc-headers/include/* usr/include/
cp -Rf "${SRC_DIR}"/binary-glibc-devel/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-static/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-common/* .

mkdir -p usr/lib
mkdir -p usr/lib64
mv usr/lib/* usr/lib64/
rm -rf usr/lib
ln -s $PWD/usr/lib64 $PWD/usr/lib

if [ -d "lib" ]; then
    mv lib/* lib64/
    rm -rf lib
fi

if [[ "$target_machine" == "s390x" ]]; then
   rm -rf $PWD/lib64/ld64.so.1
   ln -s $PWD/lib64/ld-* $PWD/lib64/ld64.so.1
fi

mkdir -p usr/share
ln -sf ${PREFIX}/share/zoneinfo usr/share/zoneinfo

## Linking or building against libsnsl produces binaries that don't run on recent Linux distributions.
## Libraries and headers removed here to prevent this. See
## https://github.com/conda-forge/rasterio-feedstock/issues/220
rm lib64/libnsl*.so*
rm usr/lib64/libnsl.{a,so}
rm usr/include/rpcsvc/ypclnt.h
rm usr/include/rpcsvc/yp.h
rm usr/include/rpcsvc/yppasswd.h
rm usr/include/rpcsvc/yppasswd.x
rm usr/include/rpcsvc/yp_prot.h
rm usr/include/rpcsvc/ypupd.h
rm usr/include/rpcsvc/yp.x


ln -s $PWD/lib64 $PWD/lib

cp "${SRC_DIR}"/binary-freebl/usr/lib64/libfreebl3.so ${PWD}/usr/lib64/.

popd
