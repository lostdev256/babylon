################################################################################
# Babylon common settings
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Platform
if(APPLE AND CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(BABYLON_OS_MAC TRUE CACHE INTERNAL "" FORCE)
elseif(WIN32)
    set(BABYLON_OS_WIN TRUE CACHE INTERNAL "" FORCE)
endif()

# Environment
if(CMAKE_GENERATOR STREQUAL "Xcode")
    set(CMAKE_XCODE_GENERATE_SCHEME TRUE)
endif()

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
endif()
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" CACHE STRING "" FORCE)

# Language
if (BABYLON_OS_MAC)
    enable_language(OBJC)
    enable_language(OBJCXX)
endif()

# Compiler
set(BABYLON_CL_FLAGS_STYLE_CLANG FALSE CACHE INTERNAL "" FORCE)
set(BABYLON_CL_FLAGS_STYLE_GNU FALSE CACHE INTERNAL "" FORCE)
set(BABYLON_CL_FLAGS_STYLE_MSVC FALSE CACHE INTERNAL "" FORCE)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
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
    bn_log_fatal("Unsupported compiler (${CMAKE_CXX_COMPILER_ID})")
endif()

set(BABYLON_CL_WARNING_AS_ERROR TRUE CACHE STRING "")
set(BABYLON_CL_ASAN FALSE CACHE STRING "")

# C standard
if(NOT CMAKE_C_STANDARD)
    set(CMAKE_C_STANDARD 17 CACHE STRING "")
endif()
if(NOT CMAKE_OBJC_STANDARD)
    set(CMAKE_OBJC_STANDARD 17 CACHE STRING "")
endif()

# C++ standard
if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20 CACHE STRING "")
endif()
if(NOT CMAKE_OBJCXX_STANDARD)
    set(CMAKE_OBJCXX_STANDARD 20 CACHE STRING "")
endif()

# Modules build mode (STATIC|SHARED)
if(NOT BABYLON_MODULES_BUILD_MODE)
    set(BABYLON_MODULES_BUILD_MODE "STATIC" CACHE STRING "")
endif()

# Base build configuration
if(NOT BABYLON_BASE_BUILD_CFG)
    set(BABYLON_BASE_BUILD_CFG "${BABYLON_CMAKE_MODULES_DIR}/cfg.cmake" CACHE STRING "" FORCE)
else()
    macro(parse_cfg_path BASE_BUILD_CFG)
        file(TO_CMAKE_PATH "${BASE_BUILD_CFG}" BASE_BUILD_CFG_NORMALIZED)
        set(BABYLON_BASE_BUILD_CFG "${BASE_BUILD_CFG_NORMALIZED}" CACHE STRING "" FORCE)
    endmacro()
    parse_cfg_path("${BABYLON_BASE_BUILD_CFG}")
endif()

# Use solution folders feature
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER __CMAKE__)
