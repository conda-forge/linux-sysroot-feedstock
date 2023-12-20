#!/bin/bash

mkdir -p ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot
pushd ${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot > /dev/null 2>&1
cp -Rf "${SRC_DIR}"/binary/* .
mkdir -p usr/include
cp -Rf "${SRC_DIR}"/binary-tzdata/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-headers/include/* usr/include/
cp -Rf "${SRC_DIR}"/binary-glibc-devel/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-static/* usr/
cp -Rf "${SRC_DIR}"/binary-glibc-common/* .

mv usr/lib/* usr/lib64/
rm -rf usr/lib

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

# we supply libcrypt/libxcrypt as a separate package
rm lib64/libcrypt*.so*
rm usr/lib64/libcrypt.{a,so}
rm lib64/libxcrypt*.so*
rm usr/lib64/libxcrypt.{a,so}
rm usr/lib/pkgconfig/libcrypt.pc
rm usr/lib/pkgconfig/libxcrypt.pc


ln -s $PWD/lib64 $PWD/lib

ln -s $PWD/usr/lib64 $PWD/usr/lib

cp "${SRC_DIR}"/binary-freebl/lib64/libfreebl3.so ${PWD}/lib64/.
ln -s ${PWD}/lib64/libfreebl3.so ${PWD}/usr/lib64/libfreebl3.so

sed -i.bak 's,AS_NEEDED,AS_NEEDED ( /lib64/librt.so.1 ) AS_NEEDED,g' usr/lib64/libc.so
rm usr/lib64/libc.so.bak

popd
