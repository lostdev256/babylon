################################################################################
# Babylon UI module
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

# Register in Babylon
babylon_register_module(BabylonUI
    OUTPUT_DIR lib
    INCLUDE_DIRS include
    SOURCE_SEARCH_MASKS include/*.h include/*.cpp src/*.h src/*.cpp
    DEPEND_MODULES BabylonSystem
)
