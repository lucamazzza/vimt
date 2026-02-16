cmake_minimum_required(VERSION 3.10)
project(vimt VERSION 0.0.1 LANGUAGES CXX OBJCXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SOURCES
    src/main.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})

find_library(APPKIT_LIB AppKit)
find_library(APPSERVICES_LIB ApplicationServices)
find_library(FOUNDATION_LIB Foundation)

target_link_libraries(${PROJECT_NAME} PRIVATE
    ${APPKIT_LIB}
    ${APPSERVICES_LIB}
    ${FOUNDATION_LIB}
    ${CARBON_LIB}
)

target_include_directories(${PROJECT_NAME} PRIVATE include)

set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "vimt"
    MACOSX_BUNDLE FALSE
)
