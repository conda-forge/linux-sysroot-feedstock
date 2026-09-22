#define _GNU_SOURCE
#include <dlfcn.h>
#include <gnu/libc-version.h>
#include <stdio.h>

int main(void) {
    struct dl_find_object object;
    if (_dl_find_object((void *)&main, &object) != 0) return 1;
    printf("runtime glibc: %s\n", gnu_get_libc_version());
    return 0;
}
