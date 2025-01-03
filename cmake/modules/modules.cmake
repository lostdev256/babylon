################################################################################
# Babylon modules tools
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Definitions
set(BABYLON_AVAILABLE_MODULES CACHE INTERNAL "Available Babylon modules")
set(BABYLON_ENABLED_MODULES CACHE INTERNAL "Enabled Babylon modules")
set(BABYLON_MODULE_DEFAULT_CFG "${BABYLON_CMAKE_CFG_DIR}/module_cfg.cmake" CACHE INTERNAL "Default Babylon module cfg")

# Search Babylon root dir for modules
macro(babylon_collect_internal_modules)
    file(GLOB SUB_DIRS LIST_DIRECTORIES true RELATIVE ${BABYLON_ROOT_DIR} modules/*)
    foreach(DIR ${SUB_DIRS})
        if(IS_DIRECTORY ${BABYLON_ROOT_DIR}/${DIR} AND EXISTS ${BABYLON_ROOT_DIR}/${DIR}/CMakeLists.txt)
            add_subdirectory(${DIR} ${DIR})
        endif()
    endforeach()
endmacro()

# Register Babylon module
function(babylon_register_module BABYLON_MODULE)
    set(SINGLE_VALUE_ARGS CFG ROOT_DIR OUTPUT_DIR)
    set(MULTI_VALUE_ARGS INCLUDE_DIRS SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_MAC DEPEND_MODULES)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT BABYLON_MODULE)
        babylon_log_error("Module name not specified")
        return()
    endif()

    if(${BABYLON_MODULE} IN_LIST BABYLON_AVAILABLE_MODULES)
        babylon_log_warn("Module (${BABYLON_MODULE}) already registered")
        return()
    endif()

    if(NOT BABYLON_AVAILABLE_MODULES)
        set(BABYLON_AVAILABLE_MODULES ${BABYLON_MODULE} CACHE INTERNAL "Available Babylon modules")
    else()
        set(BABYLON_AVAILABLE_MODULES "${BABYLON_AVAILABLE_MODULES};${BABYLON_MODULE}" CACHE INTERNAL "Available Babylon modules")
    endif()

    if(NOT ARG_CFG)
        set(BABYLON_MODULE_CFG ${BABYLON_MODULE_DEFAULT_CFG})
        babylon_log_info("Module (${BABYLON_MODULE}) uses default configuration (${BABYLON_MODULE_CFG})")
    else()
        set(BABYLON_MODULE_CFG ${ARG_CFG})
    endif()

    if(NOT ARG_ROOT_DIR)
        set(BABYLON_MODULE_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
        babylon_log_info("Module (${BABYLON_MODULE}) uses default root dir (${BABYLON_MODULE_ROOT_DIR})")
    else()
        set(BABYLON_MODULE_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${ARG_ROOT_DIR})
    endif()

    if(NOT ARG_OUTPUT_DIR)
        set(BABYLON_MODULE_OUTPUT_DIR ${BABYLON_MODULE_ROOT_DIR})
        babylon_log_warn("Module (${BABYLON_MODULE}) uses default output dir (${BABYLON_MODULE_OUTPUT_DIR})")
    else()
        set(BABYLON_MODULE_OUTPUT_DIR ${BABYLON_MODULE_ROOT_DIR}/${ARG_OUTPUT_DIR})
    endif()

    unset(BABYLON_MODULE_INCLUDE_DIRS)
    foreach(DIR ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY ${BABYLON_MODULE_ROOT_DIR}/${DIR})
            list(APPEND BABYLON_MODULE_INCLUDE_DIRS ${BABYLON_MODULE_ROOT_DIR}/${DIR})
        endif()
    endforeach()

    unset(BABYLON_MODULE_SOURCE_SEARCH_MASKS)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS})
        list(APPEND BABYLON_MODULE_SOURCE_SEARCH_MASKS ${BABYLON_MODULE_ROOT_DIR}/${MASK})
    endforeach()
    unset(BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_WIN)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_WIN})
        list(APPEND BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_WIN ${BABYLON_MODULE_ROOT_DIR}/${MASK})
    endforeach()
    unset(BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_MAC)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_MAC})
        list(APPEND BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_MAC ${BABYLON_MODULE_ROOT_DIR}/${MASK})
    endforeach()

    set(BABYLON_MODULE_DEPEND_MODULES ${ARG_DEPEND_MODULES})

    set(${BABYLON_MODULE}_BABYLON_MODULE_CFG ${BABYLON_MODULE_CFG} CACHE INTERNAL "")
    set(${BABYLON_MODULE}_BABYLON_MODULE_ROOT_DIR ${BABYLON_MODULE_ROOT_DIR} CACHE INTERNAL "")
    set(${BABYLON_MODULE}_BABYLON_MODULE_OUTPUT_DIR ${BABYLON_MODULE_OUTPUT_DIR} CACHE INTERNAL "")
    set(${BABYLON_MODULE}_BABYLON_MODULE_INCLUDE_DIRS ${BABYLON_MODULE_INCLUDE_DIRS} CACHE INTERNAL "")
    set(${BABYLON_MODULE}_BABYLON_MODULE_SOURCE_SEARCH_MASKS ${BABYLON_MODULE_SOURCE_SEARCH_MASKS} CACHE INTERNAL "")
    set(${BABYLON_MODULE}_BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_WIN ${BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_WIN} CACHE INTERNAL "")
    set(${BABYLON_MODULE}_BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_MAC ${BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_MAC} CACHE INTERNAL "")
    set(${BABYLON_MODULE}_BABYLON_MODULE_DEPEND_MODULES ${BABYLON_MODULE_DEPEND_MODULES} CACHE INTERNAL "")

    babylon_log_info("Module (${BABYLON_MODULE}) registered")
endfunction()

# Enable Babylon modules
function(babylon_enable_modules)
    set(OPTIONS ALL)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(ARG_ALL)
        set(MODULES ${BABYLON_AVAILABLE_MODULES})
    else()
        set(MODULES ${ARG_UNPARSED_ARGUMENTS})
    endif()

    foreach(MODULE ${MODULES})
        babylon_enable_module(${MODULE})
    endforeach()
endfunction()

# Enable Babylon module
function(babylon_enable_module BABYLON_MODULE)
    if(NOT ${BABYLON_MODULE} IN_LIST BABYLON_AVAILABLE_MODULES)
        babylon_log_error("Module (${BABYLON_MODULE}) doesn't exist")
        return()
    endif()

    if(${BABYLON_MODULE} IN_LIST BABYLON_ENABLED_MODULES)
        return()
    endif()

    if(NOT BABYLON_ENABLED_MODULES)
        set(BABYLON_ENABLED_MODULES ${BABYLON_MODULE} CACHE INTERNAL "Enabled Babylon modules")
    else()
        set(BABYLON_ENABLED_MODULES "${BABYLON_ENABLED_MODULES};${BABYLON_MODULE}" CACHE INTERNAL "Enabled Babylon modules")
    endif()

    set(BABYLON_MODULE_DEPEND_MODULES ${${BABYLON_MODULE}_BABYLON_MODULE_DEPEND_MODULES})

    babylon_enable_modules(${BABYLON_MODULE_DEPEND_MODULES})

    set(BABYLON_MODULE_ROOT_DIR ${${BABYLON_MODULE}_BABYLON_MODULE_ROOT_DIR})
    set(BABYLON_MODULE_OUTPUT_DIR ${${BABYLON_MODULE}_BABYLON_MODULE_OUTPUT_DIR})
    set(BABYLON_MODULE_INCLUDE_DIRS ${${BABYLON_MODULE}_BABYLON_MODULE_INCLUDE_DIRS})
    set(BABYLON_MODULE_SOURCE_SEARCH_MASKS ${${BABYLON_MODULE}_BABYLON_MODULE_SOURCE_SEARCH_MASKS})
    set(BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_WIN ${${BABYLON_MODULE}_BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_WIN})
    set(BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_MAC ${${BABYLON_MODULE}_BABYLON_MODULE_SOURCE_SEARCH_MASKS_OS_MAC})

    include(${${BABYLON_MODULE}_BABYLON_MODULE_CFG})

    babylon_log_info("Module (${BABYLON_MODULE}) enabled")
endfunction()

# Link depend Babylon module
function(babylon_link_depend_module BABYLON_MODULE DEPEND_MODULE)
    if(NOT BABYLON_MODULE)
        babylon_log_error("Module not specified")
        return()
    endif()

    if(NOT ${BABYLON_MODULE} IN_LIST BABYLON_AVAILABLE_MODULES)
        babylon_log_error("Module (${BABYLON_MODULE}) doesn't exist")
        return()
    endif()

    if(NOT ${BABYLON_MODULE} IN_LIST BABYLON_ENABLED_MODULES)
        babylon_log_error("Module (${BABYLON_MODULE}) doesn't enabled")
        return()
    endif()

    if(NOT DEPEND_MODULE)
        babylon_log_error("Depend module not specified")
        return()
    endif()

    if(NOT ${DEPEND_MODULE} IN_LIST BABYLON_AVAILABLE_MODULES)
        babylon_log_error("Depend module (${DEPEND_MODULE}) doesn't exist")
        return()
    endif()

    if(NOT ${DEPEND_MODULE} IN_LIST BABYLON_ENABLED_MODULES)
        babylon_log_error("Depend module (${DEPEND_MODULE}) doesn't enabled")
        return()
    endif()

    foreach(DIR ${${DEPEND_MODULE}_BABYLON_MODULE_INCLUDE_DIRS})
        target_include_directories(${BABYLON_MODULE} PRIVATE ${DIR})
    endforeach()

    target_link_libraries(${BABYLON_MODULE} PUBLIC ${DEPEND_MODULE})
    add_dependencies(${BABYLON_MODULE} ${DEPEND_MODULE})
endfunction()
