################################################################################
# Babylon root project
################################################################################
cmake_minimum_required(VERSION 3.31.0 FATAL_ERROR)

project(Babylon)

set(BABYLON_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "Babylon root directory")

include(${BABYLON_ROOT_DIR}/tools/cmake/babylon.cmake)

# Enable all Babylon modules if root project
if(${BABYLON_ROOT_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    babylon_enable_modules(ALL)
    # TODO: хак для VisualStudio, что бы солющн назывался Babylon.sln, а не по последнему включенному модулю
    project(Babylon)
endif()
