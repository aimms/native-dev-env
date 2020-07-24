cmake_minimum_required(VERSION 3.2)

project (demo)

file(GLOB SRC *.cpp)

add_library(${PROJECT_NAME} SHARED ${SRC})

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)

target_link_libraries(${PROJECT_NAME} PUBLIC
                        CONAN_PKG::boost
        )

# Make sure we can find the generated headers
target_include_directories(${PROJECT_NAME}
        PUBLIC include
        )
install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/bin)