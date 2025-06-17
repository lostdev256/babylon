################################################################################
# Babylon UI module
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

# Register in Babylon
babylon_register_unit(BabylonUI
    UNIT_TYPE Module
    BUILD_CFG tools/cmake/cfg.cmake
    OUTPUT_DIR lib
    PCH src/pch.h
    INCLUDE_DIRS include
    SOURCE_SEARCH_MASKS include/*.h include/*.cpp src/*.h src/*.cpp
    DEPEND_UNITS BabylonSystem
)
