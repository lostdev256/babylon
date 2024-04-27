################################################################################
# Babylon root project
################################################################################
cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

# project
project(Babylon CXX)

# includes
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/tools/cmake/modules)
include(babylon)

# collect babylon modules
babylon_collect_modules()

# add all babylon modules if root project
if(${CMAKE_CURRENT_SOURCE_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    babylon_add_modules(ALL)
endif()
