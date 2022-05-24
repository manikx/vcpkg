vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO CppMicroServices/CppMicroservices
    REF v3.4.0
    SHA512 929618416bd0704fd418592a63f04f9280e7e82f424f2cd4ac5ee4b42cfe9e20761e2e5d6768f4102ce696dcf505e27cd1d6405efeb056c0713bd9b99a7804d4 
    HEAD_REF master
    PATCHES
        werror.patch
        fix-dependency-gtest.patch
        fix-warning-c4834.patch
	include-limits-in-refmetadata-cpp.patch
	fix-uninitialized-variable-in-line-noise-doc-c.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
    PREFER_NINJA
    OPTIONS
        -DTOOLS_INSTALL_DIR:STRING=tools/cppmicroservices
        -DAUXILIARY_INSTALL_DIR:STRING=share/cppmicroservices
        -DUS_USE_SYSTEM_GTEST=TRUE
)

vcpkg_install_cmake()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_fixup_cmake_targets()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

# CppMicroServices uses a custom resource compiler to compile resources
# the zipped resources are then appended to the target which cause the linker to crash
# when compiling a static library
if(NOT BUILD_SHARED_LIBS)
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
endif()
