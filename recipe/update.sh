rm asd.txt

echo "  - folder: binary" >> asd.txt
echo "    url: {{ rpm_url }}/glibc-2.17-317.el7.{{ centos_machine }}.rpm"  >> asd.txt

wget http://mirror.centos.org/centos/7.9.2009/os/x86_64/Packages/glibc-2.17-317.el7.x86_64.rpm
sha=$(sha256sum glibc-2.17-317.el7.x86_64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-64\"]" >> asd.txt
rm glibc-2.17-317.el7.x86_64.rpm

wget http://mirror.centos.org/altarch/7/os/aarch64/Packages/glibc-2.17-317.el7.aarch64.rpm
sha=$(sha256sum glibc-2.17-317.el7.aarch64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-aarch64\"]" >> asd.txt
rm glibc-2.17-317.el7.aarch64.rpm

wget http://mirror.centos.org/altarch/7/os/ppc64le/Packages/glibc-2.17-317.el7.ppc64le.rpm
sha=$(sha256sum glibc-2.17-317.el7.ppc64le.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-ppc64le\"]" >> asd.txt
rm glibc-2.17-317.el7.ppc64le.rpm

wget http://download.sinenomine.net/clefos/7/os/s390x/glibc-2.17-317.el7.s390x.rpm
sha=$(sha256sum glibc-2.17-317.el7.s390x.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-s390x\"]" >> asd.txt
rm glibc-2.17-317.el7.s390x.rpm

echo >> asd.txt

echo "  - folder: binary-glibc-common" >> asd.txt
echo "    url: {{ rpm_url }}/glibc-common-2.17-317.el7.{{ centos_machine }}.rpm"  >> asd.txt

wget http://mirror.centos.org/centos/7.9.2009/os/x86_64/Packages/glibc-common-2.17-317.el7.x86_64.rpm
sha=$(sha256sum glibc-common-2.17-317.el7.x86_64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-64\"]" >> asd.txt
rm glibc-common-2.17-317.el7.x86_64.rpm

wget http://mirror.centos.org/altarch/7/os/aarch64/Packages/glibc-common-2.17-317.el7.aarch64.rpm
sha=$(sha256sum glibc-common-2.17-317.el7.aarch64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-aarch64\"]" >> asd.txt
rm glibc-common-2.17-317.el7.aarch64.rpm

wget http://mirror.centos.org/altarch/7/os/ppc64le/Packages/glibc-common-2.17-317.el7.ppc64le.rpm
sha=$(sha256sum glibc-common-2.17-317.el7.ppc64le.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-ppc64le\"]" >> asd.txt
rm glibc-common-2.17-317.el7.ppc64le.rpm

wget http://download.sinenomine.net/clefos/7/os/s390x/glibc-common-2.17-317.el7.s390x.rpm
sha=$(sha256sum glibc-common-2.17-317.el7.s390x.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-s390x\"]" >> asd.txt
rm glibc-common-2.17-317.el7.s390x.rpm

echo >> asd.txt

echo "  - folder: binary-glibc-devel" >> asd.txt
echo "    url: {{ rpm_url }}/glibc-devel-2.17-317.el7.{{ centos_machine }}.rpm"  >> asd.txt

wget http://mirror.centos.org/centos/7.9.2009/os/x86_64/Packages/glibc-devel-2.17-317.el7.x86_64.rpm
sha=$(sha256sum glibc-devel-2.17-317.el7.x86_64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-64\"]" >> asd.txt
rm glibc-devel-2.17-317.el7.x86_64.rpm

wget http://mirror.centos.org/altarch/7/os/aarch64/Packages/glibc-devel-2.17-317.el7.aarch64.rpm
sha=$(sha256sum glibc-devel-2.17-317.el7.aarch64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-aarch64\"]" >> asd.txt
rm glibc-devel-2.17-317.el7.aarch64.rpm

wget http://mirror.centos.org/altarch/7/os/ppc64le/Packages/glibc-devel-2.17-317.el7.ppc64le.rpm
sha=$(sha256sum glibc-devel-2.17-317.el7.ppc64le.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-ppc64le\"]" >> asd.txt
rm glibc-devel-2.17-317.el7.ppc64le.rpm

wget http://download.sinenomine.net/clefos/7/os/s390x/glibc-devel-2.17-317.el7.s390x.rpm
sha=$(sha256sum glibc-devel-2.17-317.el7.s390x.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-s390x\"]" >> asd.txt
rm glibc-devel-2.17-317.el7.s390x.rpm

echo >> asd.txt


echo "  - folder: binary-glibc-headers" >> asd.txt
echo "    url: {{ rpm_url }}/glibc-headers-2.17-317.el7.{{ centos_machine }}.rpm"  >> asd.txt

wget http://mirror.centos.org/centos/7.9.2009/os/x86_64/Packages/glibc-headers-2.17-317.el7.x86_64.rpm
sha=$(sha256sum glibc-headers-2.17-317.el7.x86_64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-64\"]" >> asd.txt
rm glibc-headers-2.17-317.el7.x86_64.rpm

wget http://mirror.centos.org/altarch/7/os/aarch64/Packages/glibc-headers-2.17-317.el7.aarch64.rpm
sha=$(sha256sum glibc-headers-2.17-317.el7.aarch64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-aarch64\"]" >> asd.txt
rm glibc-headers-2.17-317.el7.aarch64.rpm

wget http://mirror.centos.org/altarch/7/os/ppc64le/Packages/glibc-headers-2.17-317.el7.ppc64le.rpm
sha=$(sha256sum glibc-headers-2.17-317.el7.ppc64le.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-ppc64le\"]" >> asd.txt
rm glibc-headers-2.17-317.el7.ppc64le.rpm

wget http://download.sinenomine.net/clefos/7/os/s390x/glibc-headers-2.17-317.el7.s390x.rpm
sha=$(sha256sum glibc-headers-2.17-317.el7.s390x.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-s390x\"]" >> asd.txt
rm glibc-headers-2.17-317.el7.s390x.rpm

echo >> asd.txt


echo "  - folder: binary-glibc-static" >> asd.txt
echo "    url: {{ rpm_url }}/glibc-static-2.17-317.el7.{{ centos_machine }}.rpm"  >> asd.txt

wget http://mirror.centos.org/centos/7.9.2009/os/x86_64/Packages/glibc-static-2.17-317.el7.x86_64.rpm
sha=$(sha256sum glibc-static-2.17-317.el7.x86_64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-64\"]" >> asd.txt
rm glibc-static-2.17-317.el7.x86_64.rpm

wget http://mirror.centos.org/altarch/7/os/aarch64/Packages/glibc-static-2.17-317.el7.aarch64.rpm
sha=$(sha256sum glibc-static-2.17-317.el7.aarch64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-aarch64\"]" >> asd.txt
rm glibc-static-2.17-317.el7.aarch64.rpm

wget http://mirror.centos.org/altarch/7/os/ppc64le/Packages/glibc-static-2.17-317.el7.ppc64le.rpm
sha=$(sha256sum glibc-static-2.17-317.el7.ppc64le.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-ppc64le\"]" >> asd.txt
rm glibc-static-2.17-317.el7.ppc64le.rpm

wget http://download.sinenomine.net/clefos/7/os/s390x/glibc-static-2.17-317.el7.s390x.rpm
sha=$(sha256sum glibc-static-2.17-317.el7.s390x.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-s390x\"]" >> asd.txt
rm glibc-static-2.17-317.el7.s390x.rpm

echo >> asd.txt


echo "  - folder: binary-kernel-headers" >> asd.txt
echo "    url: {{ rpm_url }}/kernel-headers-{{ kernel_headers_version }}-1160.el7.{{ centos_machine }}.rpm  # [cross_target_platform == \"linux-64\"]"  >> asd.txt
echo "    url: {{ rpm_url }}/kernel-headers-{{ kernel_headers_version }}-193.28.1.el7.{{ centos_machine }}.rpm  # [cross_target_platform == \"linux-aarch64\"]"  >> asd.txt
echo "    url: {{ rpm_url }}/kernel-headers-{{ kernel_headers_version }}-1160.el7.{{ centos_machine }}.rpm  # [cross_target_platform == \"linux-ppc64le\"]"  >> asd.txt
echo "    url: {{ rpm_url }}/kernel-headers-{{ kernel_headers_version }}-1160.el7.{{ centos_machine }}.rpm  # [cross_target_platform == \"linux-s390x\"]"  >> asd.txt

wget http://mirror.centos.org/centos/7.9.2009/os/x86_64/Packages/kernel-headers-3.10.0-1160.el7.x86_64.rpm
sha=$(sha256sum kernel-headers-3.10.0-1160.el7.x86_64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-64\"]" >> asd.txt
rm kernel-headers-3.10.0-1160.el7.x86_64.rpm

wget http://mirror.centos.org/altarch/7/os/aarch64/Packages/kernel-headers-4.18.0-193.28.1.el7.aarch64.rpm
sha=$(sha256sum kernel-headers-4.18.0-193.28.1.el7.aarch64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-aarch64\"]" >> asd.txt
rm kernel-headers-4.18.0-193.28.1.el7.aarch64.rpm

wget http://mirror.centos.org/altarch/7/os/ppc64le/Packages/kernel-headers-3.10.0-1160.el7.ppc64le.rpm
sha=$(sha256sum kernel-headers-3.10.0-1160.el7.ppc64le.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-ppc64le\"]" >> asd.txt
rm kernel-headers-3.10.0-1160.el7.ppc64le.rpm

wget http://download.sinenomine.net/clefos/7/os/s390x/kernel-headers-3.10.0-1160.el7.s390x.rpm
sha=$(sha256sum kernel-headers-3.10.0-1160.el7.s390x.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-s390x\"]" >> asd.txt
rm kernel-headers-3.10.0-1160.el7.s390x.rpm

echo >> asd.txt


echo "  - folder: binary-freebl" >> asd.txt
echo "    url: {{ rpm_url }}/nss-softokn-freebl-3.44.0-8.el7_7.{{ centos_machine }}.rpm"  >> asd.txt

wget http://mirror.centos.org/centos/7.9.2009/os/x86_64/Packages/nss-softokn-freebl-3.44.0-8.el7_7.x86_64.rpm
sha=$(sha256sum nss-softokn-freebl-3.44.0-8.el7_7.x86_64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-64\"]" >> asd.txt
rm nss-softokn-freebl-3.44.0-8.el7_7.x86_64.rpm

wget http://mirror.centos.org/altarch/7/os/aarch64/Packages/nss-softokn-freebl-3.44.0-8.el7_7.aarch64.rpm
sha=$(sha256sum nss-softokn-freebl-3.44.0-8.el7_7.aarch64.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-aarch64\"]" >> asd.txt
rm nss-softokn-freebl-3.44.0-8.el7_7.aarch64.rpm

wget http://mirror.centos.org/altarch/7/os/ppc64le/Packages/nss-softokn-freebl-3.44.0-8.el7_7.ppc64le.rpm
sha=$(sha256sum nss-softokn-freebl-3.44.0-8.el7_7.ppc64le.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-ppc64le\"]" >> asd.txt
rm nss-softokn-freebl-3.44.0-8.el7_7.ppc64le.rpm

wget http://download.sinenomine.net/clefos/7/os/s390x/nss-softokn-freebl-3.44.0-8.el7_7.s390x.rpm
sha=$(sha256sum nss-softokn-freebl-3.44.0-8.el7_7.s390x.rpm | cut -b -64)
echo "    sha256: $sha  # [cross_target_platform == \"linux-s390x\"]" >> asd.txt
rm nss-softokn-freebl-3.44.0-8.el7_7.s390x.rpm

echo >> asd.txt

