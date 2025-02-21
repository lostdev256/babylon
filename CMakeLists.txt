################################################################################
# Babylon System module
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

# Register in Babylon
bn_register_unit(BabylonSystem
    UNIT_TYPE Module
    BUILD_CFG tools/cmake/cfg.cmake
    OUTPUT_DIR lib
    PCH include/pch.h
    INCLUDE_DIRS include
    SOURCE_SEARCH_MASKS include/*.h include/*.cpp src/*.h src/*.cpp
    SOURCE_SEARCH_MASKS_OS_WIN include/Platform/Microsoft/Win/*.h src/Platform/Microsoft/Win/*.cpp
    SOURCE_SEARCH_MASKS_OS_MAC include/Platform/Apple/Mac/*.h src/Platform/Apple/Mac/*.mm
)
