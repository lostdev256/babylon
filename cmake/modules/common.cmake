################################################################################
# Babylon common tools
################################################################################
cmake_minimum_required(VERSION 3.31.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Platform
if(WIN32)
    set(BABYLON_OS_WIN 1 CACHE INTERNAL "")
elseif(APPLE AND CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(BABYLON_OS_MAC 1 CACHE INTERNAL "")
endif()

if(BABYLON_OS_MAC)
    set(BABYLON_CMAKE_PLATFORM_CFG_DIR "${BABYLON_CMAKE_CFG_DIR}/platforms/mac" CACHE INTERNAL "Babylon MacOS CMake cfg directory")
endif()

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "Profile")
endif()
set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" "Profile" CACHE STRING "")

# C++ standard
if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20 CACHE STRING "")
endif()

# C standard
if(NOT CMAKE_C_STANDARD)
    set(CMAKE_CXX_STANDARD ${CMAKE_C_STANDARD} CACHE STRING "")
endif()

# Modules build mode (STATIC|SHARED)
if(NOT BABYLON_MODULES_BUILD_MODE)
    set(BABYLON_MODULES_BUILD_MODE "STATIC" CACHE STRING "")
endif()
