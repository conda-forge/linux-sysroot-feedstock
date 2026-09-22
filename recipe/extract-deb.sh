# conda-build unpacks the outer .deb archive; extract its data member here.
# bsdtar comes from the output's build environment.
extract_deb() {
    local package_dir="${SRC_DIR}/binary-$1"
    mkdir -p "${package_dir}/root"
    bsdtar -xf "${package_dir}"/data.tar.* -C "${package_dir}/root"
}
