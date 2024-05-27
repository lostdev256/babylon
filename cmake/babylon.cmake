################################################################################
# Babylon cmake tools
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

# definitions
set(BABYLON_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE FILEPATH "Babylon root dir")
set(BABYLON_CMAKE_MODULES_DIR ${CMAKE_CURRENT_LIST_DIR}/modules CACHE FILEPATH "Babylon CMake modules dir")
set(BABYLON_CMAKE_CFG_DIR ${CMAKE_CURRENT_LIST_DIR}/cfg CACHE FILEPATH "Babylon CMake cfg dir")

# includes
list(APPEND CMAKE_MODULE_PATH ${BABYLON_CMAKE_MODULES_DIR})

include(babylon_log)
include(babylon_source)
include(babylon_module)
include(babylon_app)
