################################################################################
# Babylon modules tools
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# definitions
define_property(GLOBAL PROPERTY BABYLON_MODULE_LIST
    BRIEF_DOCS "List of registered Babylon modules"
)
define_property(GLOBAL PROPERTY BABYLON_ADDED_MODULE_LIST
    BRIEF_DOCS "List of added Babylon modules"
)
define_property(GLOBAL PROPERTY BABYLON_MODULE_DEFAULT_CFG_PATH
    BRIEF_DOCS "Path to default Babylon module cmake configuration file"
)

set_property(GLOBAL PROPERTY BABYLON_MODULE_LIST)
set_property(GLOBAL PROPERTY BABYLON_ADDED_MODULE_LIST)
set_property(GLOBAL PROPERTY BABYLON_MODULE_DEFAULT_CFG_PATH "cfg/babylon_module_cfg")

# search babylon root dir for modules
macro(babylon_collect_modules)
    file(GLOB sub_dirs LIST_DIRECTORIES true RELATIVE ${BABYLON_ROOT_DIR} modules/*)
    foreach(dir ${sub_dirs})
        if(IS_DIRECTORY ${BABYLON_ROOT_DIR}/${dir} AND EXISTS ${BABYLON_ROOT_DIR}/${dir}/CMakeLists.txt)
            add_subdirectory(${dir} ${dir})
        endif()
    endforeach()
endmacro()

# register babylon module
macro(babylon_register_module)
    set(single_value_args CFG OUTPUT_DIR OUTPUT_NAME OUTPUT_NAME_DEBUG_POSTFIX)
    set(multi_value_args INCLUDE_DIRS SRC_SEARCH_DIRS DEPENDS)
    cmake_parse_arguments("ARG" "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    get_property(modules GLOBAL PROPERTY BABYLON_MODULE_LIST)
    if(${PROJECT_NAME} IN_LIST modules)
        babylon_log_error("Module (${module}) already exist")
        return()
    endif()
    list(APPEND modules ${PROJECT_NAME})
    set_property(GLOBAL PROPERTY BABYLON_MODULE_LIST ${modules})

    set(root_dir ${CMAKE_CURRENT_SOURCE_DIR})
    set_property(GLOBAL PROPERTY BABYLON_MODULE_ROOT_DIR_${PROJECT_NAME} ${root_dir})

    unset(include_dirs)
    foreach(dir ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY ${root_dir}/${dir})
            list(APPEND include_dirs ${root_dir}/${dir})
        endif()
    endforeach()
    if(NOT include_dirs)
        set(include_dirs ${root_dir})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_MODULE_INCLUDE_DIRS_${PROJECT_NAME} ${include_dirs})

    unset(src_search_dirs)
    foreach(dir ${ARG_SRC_SEARCH_DIRS})
        if(IS_DIRECTORY ${root_dir}/${dir})
            list(APPEND src_search_dirs ${root_dir}/${dir})
        endif()
    endforeach()
    if(NOT src_search_dirs)
        set(src_search_dirs ${root_dir})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_MODULE_SRC_SEARCH_DIRS_${PROJECT_NAME} ${src_search_dirs})

    if(NOT ARG_OUTPUT_DIR)
        set(output_dir ${root_dir})
    else()
        set(output_dir ${root_dir}/${ARG_OUTPUT_DIR})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_MODULE_OUTPUT_DIR_${PROJECT_NAME} ${output_dir})

    if(NOT ARG_OUTPUT_NAME)
        set(output_name ${PROJECT_NAME})
    else()
        set(output_name ${ARG_OUTPUT_NAME})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_MODULE_OUTPUT_NAME_${PROJECT_NAME} ${output_name})

    if(NOT ARG_OUTPUT_NAME_DEBUG_POSTFIX)
        set(output_debug_postfix "")
    else()
        set(output_debug_postfix ${ARG_OUTPUT_NAME_DEBUG_POSTFIX})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_MODULE_OUTPUT_NAME_DEBUG_POSTFIX_${PROJECT_NAME} ${output_debug_postfix})

    if(ARG_DEPENDS)
        set_property(GLOBAL PROPERTY BABYLON_MODULE_DEPENDS_${PROJECT_NAME} ${ARG_DEPENDS})
    endif()

    if(NOT ARG_CFG)
        get_property(cfg GLOBAL PROPERTY BABYLON_MODULE_DEFAULT_CFG_PATH)
    else()
        set(cfg ${ARG_CFG})
    endif()
    set_property(GLOBAL PROPERTY BABYLON_MODULE_CFG_PATH_${PROJECT_NAME} ${cfg})

    babylon_log_info("Module (${PROJECT_NAME}) registered")
endmacro()

# add babylon modules to project
function(babylon_add_modules)
    set(options ALL)
    cmake_parse_arguments("ARG" "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    if(${ARG_ALL})
        get_property(modules GLOBAL PROPERTY BABYLON_MODULE_LIST)
    else()
        set(modules ${ARG_UNPARSED_ARGUMENTS})
    endif()

    foreach(module ${modules})
        babylon_add_module(${module})
    endforeach()
endfunction()

# add babylon module to project
function(babylon_add_module BABYLON_MODULE)
    get_property(modules GLOBAL PROPERTY BABYLON_MODULE_LIST)
    if(NOT ${BABYLON_MODULE} IN_LIST modules)
        babylon_log_error("Module (${BABYLON_MODULE}) does not exist")
        return()
    endif()

    get_property(added_modules GLOBAL PROPERTY BABYLON_ADDED_MODULE_LIST)
    if(${BABYLON_MODULE} IN_LIST added_modules)
        return()
    endif()
    list(APPEND added_modules ${BABYLON_MODULE})
    set_property(GLOBAL PROPERTY BABYLON_ADDED_MODULE_LIST ${added_modules})

    get_property(BABYLON_MODULE_DEPENDS GLOBAL PROPERTY BABYLON_MODULE_DEPENDS_${BABYLON_MODULE})
    if(BABYLON_MODULE_DEPENDS)
        babylon_add_modules(${BABYLON_MODULE_DEPENDS})
    endif()

    get_property(cfg GLOBAL PROPERTY BABYLON_MODULE_CFG_PATH_${BABYLON_MODULE})
    include(${cfg})

    babylon_log_info("Module (${BABYLON_MODULE}) added")
endfunction()
