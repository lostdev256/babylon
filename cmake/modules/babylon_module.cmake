################################################################################
# Babylon modules tools
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Definitions
set(BABYLON_AVAILABLE_MODULES CACHE INTERNAL "Available Babylon modules")
set(BABYLON_ENABLED_MODULES CACHE INTERNAL "Enabled Babylon modules")
set(BABYLON_MODULE_DEFAULT_CFG ${BABYLON_CMAKE_CFG_DIR}/babylon_module_cfg.cmake CACHE INTERNAL "Default Babylon module cfg")

# Search Babylon root dir for modules
macro(babylon_collect_internal_modules)
    file(GLOB sub_dirs LIST_DIRECTORIES true RELATIVE ${BABYLON_ROOT_DIR} modules/*)
    foreach(dir ${sub_dirs})
        if(IS_DIRECTORY ${BABYLON_ROOT_DIR}/${dir} AND EXISTS ${BABYLON_ROOT_DIR}/${dir}/CMakeLists.txt)
            add_subdirectory(${dir} ${dir})
        endif()
    endforeach()
endmacro()

# Register Babylon module
macro(babylon_register_module)
    set(single_value_args NAME CFG ROOT_DIR OUTPUT_DIR OUTPUT_NAME)
    set(multi_value_args INCLUDE_DIRS SOURCE_SEARCH_MASKS DEPEND_MODULES)
    cmake_parse_arguments("ARG" "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    if(NOT ARG_NAME)
        set(BABYLON_MODULE ${PROJECT_NAME})
        babylon_log_info("Module uses default name (${BABYLON_MODULE})")
    else()
        set(BABYLON_MODULE ${ARG_NAME})
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
        set(BABYLON_MODULE_ROOT_DIR ${ARG_ROOT_DIR})
    endif()

    if(NOT ARG_OUTPUT_DIR)
        set(BABYLON_MODULE_OUTPUT_DIR ${BABYLON_MODULE_ROOT_DIR})
        babylon_log_warn("Module (${BABYLON_MODULE}) uses default output dir (${BABYLON_MODULE_OUTPUT_DIR})")
    else()
        set(BABYLON_MODULE_OUTPUT_DIR ${BABYLON_MODULE_ROOT_DIR}/${ARG_OUTPUT_DIR})
    endif()

    if(NOT ARG_OUTPUT_NAME)
        set(BABYLON_MODULE_OUTPUT_NAME ${BABYLON_MODULE})
        babylon_log_warn("Module (${BABYLON_MODULE}) uses default output name (${BABYLON_MODULE_OUTPUT_NAME})")
    else()
        set(BABYLON_MODULE_OUTPUT_NAME ${ARG_OUTPUT_NAME})
    endif()

    unset(BABYLON_MODULE_INCLUDE_DIRS)
    foreach(dir ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY ${BABYLON_MODULE_ROOT_DIR}/${dir})
            list(APPEND BABYLON_MODULE_INCLUDE_DIRS ${BABYLON_MODULE_ROOT_DIR}/${dir})
        endif()
    endforeach()

    unset(BABYLON_MODULE_SOURCE_SEARCH_MASKS)
    foreach(mask ${ARG_SOURCE_SEARCH_MASKS})
        list(APPEND BABYLON_MODULE_SOURCE_SEARCH_MASKS ${BABYLON_MODULE_ROOT_DIR}/${mask})
    endforeach()

    set(BABYLON_MODULE_DEPEND_MODULES ${ARG_DEPEND_MODULES})

    set(BABYLON_MODULE_CFG_${BABYLON_MODULE} ${BABYLON_MODULE_CFG} CACHE INTERNAL "")
    set(BABYLON_MODULE_ROOT_DIR_${BABYLON_MODULE} ${BABYLON_MODULE_ROOT_DIR} CACHE INTERNAL "")
    set(BABYLON_MODULE_OUTPUT_DIR_${BABYLON_MODULE} ${BABYLON_MODULE_OUTPUT_DIR} CACHE INTERNAL "")
    set(BABYLON_MODULE_OUTPUT_NAME_${BABYLON_MODULE} ${BABYLON_MODULE_OUTPUT_NAME} CACHE INTERNAL "")
    set(BABYLON_MODULE_INCLUDE_DIRS_${BABYLON_MODULE} ${BABYLON_MODULE_INCLUDE_DIRS} CACHE INTERNAL "")
    set(BABYLON_MODULE_SOURCE_SEARCH_MASKS_${BABYLON_MODULE} ${BABYLON_MODULE_SOURCE_SEARCH_MASKS} CACHE INTERNAL "")
    set(BABYLON_MODULE_DEPEND_MODULES_${BABYLON_MODULE} ${BABYLON_MODULE_DEPEND_MODULES} CACHE INTERNAL "")

    babylon_log_info("Module (${BABYLON_MODULE}) registered")
endmacro()

# Enable Babylon modules
function(babylon_enable_modules)
    set(options ALL)
    cmake_parse_arguments("ARG" "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    if(ARG_ALL)
        set(modules ${BABYLON_AVAILABLE_MODULES})
    else()
        set(modules ${ARG_UNPARSED_ARGUMENTS})
    endif()

    foreach(module ${modules})
        babylon_enable_module(${module})
    endforeach()
endfunction()

# Enable Babylon module
function(babylon_enable_module BABYLON_MODULE)
    if(NOT ${BABYLON_MODULE} IN_LIST BABYLON_AVAILABLE_MODULES)
        babylon_log_error("Module (${BABYLON_MODULE}) does not exist")
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

    set(BABYLON_MODULE_DEPEND_MODULES ${BABYLON_MODULE_DEPEND_MODULES_${BABYLON_MODULE}})

    babylon_enable_modules(${BABYLON_MODULE_DEPEND_MODULES})

    set(BABYLON_MODULE_ROOT_DIR ${BABYLON_MODULE_ROOT_DIR_${BABYLON_MODULE}})
    set(BABYLON_MODULE_OUTPUT_DIR ${BABYLON_MODULE_OUTPUT_DIR_${BABYLON_MODULE}})
    set(BABYLON_MODULE_OUTPUT_NAME ${BABYLON_MODULE_OUTPUT_NAME_${BABYLON_MODULE}})
    set(BABYLON_MODULE_INCLUDE_DIRS ${BABYLON_MODULE_INCLUDE_DIRS_${BABYLON_MODULE}})
    set(BABYLON_MODULE_SOURCE_SEARCH_MASKS ${BABYLON_MODULE_SOURCE_SEARCH_MASKS_${BABYLON_MODULE}})

    include(${BABYLON_MODULE_CFG_${BABYLON_MODULE}})

    babylon_log_info("Module (${BABYLON_MODULE}) enabled")
endfunction()
