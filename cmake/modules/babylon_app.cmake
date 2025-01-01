################################################################################
# Babylon app tools
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

# Definitions
set(BABYLON_APP_DEFAULT_CFG ${BABYLON_CMAKE_CFG_DIR}/babylon_app_cfg.cmake CACHE INTERNAL "Default Babylon app cfg")

# Configure Babylon app
function(babylon_configure_app)
    set(SINGLE_VALUE_ARGS CFG OUTPUT_DIR OUTPUT_NAME)
    set(MULTI_VALUE_ARGS INCLUDE_DIRS SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_MAC)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    set(BABYLON_APP ${PROJECT_NAME})
    if(NOT BABYLON_APP)
        babylon_log_fatal("App name not specified")
        return()
    endif()

    if(NOT ARG_CFG)
        set(BABYLON_APP_CFG ${BABYLON_APP_DEFAULT_CFG})
        babylon_log_info("App (${BABYLON_APP}) uses default configuration (${BABYLON_APP_CFG})")
    else()
        set(BABYLON_APP_CFG ${ARG_CFG})
    endif()

    set(BABYLON_APP_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})

    if(NOT ARG_OUTPUT_DIR)
        set(BABYLON_APP_OUTPUT_DIR ${BABYLON_APP_ROOT_DIR})
        babylon_log_warn("App (${BABYLON_APP}) uses default output dir (${BABYLON_APP_OUTPUT_DIR})")
    else()
        set(BABYLON_APP_OUTPUT_DIR ${BABYLON_APP_ROOT_DIR}/${ARG_OUTPUT_DIR})
    endif()

    if(NOT ARG_OUTPUT_NAME)
        set(BABYLON_APP_OUTPUT_NAME ${BABYLON_APP})
        babylon_log_info("App (${BABYLON_APP}) uses default output name (${BABYLON_APP_OUTPUT_NAME})")
    else()
        set(BABYLON_APP_OUTPUT_NAME ${ARG_OUTPUT_NAME})
    endif()

    unset(BABYLON_APP_INCLUDE_DIRS)
    foreach(DIR ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY ${BABYLON_APP_ROOT_DIR}/${DIR})
            list(APPEND BABYLON_APP_INCLUDE_DIRS ${BABYLON_APP_ROOT_DIR}/${DIR})
        endif()
    endforeach()

    unset(BABYLON_APP_SOURCE_SEARCH_MASKS)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS})
        list(APPEND BABYLON_APP_SOURCE_SEARCH_MASKS ${BABYLON_APP_ROOT_DIR}/${MASK})
    endforeach()
    unset(BABYLON_APP_SOURCE_SEARCH_MASKS_OS_WIN)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_WIN})
        list(APPEND BABYLON_APP_SOURCE_SEARCH_MASKS_OS_WIN ${BABYLON_APP_ROOT_DIR}/${MASK})
    endforeach()
    unset(BABYLON_APP_SOURCE_SEARCH_MASKS_OS_MAC)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_MAC})
        list(APPEND BABYLON_APP_SOURCE_SEARCH_MASKS_OS_MAC ${BABYLON_APP_ROOT_DIR}/${MASK})
    endforeach()

    set(BABYLON_APP_DEPEND_MODULES ${BABYLON_ENABLED_MODULES})

    include(${BABYLON_APP_CFG})

    babylon_log_info("App (${BABYLON_APP}) configured")
endfunction()
