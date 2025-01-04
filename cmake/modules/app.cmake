################################################################################
# Babylon app tools
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

# Definitions
set(BABYLON_APP_DEFAULT_CFG "${BABYLON_CMAKE_CFG_DIR}/app_cfg.cmake" CACHE INTERNAL "Default Babylon app cfg")

# Configure Babylon app
function(babylon_configure_app)
    set(SINGLE_VALUE_ARGS CFG OUTPUT_DIR OUTPUT_NAME)
    set(MULTI_VALUE_ARGS INCLUDE_DIRS SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_MAC)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    set(BABYLON_UNIT_NAME ${PROJECT_NAME})
    if(NOT BABYLON_UNIT_NAME)
        babylon_log_fatal("App name not specified")
        return()
    endif()

    if(NOT ARG_CFG)
        set(BABYLON_UNIT_CFG ${BABYLON_APP_DEFAULT_CFG})
        babylon_log_info("App (${BABYLON_UNIT_NAME}) uses default configuration (${BABYLON_UNIT_CFG})")
    else()
        set(BABYLON_UNIT_CFG ${ARG_CFG})
    endif()

    set(BABYLON_UNIT_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})

    if(NOT ARG_OUTPUT_DIR)
        set(BABYLON_UNIT_OUTPUT_DIR ${BABYLON_UNIT_ROOT_DIR})
        babylon_log_warn("App (${BABYLON_UNIT_NAME}) uses default output dir (${BABYLON_UNIT_OUTPUT_DIR})")
    else()
        set(BABYLON_UNIT_OUTPUT_DIR ${BABYLON_UNIT_ROOT_DIR}/${ARG_OUTPUT_DIR})
    endif()

    if(NOT ARG_OUTPUT_NAME)
        set(BABYLON_UNIT_OUTPUT_NAME ${BABYLON_UNIT_NAME})
    else()
        set(BABYLON_UNIT_OUTPUT_NAME ${ARG_OUTPUT_NAME})
    endif()

    unset(BABYLON_UNIT_INCLUDE_DIRS)
    foreach(DIR ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY ${BABYLON_UNIT_ROOT_DIR}/${DIR})
            list(APPEND BABYLON_UNIT_INCLUDE_DIRS ${BABYLON_UNIT_ROOT_DIR}/${DIR})
        endif()
    endforeach()

    unset(BABYLON_UNIT_SOURCE_SEARCH_MASKS)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS})
        list(APPEND BABYLON_UNIT_SOURCE_SEARCH_MASKS ${BABYLON_UNIT_ROOT_DIR}/${MASK})
    endforeach()
    unset(BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_WIN)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_WIN})
        list(APPEND BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_WIN ${BABYLON_UNIT_ROOT_DIR}/${MASK})
    endforeach()
    unset(BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_MAC)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_MAC})
        list(APPEND BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_MAC ${BABYLON_UNIT_ROOT_DIR}/${MASK})
    endforeach()

    set(BABYLON_UNIT_DEPEND_MODULES ${BABYLON_MODULES_ENABLED})

    set(BABYLON_UNIT_TYPE "App")

    include(${BABYLON_UNIT_CFG})

    babylon_log_info("App (${BABYLON_UNIT_NAME}) configured")
endfunction()
