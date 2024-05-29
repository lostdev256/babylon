################################################################################
# Babylon System module
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

# Project
project(System CXX)

# Register in Babylon
babylon_register_module(
    NAME ${PROJECT_NAME}
    ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_DIR lib
    OUTPUT_NAME ${PROJECT_NAME}
    INCLUDE_DIRS include
    SOURCE_SEARCH_MASKS include/*.h include/*.cpp src/*.h src/*.cpp
    DEPEND_MODULES Common
)
