################################################################################
# Babylon app tools
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

# definitions
define_property(GLOBAL PROPERTY BABYLON_APP_DEFAULT_CFG_PATH
    BRIEF_DOCS "Path to default Babylon app cmake configuration file"
)
define_property(GLOBAL PROPERTY BABYLON_APP_ROOT_DIR
    BRIEF_DOCS "Path to app root directory"
)
define_property(GLOBAL PROPERTY BABYLON_APP_NAME
    BRIEF_DOCS "App name"
)
define_property(GLOBAL PROPERTY BABYLON_APP_OUTPUT_DIR
    BRIEF_DOCS "App output binary directory"
)
define_property(GLOBAL PROPERTY BABYLON_APP_OUTPUT_NAME
    BRIEF_DOCS "App output binary name"
)
define_property(GLOBAL PROPERTY BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX
    BRIEF_DOCS "App output binary name debug postfix"
)
define_property(GLOBAL PROPERTY BABYLON_APP_INCLUDE_DIRS
    BRIEF_DOCS "App include directories"
)
define_property(GLOBAL PROPERTY BABYLON_APP_SRC_SEARCH_DIRS
    BRIEF_DOCS "App source directories"
)
define_property(GLOBAL PROPERTY BABYLON_APP_DEPENDS
    BRIEF_DOCS "Babylon modules"
)

set_property(GLOBAL PROPERTY BABYLON_APP_DEFAULT_CFG_PATH "cfg/babylon_app_cfg")

# configure babylon app
macro(babylon_configure_app)
    set(single_value_args CFG APP_NAME OUTPUT_DIR OUTPUT_NAME OUTPUT_NAME_DEBUG_POSTFIX)
    set(multi_value_args INCLUDE_DIRS SRC_SEARCH_DIRS DEPENDS)
    cmake_parse_arguments("ARG" "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    get_property(BABYLON_ROOT_DIR GLOBAL PROPERTY BABYLON_ROOT_DIR)
    if(NOT BABYLON_ROOT_DIR)
        message(FATAL_ERROR "Babylon root directory not found")
    endif()
    list(APPEND CMAKE_MODULE_PATH ${BABYLON_ROOT_DIR}/tools/cmake/modules)

    set(root_dir ${CMAKE_CURRENT_SOURCE_DIR})
    set_property(GLOBAL PROPERTY BABYLON_APP_ROOT_DIR ${root_dir})

    if(NOT ARG_APP_NAME)
        set(app_name ${PROJECT_NAME})
    else()
        set(app_name ${ARG_APP_NAME})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_APP_NAME ${app_name})

    if(NOT ARG_OUTPUT_DIR)
        set(output_dir ${root_dir})
    else()
        set(output_dir ${root_dir}/${ARG_OUTPUT_DIR})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_APP_OUTPUT_DIR ${output_dir})

    if(NOT ARG_OUTPUT_NAME)
        set(output_name ${app_name})
    else()
        set(output_name ${ARG_OUTPUT_NAME})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_APP_OUTPUT_NAME ${output_name})

    if(NOT ARG_OUTPUT_NAME_DEBUG_POSTFIX)
        set(output_debug_postfix "")
    else()
        set(output_debug_postfix ${ARG_OUTPUT_NAME_DEBUG_POSTFIX})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX ${output_debug_postfix})

    unset(include_dirs)
    foreach(dir ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY ${root_dir}/${dir})
            list(APPEND include_dirs ${root_dir}/${dir})
        endif()
    endforeach()
    if(NOT include_dirs)
        set(include_dirs ${root_dir})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_APP_INCLUDE_DIRS ${include_dirs})

    unset(src_search_dirs)
    foreach(dir ${ARG_SRC_SEARCH_DIRS})
        if(IS_DIRECTORY ${root_dir}/${dir})
            list(APPEND src_search_dirs ${root_dir}/${dir})
        endif()
    endforeach()
    if(NOT src_search_dirs)
        set(src_search_dirs ${root_dir})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_APP_SRC_SEARCH_DIRS ${src_search_dirs})

    if(ARG_DEPENDS)
        set_property(GLOBAL PROPERTY BABYLON_APP_DEPENDS ${ARG_DEPENDS})
        babylon_add_modules(${ARG_DEPENDS})
    endif()

    if(NOT ARG_CFG)
        get_property(cfg GLOBAL PROPERTY BABYLON_APP_DEFAULT_CFG_PATH)
    else()
        set(cfg ${ARG_CFG})
    endif()

    include(${cfg})

    babylon_log_info("App (${app_name}) configured")
endmacro()
