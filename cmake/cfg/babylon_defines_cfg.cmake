################################################################################
# Babylon defines configuration
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

# C++ standard
if(NOT BABYLON_CPP_STANDARD)
    if(NOT CMAKE_CXX_STANDARD)
        set(BABYLON_CPP_STANDARD 20 CACHE STRING "" FORCE)
    else()
        set(BABYLON_CPP_STANDARD ${CMAKE_CXX_STANDARD} CACHE STRING "" FORCE)
    endif()
endif()

# C standard
if(NOT BABYLON_C_STANDARD)
    if(NOT CMAKE_C_STANDARD)
        set(BABYLON_C_STANDARD 17 CACHE STRING "" FORCE)
    else()
        set(BABYLON_C_STANDARD ${CMAKE_C_STANDARD} CACHE STRING "" FORCE)
    endif()
endif()

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Build types
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()
set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" "Profile" CACHE STRING "" FORCE)

# Use solution folders feature
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER __CMAKE__)

# Compiler
if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20 CACHE STRING "" FORCE)
endif()
if(NOT CMAKE_C_STANDARD)
    set(CMAKE_C_STANDARD 17 CACHE STRING "" FORCE)
endif()

# Platform
if(WIN32)
    set(BABYLON_OS_WIN 1 CACHE INTERNAL "Is OS Win")
endif()
if(APPLE AND CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(BABYLON_OS_MAC 1 CACHE INTERNAL "Is OS Mac")
endif()
