################################################################################
# Babylon cmake tools
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

block(SCOPE_FOR VARIABLES)
    cmake_path(GET CMAKE_CURRENT_LIST_DIR PARENT_PATH FOUND_ROOT_DIR)
    cmake_path(GET FOUND_ROOT_DIR PARENT_PATH FOUND_ROOT_DIR)
    set(BABYLON_ROOT_DIR "${FOUND_ROOT_DIR}" CACHE INTERNAL "Babylon root directory" FORCE)
endblock()

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

enable_language(OBJC)
enable_language(OBJCXX)

set(BABYLON_CMAKE_MODULES_DIR "${CMAKE_CURRENT_LIST_DIR}/modules" CACHE INTERNAL "Babylon CMake modules directory")
set(BABYLON_CMAKE_PLATFORM_MODULES_DIR "${CMAKE_CURRENT_LIST_DIR}/platforms" CACHE INTERNAL "Babylon CMake platform modules directory")

include("${BABYLON_CMAKE_MODULES_DIR}/log.cmake")
include("${BABYLON_CMAKE_MODULES_DIR}/common.cmake")
include("${BABYLON_CMAKE_MODULES_DIR}/sources.cmake")
include("${BABYLON_CMAKE_MODULES_DIR}/units.cmake")

if(NOT "${BABYLON_ROOT_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
    block(SCOPE_FOR VARIABLES)
        cmake_path(RELATIVE_PATH BABYLON_ROOT_DIR BASE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" OUTPUT_VARIABLE BABYLON_ROOT_DIR_RELATIVE)
        add_subdirectory("${BABYLON_ROOT_DIR_RELATIVE}" Babylon)
    endblock()
endif()
