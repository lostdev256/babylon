################################################################################
# Babylon modules tools
################################################################################
cmake_minimum_required(VERSION 3.31.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Definitions
set(BABYLON_MODULES_AVAILABLE CACHE INTERNAL "Available Babylon modules")
set(BABYLON_MODULES_ENABLED CACHE INTERNAL "Enabled Babylon modules")

# Search Babylon root dir for modules
macro(babylon_collect_internal_modules)
    file(GLOB SUB_DIRS LIST_DIRECTORIES true RELATIVE "${BABYLON_ROOT_DIR}" "modules/*")
    foreach(DIR ${SUB_DIRS})
        if(IS_DIRECTORY "${BABYLON_ROOT_DIR}/${DIR}" AND EXISTS "${BABYLON_ROOT_DIR}/${DIR}/CMakeLists.txt")
            add_subdirectory(${DIR} ${DIR})
        endif()
    endforeach()
endmacro()

# Register Babylon module
function(babylon_register_module BABYLON_UNIT_NAME)
    set(SINGLE_VALUE_ARGS CFG ROOT_DIR OUTPUT_DIR OUTPUT_NAME)
    set(MULTI_VALUE_ARGS INCLUDE_DIRS SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_MAC DEPEND_MODULES)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT BABYLON_UNIT_NAME)
        babylon_log_error("Module name not specified")
        return()
    endif()

    if(${BABYLON_UNIT_NAME} IN_LIST BABYLON_MODULES_AVAILABLE)
        babylon_log_warn("Module (${BABYLON_UNIT_NAME}) already registered")
        return()
    endif()

    if(NOT BABYLON_MODULES_AVAILABLE)
        set(BABYLON_MODULES_AVAILABLE ${BABYLON_UNIT_NAME} CACHE INTERNAL "Available Babylon modules")
    else()
        set(BABYLON_MODULES_AVAILABLE "${BABYLON_MODULES_AVAILABLE};${BABYLON_UNIT_NAME}" CACHE INTERNAL "Available Babylon modules")
    endif()

    if(NOT ARG_CFG)
        set(BABYLON_UNIT_CFG "${BABYLON_CMAKE_CFG_DIR}/module_cfg.cmake")
        babylon_log_info("Module (${BABYLON_UNIT_NAME}) uses default configuration (${BABYLON_UNIT_CFG})")
    else()
        set(BABYLON_UNIT_CFG ${ARG_CFG})
    endif()

    if(NOT ARG_ROOT_DIR)
        set(BABYLON_UNIT_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    else()
        set(BABYLON_UNIT_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${ARG_ROOT_DIR})
    endif()

    if(NOT ARG_OUTPUT_DIR)
        set(BABYLON_UNIT_OUTPUT_DIR ${BABYLON_UNIT_ROOT_DIR})
        babylon_log_warn("Module (${BABYLON_UNIT_NAME}) uses default output dir (${BABYLON_UNIT_OUTPUT_DIR})")
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

    set(BABYLON_UNIT_DEPEND_MODULES ${ARG_DEPEND_MODULES})

    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_CFG ${BABYLON_UNIT_CFG} CACHE INTERNAL "")
    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_ROOT_DIR ${BABYLON_UNIT_ROOT_DIR} CACHE INTERNAL "")
    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_OUTPUT_DIR ${BABYLON_UNIT_OUTPUT_DIR} CACHE INTERNAL "")
    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_OUTPUT_NAME ${BABYLON_UNIT_OUTPUT_NAME} CACHE INTERNAL "")
    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_INCLUDE_DIRS ${BABYLON_UNIT_INCLUDE_DIRS} CACHE INTERNAL "")
    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_SOURCE_SEARCH_MASKS ${BABYLON_UNIT_SOURCE_SEARCH_MASKS} CACHE INTERNAL "")
    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_WIN ${BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_WIN} CACHE INTERNAL "")
    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_MAC ${BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_MAC} CACHE INTERNAL "")
    set(${BABYLON_UNIT_NAME}_BABYLON_UNIT_DEPEND_MODULES ${BABYLON_UNIT_DEPEND_MODULES} CACHE INTERNAL "")

    babylon_log_info("Module (${BABYLON_UNIT_NAME}) registered")
endfunction()

# Enable Babylon modules
function(babylon_enable_modules)
    set(OPTIONS ALL)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(ARG_ALL)
        set(MODULES ${BABYLON_MODULES_AVAILABLE})
    else()
        set(MODULES ${ARG_UNPARSED_ARGUMENTS})
    endif()

    foreach(MODULE ${MODULES})
        babylon_enable_module(${MODULE})
    endforeach()
endfunction()

# Enable Babylon module
function(babylon_enable_module BABYLON_UNIT_NAME)
    if(NOT ${BABYLON_UNIT_NAME} IN_LIST BABYLON_MODULES_AVAILABLE)
        babylon_log_error("Module (${BABYLON_UNIT_NAME}) doesn't exist")
        return()
    endif()

    if(${BABYLON_UNIT_NAME} IN_LIST BABYLON_MODULES_ENABLED)
        return()
    endif()

    if(NOT BABYLON_MODULES_ENABLED)
        set(BABYLON_MODULES_ENABLED ${BABYLON_UNIT_NAME} CACHE INTERNAL "Enabled Babylon modules")
    else()
        set(BABYLON_MODULES_ENABLED "${BABYLON_MODULES_ENABLED};${BABYLON_UNIT_NAME}" CACHE INTERNAL "Enabled Babylon modules")
    endif()

    set(BABYLON_UNIT_DEPEND_MODULES ${${BABYLON_UNIT_NAME}_BABYLON_UNIT_DEPEND_MODULES})

    babylon_enable_modules(${BABYLON_UNIT_DEPEND_MODULES})

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

# Link depend Babylon module
function(babylon_link_depend_module BABYLON_UNIT_NAME DEPEND_MODULE)
    if(NOT BABYLON_UNIT_NAME)
        babylon_log_error("Module not specified")
        return()
    endif()

    if(NOT BABYLON_UNIT_NAME IN_LIST BABYLON_MODULES_AVAILABLE)
        babylon_log_error("Module (${BABYLON_UNIT_NAME}) doesn't exist")
        return()
    endif()

    if(NOT BABYLON_UNIT_NAME IN_LIST BABYLON_MODULES_ENABLED)
        babylon_log_error("Module (${BABYLON_UNIT_NAME}) doesn't enabled")
        return()
    endif()

    if(NOT DEPEND_MODULE)
        babylon_log_error("Depend module not specified")
        return()
    endif()

    if(NOT DEPEND_MODULE IN_LIST BABYLON_MODULES_AVAILABLE)
        babylon_log_error("Depend module (${DEPEND_MODULE}) doesn't exist")
        return()
    endif()

    if(NOT DEPEND_MODULE IN_LIST BABYLON_MODULES_ENABLED)
        babylon_log_error("Depend module (${DEPEND_MODULE}) doesn't enabled")
        return()
    endif()

    foreach(DIR ${${DEPEND_MODULE}_BABYLON_UNIT_INCLUDE_DIRS})
        target_include_directories(${BABYLON_UNIT_NAME} PRIVATE ${DIR})
    endforeach()

    target_link_libraries(${BABYLON_UNIT_NAME} PUBLIC ${${DEPEND_MODULE}_BABYLON_UNIT_OUTPUT_NAME})
    add_dependencies(${BABYLON_UNIT_NAME} ${DEPEND_MODULE})
endfunction()
