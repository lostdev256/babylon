################################################################################
# Babylon root project
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    project(Babylon)
    include(tools/cmake/babylon.cmake)
endif()

bn_init_unit_system()
bn_collect_internal_units()

if(BABYLON_DEMO)
    add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/demo" demo)
elseif("${BABYLON_ROOT_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
    # Enable all Babylon modules if root project
    bn_enable_units(ALL)
    set(CMAKE_PROJECT_NAME Babylon)
endif()
