################################################################################
# Babylon app tools
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

# Definitions
set(BABYLON_APP_DEFAULT_CFG ${BABYLON_CMAKE_CFG_DIR}/babylon_app_cfg.cmake CACHE INTERNAL "Default Babylon app cfg")

# Configure Babylon app
macro(babylon_configure_app)
    set(single_value_args NAME CFG ROOT_DIR OUTPUT_DIR OUTPUT_NAME)
    set(multi_value_args INCLUDE_DIRS SOURCE_SEARCH_MASKS DEPEND_MODULES)
    cmake_parse_arguments("ARG" "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    if(NOT ARG_NAME)
        set(BABYLON_APP ${PROJECT_NAME})
        babylon_log_info("App uses default name (${BABYLON_APP})")
    else()
        set(BABYLON_APP ${ARG_NAME})
    endif()

    if(NOT ARG_CFG)
        set(BABYLON_APP_CFG ${BABYLON_APP_DEFAULT_CFG})
        babylon_log_info("App (${BABYLON_APP}) uses default configuration (${BABYLON_APP_CFG})")
    else()
        set(BABYLON_APP_CFG ${ARG_CFG})
    endif()

    if(NOT ARG_ROOT_DIR)
        set(BABYLON_APP_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
        babylon_log_info("App (${BABYLON_APP}) uses default root dir (${BABYLON_APP_ROOT_DIR})")
    else()
        set(BABYLON_APP_ROOT_DIR ${ARG_ROOT_DIR})
    endif()

    if(NOT ARG_OUTPUT_DIR)
        set(BABYLON_APP_OUTPUT_DIR ${ARG_ROOT_DIR})
        babylon_log_warn("App (${BABYLON_APP}) uses default output dir (${BABYLON_APP_OUTPUT_DIR})")
    else()
        set(BABYLON_APP_OUTPUT_DIR ${ARG_OUTPUT_DIR})
    endif()

    if(NOT ARG_OUTPUT_NAME)
        set(BABYLON_APP_OUTPUT_NAME ${ARG_NAME})
        babylon_log_warn("Module (${BABYLON_APP}) uses default output name (${BABYLON_APP_OUTPUT_NAME})")
    else()
        set(BABYLON_APP_OUTPUT_NAME ${ARG_OUTPUT_NAME})
    endif()

    unset(BABYLON_APP_INCLUDE_DIRS)
    foreach(dir ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY ${BABYLON_APP_ROOT_DIR}/${dir})
            list(APPEND BABYLON_APP_INCLUDE_DIRS ${BABYLON_APP_ROOT_DIR}/${dir})
        endif()
    endforeach()

    set(BABYLON_APP_SOURCE_SEARCH_MASKS ${ARG_SOURCE_SEARCH_MASKS})
    set(BABYLON_APP_DEPEND_MODULES ${ARG_DEPEND_MODULES})

    babylon_enable_modules(${BABYLON_APP_DEPEND_MODULES})

    include(${BABYLON_APP_CFG})

    babylon_log_info("App (${BABYLON_APP}) configured")
endmacro()
