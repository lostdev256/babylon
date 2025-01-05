################################################################################
# Babylon app tools
################################################################################
cmake_minimum_required(VERSION 3.31.0 FATAL_ERROR)

# Register Babylon app
function(babylon_register_app APP_NAME)
    set(SINGLE_VALUE_ARGS ROOT_DIR OUTPUT_DIR OUTPUT_NAME)
    set(MULTI_VALUE_ARGS INCLUDE_DIRS SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_MAC)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT APP_NAME)
        babylon_log_fatal("App name not specified")
        return()
    endif()

    if(NOT ARG_ROOT_DIR)
        set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    else()
        set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${ARG_ROOT_DIR})
    endif()
    
    if(NOT ARG_OUTPUT_DIR)
        set(OUTPUT_DIR ${ROOT_DIR})
        babylon_log_warn("App (${APP_NAME}) uses default output dir (${OUTPUT_DIR})")
    else()
        set(OUTPUT_DIR ${ROOT_DIR}/${ARG_OUTPUT_DIR})
    endif()

    if(NOT ARG_OUTPUT_NAME)
        set(OUTPUT_NAME ${APP_NAME})
    else()
        set(OUTPUT_NAME ${ARG_OUTPUT_NAME})
    endif()

    unset(INCLUDE_DIRS)
    foreach(DIR ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY ${ROOT_DIR}/${DIR})
            list(APPEND INCLUDE_DIRS ${ROOT_DIR}/${DIR})
        endif()
    endforeach()

    unset(SOURCE_SEARCH_MASKS)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS})
        list(APPEND SOURCE_SEARCH_MASKS ${ROOT_DIR}/${MASK})
    endforeach()
    unset(SOURCE_SEARCH_MASKS_OS_WIN)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_WIN})
        list(APPEND SOURCE_SEARCH_MASKS_OS_WIN ${ROOT_DIR}/${MASK})
    endforeach()
    unset(SOURCE_SEARCH_MASKS_OS_MAC)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_MAC})
        list(APPEND SOURCE_SEARCH_MASKS_OS_MAC ${ROOT_DIR}/${MASK})
    endforeach()

    babylon_unit_set_property(APP_NAME, UNIT_TYPE, "App")
    babylon_unit_set_property(APP_NAME, ROOT_DIR, ${ROOT_DIR})
    babylon_unit_set_property(APP_NAME, OUTPUT_DIR, ${OUTPUT_DIR})
    babylon_unit_set_property(APP_NAME, OUTPUT_NAME, ${OUTPUT_NAME})
    babylon_unit_set_property(APP_NAME, INCLUDE_DIRS, ${INCLUDE_DIRS})
    babylon_unit_set_property(APP_NAME, SOURCE_SEARCH_MASKS, ${SOURCE_SEARCH_MASKS})
    babylon_unit_set_property(APP_NAME, SOURCE_SEARCH_MASKS_OS_WIN, ${SOURCE_SEARCH_MASKS_OS_WIN})
    babylon_unit_set_property(APP_NAME, SOURCE_SEARCH_MASKS_OS_MAC, ${SOURCE_SEARCH_MASKS_OS_MAC})

    set(BABYLON_APP ${APP_NAME} CACHE INTERNAL "Babylon app")

    babylon_log_info("App (${APP_NAME}) registered")
endfunction()

# Enable Babylon app
function(babylon_enable_app)
    if(NOT BABYLON_APP)
        babylon_log_fatal("Babylon app not specified")
        return()
    endif()

    babylon_enable_unit(BABYLON_APP)

    # TODO:

    set(BABYLON_UNIT_DEPEND_UNITS ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_DEPEND_UNITS})

    babylon_enable_modules(${BABYLON_UNIT_DEPEND_UNITS})

    set(BABYLON_UNIT_ROOT_DIR ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_ROOT_DIR})
    set(BABYLON_UNIT_OUTPUT_DIR ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_OUTPUT_DIR})
    set(BABYLON_UNIT_OUTPUT_NAME ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_OUTPUT_NAME})
    set(BABYLON_UNIT_INCLUDE_DIRS ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_INCLUDE_DIRS})
    set(BABYLON_UNIT_SOURCE_SEARCH_MASKS ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_SOURCE_SEARCH_MASKS})
    set(BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_WIN ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_WIN})
    set(BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_MAC ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_MAC})

    set(BABYLON_UNIT_TYPE ${BABYLON_LINKING_MODE})

    include(${${BABYLON_UNIT_NAME}_BABYLON_UNIT_CFG})

    babylon_log_info("Module (${BABYLON_UNIT_NAME}) enabled")
endfunction()

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
        set(BABYLON_UNIT_CFG "${BABYLON_CMAKE_CFG_DIR}/app_cfg.cmake")
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

    set(BABYLON_UNIT_DEPEND_UNITS ${BABYLON_MODULES_ENABLED})

    set(BABYLON_UNIT_TYPE "App")

    include(${BABYLON_UNIT_CFG})

    babylon_log_info("App (${BABYLON_UNIT_NAME}) configured")
endfunction()
