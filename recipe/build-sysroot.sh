#!/bin/bash
set -euxo pipefail
source "${RECIPE_DIR}/extract-deb.sh"
sysroot="${PREFIX}/${target_machine}-${ctng_vendor}-linux-gnu/sysroot"
mkdir -p "${sysroot}"
for package in libc6 libc6-dev libc-bin locales; do
    extract_deb "$package"
    cp -a --remove-destination "${SRC_DIR}/binary-${package}/root/." "${sysroot}/"
done
cd "${sysroot}"

# Ubuntu uses multiarch subdirectories; Conda compilers expect lib64 and
# usr/include. Keep lib64 as a directory for conda-build sysroot detection.
mkdir -p lib64
# Discard Ubuntu's loader aliases before merging the real loader into lib64.
find lib lib64 -maxdepth 1 -type l -name 'ld-linux-*.so.*' -delete
cp -a --remove-destination "lib/${target_machine}-linux-gnu/." lib64/
cp -a --remove-destination "usr/lib/${target_machine}-linux-gnu/." lib64/
rm -r "lib/${target_machine}-linux-gnu" "usr/lib/${target_machine}-linux-gnu"
cp -a --remove-destination "usr/include/${target_machine}-linux-gnu/." usr/include/
rm -r "usr/include/${target_machine}-linux-gnu"
# Preserve architecture-independent data (gconv/locale data, ld.so, etc.).
cp -a --remove-destination lib/. lib64/
cp -a --remove-destination usr/lib/. lib64/
rm -r lib usr/lib
ln -s lib64 lib
ln -s ../lib64 usr/lib
ln -s ../lib64 usr/lib64

# Rewrite multiarch paths in GNU ld scripts; ld resolves these within --sysroot.
for script in lib64/libc.so lib64/libm.so; do
    # libm.so is a linker script on x86-64 and a symlink on aarch64.
    if [[ ! -L "$script" ]]; then
        sed -i "s@/usr/lib/${target_machine}-linux-gnu/@/usr/lib64/@g; s@/lib/${target_machine}-linux-gnu/@/lib64/@g" "$script"
    fi
done
# The dynamic-loader symlinks in the Ubuntu packages use absolute paths.
for path in lib64/*; do
    if [[ -L "$path" && "$(readlink "$path")" = /* ]]; then
        ln -sf "$(basename "$(readlink "$path")")" "$path"
    fi
done
mkdir -p usr/bin usr/sbin
if [[ -d sbin ]]; then
    cp -a --remove-destination sbin/. usr/sbin/
    rm -r sbin
fi
ln -s usr/sbin sbin
ln -s usr/bin bin
ln -s "../../lib64/$(basename "$(find lib64 -maxdepth 1 -name 'ld-linux-*.so.*' | head -n 1)")" usr/bin/ld.so

# Match the existing sysroot policy: external packages provide libnsl/libcrypt.
rm -f lib64/libnsl* lib64/libcrypt* usr/include/crypt.h usr/include/rpcsvc/yp*
mkdir -p usr/share
# Ubuntu's absolute alias points outside the sysroot and may be absent on the
# build host. Keep locale tools/data self-contained after prefix relocation.
ln -sfn ../../../etc/locale.alias usr/share/locale/locale.alias
ln -sf "${PREFIX}/share/zoneinfo" usr/share/zoneinfo
rm -rf usr/share/man usr/share/doc usr/lib/systemd
mkdir -p "${PREFIX}/bin"
echo "--sysroot=${sysroot}" >> "${PREFIX}/bin/${target_machine}-${ctng_vendor}-linux-gnu.cfg"
