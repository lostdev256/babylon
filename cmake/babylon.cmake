################################################################################
# Babylon cmake tools
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Definitions
set(BABYLON_CMAKE_MODULES_DIR ${CMAKE_CURRENT_LIST_DIR}/modules CACHE INTERNAL "Babylon CMake modules directory")
set(BABYLON_CMAKE_CFG_DIR ${CMAKE_CURRENT_LIST_DIR}/cfg CACHE INTERNAL "Babylon CMake cfg directory")

if(BABYLON_OS_MAC)
    set(BABYLON_CMAKE_PLATFORM_CFG_DIR ${BABYLON_CMAKE_CFG_DIR}/platforms/mac CACHE INTERNAL "Babylon MacOS CMake cfg directory")
else()
    unset(BABYLON_CMAKE_PLATFORM_CFG_DIR CACHE)
endif()

# Includes
include(${BABYLON_CMAKE_MODULES_DIR}/babylon_log.cmake)
include(${BABYLON_CMAKE_MODULES_DIR}/babylon_source.cmake)
include(${BABYLON_CMAKE_MODULES_DIR}/babylon_module.cmake)
include(${BABYLON_CMAKE_MODULES_DIR}/babylon_app.cmake)

# Babylon global configure
macro(babylon_global_configure)
    include(${BABYLON_CMAKE_CFG_DIR}/babylon_global_cfg.cmake)
endmacro()
