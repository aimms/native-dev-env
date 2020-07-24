cmake_minimum_required(VERSION 3.16)


include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)

conan_basic_setup(TARGETS KEEP_RPATHS)

if(APPLE)
    set(CMAKE_INSTALL_RPATH "@executable_path")
else()
    set(CMAKE_INSTALL_RPATH "$ORIGIN")
endif()
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)

add_compile_options("-Wextra" "-Werror" "$<$<CONFIG:RELEASE>:-O3>" "-stdlib=libc++")
add_link_options("-stdlib=libc++" "-lc++abi")

add_subdirectory(src/common)
add_subdirectory(src/demoapp)


