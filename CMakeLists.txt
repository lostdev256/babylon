################################################################################
# Babylon System module
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

# Register in Babylon
babylon_register_unit(BabylonSystem
    UNIT_TYPE Module
    OUTPUT_DIR lib
    INCLUDE_DIRS include
    SOURCE_SEARCH_MASKS include/*.h include/*.cpp src/*.h src/*.cpp
    SOURCE_SEARCH_MASKS_OS_WIN include/Platform/win/*.h src/Platform/win/*.cpp
    SOURCE_SEARCH_MASKS_OS_MAC include/Platform/mac/*.h src/Platform/mac/*.mm
)
