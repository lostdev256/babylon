################################################################################
# Babylon System module
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

# project
project(System CXX)

# register in babylon
babylon_register_module(
    OUTPUT_DIR lib
    OUTPUT_NAME_DEBUG_POSTFIX .debug
    INCLUDE_DIRS include
    SRC_SEARCH_DIRS include src
    DEPENDS Common
)
