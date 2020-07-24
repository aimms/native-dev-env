cmake_minimum_required(VERSION 3.2)

project (demoapp)

file (GLOB_RECURSE SRC *.cpp)

add_executable(${PROJECT_NAME} ${SRC})

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)
target_link_libraries(${PROJECT_NAME} PRIVATE demo)
# uncomment if needed
# install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/config.conf DESTINATION ${CMAKE_BINARY_DIR}/bin)
