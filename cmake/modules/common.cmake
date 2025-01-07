################################################################################
# Babylon common settings/tools
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Platform
if(WIN32)
    set(BABYLON_OS_WIN TRUE CACHE INTERNAL "" FORCE)
elseif(APPLE AND CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(BABYLON_OS_MAC TRUE CACHE INTERNAL "" FORCE)
endif()

# TODO:
# if(BABYLON_OS_MAC)
#     set(BABYLON_CMAKE_PLATFORM_CFG_DIR "${BABYLON_CMAKE_CFG_DIR}/platforms/mac" CACHE INTERNAL "Babylon MacOS CMake cfg directory")
# endif()

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()
set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" CACHE STRING "")

# Compiler
set(BABYLON_CL_FLAGS_STYLE_CLANG FALSE CACHE INTERNAL "" FORCE)
set(BABYLON_CL_FLAGS_STYLE_GNU FALSE CACHE INTERNAL "" FORCE)
set(BABYLON_CL_FLAGS_STYLE_MSVC FALSE CACHE INTERNAL "" FORCE)

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    if(MSVC)
        set(BABYLON_CL_FLAGS_STYLE_MSVC TRUE CACHE INTERNAL "" FORCE)
    else()
        set(BABYLON_CL_FLAGS_STYLE_CLANG TRUE CACHE INTERNAL "" FORCE)
    endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(BABYLON_CL_FLAGS_STYLE_GNU TRUE CACHE INTERNAL "" FORCE)
elseif(MSVC)
    set(BABYLON_CL_FLAGS_STYLE_MSVC TRUE CACHE INTERNAL "" FORCE)
else ()
    babylon_log_fatal("Unsupported compiler (${CMAKE_CXX_COMPILER_ID})")
endif()

set(BABYLON_CL_WARNING_AS_ERROR TRUE CACHE STRING "")
set(BABYLON_CL_ASAN FALSE CACHE STRING "")

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

# Base build configuration
if(NOT BABYLON_BASE_BUILD_CFG)
    set(BABYLON_BASE_BUILD_CFG "${BABYLON_CMAKE_MODULES_DIR}/cfg.cmake" CACHE STRING "" FORCE)
else()
    file(TO_CMAKE_PATH ${BABYLON_BASE_BUILD_CFG} BABYLON_BASE_BUILD_CFG_NORMALIZED)
    set(BABYLON_BASE_BUILD_CFG ${BABYLON_BASE_BUILD_CFG_NORMALIZED} CACHE STRING "" FORCE)
endif()

# Use solution folders feature
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER __CMAKE__)
