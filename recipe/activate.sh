# Make sure any CDTs with .pc files can be found.
if [[ -z "${PKG_CONFIG_PATH}" ]]; then
  export PKG_CONFIG_PATH="${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/pkgconfig"
else
  export ORIG_PC_PATH="${PKG_CONFIG_PATH}"
  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/pkgconfig"
fi
