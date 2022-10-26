vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO madler/zlib
    REF v1.2.11
    SHA512 104c62ed1228b5f1199bc037081861576900eb0697a226cafa62a35c4c890b5cb46622e399f9aad82ee5dfb475bae26ae75e2bd6da3d261361b1c8b996970faf
    HEAD_REF master
    PATCHES
        cmake_dont_build_more_than_needed.patch
        0001-Prevent-invalid-inclusions-when-HAVE_-is-set-to-0.patch
        debug-postfix-mingw.patch
        0002-android-build-mingw.patch
)

# This is generated during the cmake build
file(REMOVE "${SOURCE_PATH}/zconf.h")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSKIP_INSTALL_FILES=ON
        -DSKIP_BUILD_EXAMPLES=ON
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_cmake_install()
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

# Install the pkgconfig file
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    if(VCPKG_TARGET_IS_WINDOWS)
        vcpkg_replace_string("${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/zlib.pc" "-lz" "-lzlib")
    endif()
    file(COPY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/zlib.pc" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/pkgconfig")
endif()
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    if(VCPKG_TARGET_IS_WINDOWS)
        vcpkg_replace_string("${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/zlib.pc" "-lz" "-lzlibd")
    endif()
    file(COPY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/zlib.pc" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig")
endif()

vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${SOURCE_PATH}/README" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
