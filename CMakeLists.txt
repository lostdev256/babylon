################################################################################
# Babylon root project
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    project(Babylon)
    include(tools/cmake/babylon.cmake)
endif()

babylon_init_unit_system()
babylon_collect_internal_units()

# Enable all Babylon modules if root project
if("${BABYLON_ROOT_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
    babylon_enable_units(ALL)
    set(CMAKE_PROJECT_NAME Babylon)
endif()
