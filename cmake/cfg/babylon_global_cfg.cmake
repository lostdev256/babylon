################################################################################
# Babylon global configuration
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Build types
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()
set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" CACHE STRING "" FORCE)

# Use solution folders feature
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER __CMAKE__)
