# Reset path back to what it was originally.
if [[ -z "${ORIG_PC_PATH}" ]]; then
  unset PKG_CONFIG_PATH
else
  export PKG_CONFIG_PATH="${ORIG_PC_PATH}"
  unset ORIG_PC_PATH
fi
