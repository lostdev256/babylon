################################################################################
# Babylon cmake tools
################################################################################
cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

# definitions
set(BABYLON_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set_property(GLOBAL PROPERTY BABYLON_ROOT_DIR ${BABYLON_ROOT_DIR})

# includes
include(babylon_log)
include(babylon_source)
include(babylon_module)
include(babylon_app)
