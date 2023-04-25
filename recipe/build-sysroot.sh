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
cp -Rf "${SRC_DIR}"/binary-glibc-langpacks/* .
cp -Rf "${SRC_DIR}"/binary-glibc-langpack-en/* .
# only doing english to debug
# for dr in $(compgen -G "${SRC_DIR}"'/binary-glibc-langpack-*'); do
#     cp -Rf ${dr}/* .
# done

mkdir -p usr/lib64
if [ $(compgen -G 'usr/lib/*') ]; then
    mv usr/lib/* usr/lib64/
fi
rm -rf usr/lib
ln -s $PWD/usr/lib64 $PWD/usr/lib

if [ -d "lib" ]; then
    mv lib/* lib64/
    rm -rf lib
fi
ln -s $PWD/lib64 $PWD/lib

if [[ "$target_machine" == "s390x" ]]; then
   rm -rf $PWD/lib64/ld64.so.1
   ln -s $PWD/lib64/ld-* $PWD/lib64/ld64.so.1
fi

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

cp "${SRC_DIR}"/binary-freebl/lib64/libfreebl3.so ${PWD}/lib64/.

# the locales have moved - making a sym link to the old area
ln -s $PWD/share/locale $PWD/usr/share/locale

# usr/bin is different?
rm -f $PWD/bin/ld.so
ln -s $PWD/lib64/ld-2.28.so $PWD/bin/ld.so
ln -s $PWD/bin $PWD/usr/bin

popd
