################################################################################
# Babylon units tools
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Init Babylon unit system
function(bn_init_unit_system)
    get_cmake_property(CACHE_VARIABLES CACHE_VARIABLES)
    foreach(CACHE_VARIABLE ${CACHE_VARIABLES})
        if(CACHE_VARIABLE MATCHES ".+_BABYLON_UNIT_PROP_.+")
            unset(${CACHE_VARIABLE} CACHE)
        endif()
    endforeach()

    set(BABYLON_UNITS_AVAILABLE "" CACHE INTERNAL "" FORCE)
    set(BABYLON_UNITS_ENABLED "" CACHE INTERNAL "" FORCE)

    set(BABYLON_APP_UNITS "" CACHE INTERNAL "" FORCE)
    set(BABYLON_MODULE_UNITS "" CACHE INTERNAL "" FORCE)
endfunction()

# Get Babylon unit property
function(bn_get_unit_property UNIT_NAME PROP_NAME PROP_VALUE)
    if(NOT UNIT_NAME OR NOT PROP_NAME)
        bn_log_error("Not enough arguments")
        unset(${PROP_VALUE} PARENT_SCOPE)
        return()
    endif()

    set(UNIT_PROP_NAME "${UNIT_NAME}_BABYLON_UNIT_PROP_${PROP_NAME}")

    if(NOT DEFINED ${UNIT_PROP_NAME})
        unset(${PROP_VALUE} PARENT_SCOPE)
    else()
        set(${PROP_VALUE} ${${UNIT_PROP_NAME}} PARENT_SCOPE)
    endif()
endfunction()

# Set Babylon unit property
function(bn_set_unit_property UNIT_NAME PROP_NAME PROP_VALUE)
    set(OPTIONS OVERRIDE)
    cmake_parse_arguments("ARG" "${OPTIONS}" "" "" ${ARGN})

    if(NOT UNIT_NAME OR NOT PROP_NAME)
        bn_log_error("Not enough arguments")
        return()
    endif()

    set(UNIT_PROP_NAME "${UNIT_NAME}_BABYLON_UNIT_PROP_${PROP_NAME}")

    if(DEFINED ${UNIT_PROP_NAME})
        if(NOT ARG_OVERRIDE)
            bn_log_warn("The property ${UNIT_PROP_NAME} is already set. A new one will not be set")
            return()
        else()
            bn_log_warn("The property ${UNIT_PROP_NAME} is already set. It will be overwritten")
        endif()
    endif()

    set(${UNIT_PROP_NAME} "${PROP_VALUE}" CACHE INTERNAL "" FORCE)
endfunction()

# Search Babylon root dir for units and include they
macro(bn_collect_internal_units)
    file(GLOB SUB_DIRS LIST_DIRECTORIES true RELATIVE "${BABYLON_ROOT_DIR}" "modules/*")
    foreach(DIR ${SUB_DIRS})
        if(IS_DIRECTORY "${BABYLON_ROOT_DIR}/${DIR}" AND EXISTS "${BABYLON_ROOT_DIR}/${DIR}/CMakeLists.txt")
            add_subdirectory(${DIR} ${DIR})
        endif()
    endforeach()
endmacro()

# Register Babylon unit
function(bn_register_unit UNIT_NAME)
    set(SINGLE_VALUE_ARGS UNIT_TYPE ROOT_DIR BASE_BUILD_CFG BUILD_CFG BUILD_MODE OUTPUT_DIR OUTPUT_NAME PCH)
    set(MULTI_VALUE_ARGS INCLUDE_DIRS SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_MAC DEPEND_UNITS)
    cmake_parse_arguments("ARG" "" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT UNIT_NAME)
        bn_log_fatal("UNIT_NAME not specified")
        return()
    endif()

    if(UNIT_NAME IN_LIST BABYLON_UNITS_AVAILABLE)
        bn_log_warn("Babylon unit (${UNIT_NAME}) already registered")
        return()
    endif()

    # Handle parameters
    if(NOT ARG_UNIT_TYPE)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()
    set(UNIT_TYPE ${ARG_UNIT_TYPE})

    if(NOT ARG_ROOT_DIR)
        set(ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
    else()
        set(ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${ARG_ROOT_DIR}")
    endif()

    if(NOT ARG_BASE_BUILD_CFG)
        set(BASE_BUILD_CFG "${BABYLON_BASE_BUILD_CFG}")
    else()
        set(BASE_BUILD_CFG "${ROOT_DIR}/${ARG_BASE_BUILD_CFG}")
    endif()

    if(NOT ARG_BUILD_CFG)
        set(BUILD_CFG "")
    else()
        set(BUILD_CFG "${ROOT_DIR}/${ARG_BUILD_CFG}")
    endif()

    if(NOT ARG_BUILD_MODE)
        set(BUILD_MODE "${BABYLON_MODULES_BUILD_MODE}")
    else()
        set(BUILD_MODE "${ARG_BUILD_MODE}")
    endif()

    if(NOT ARG_OUTPUT_DIR)
        set(OUTPUT_DIR "${ROOT_DIR}")
        bn_log_warn("Babylon unit (${UNIT_NAME}): uses default output dir (${OUTPUT_DIR})")
    else()
        set(OUTPUT_DIR "${ROOT_DIR}/${ARG_OUTPUT_DIR}")
    endif()

    if(NOT ARG_OUTPUT_NAME)
        set(OUTPUT_NAME ${UNIT_NAME})
    else()
        set(OUTPUT_NAME ${ARG_OUTPUT_NAME})
    endif()

    if(NOT ARG_PCH)
        set(PCH "")
    else()
        set(PCH "${ROOT_DIR}/${ARG_PCH}")
    endif()

    unset(INCLUDE_DIRS)
    foreach(DIR ${ARG_INCLUDE_DIRS})
        if(IS_DIRECTORY "${ROOT_DIR}/${DIR}")
            list(APPEND INCLUDE_DIRS "${ROOT_DIR}/${DIR}")
        endif()
    endforeach()

    unset(SOURCE_SEARCH_MASKS)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS})
        list(APPEND SOURCE_SEARCH_MASKS "${ROOT_DIR}/${MASK}")
    endforeach()

    unset(SOURCE_SEARCH_MASKS_OS_WIN)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_WIN})
        list(APPEND SOURCE_SEARCH_MASKS_OS_WIN "${ROOT_DIR}/${MASK}")
    endforeach()

    unset(SOURCE_SEARCH_MASKS_OS_MAC)
    foreach(MASK ${ARG_SOURCE_SEARCH_MASKS_OS_MAC})
        list(APPEND SOURCE_SEARCH_MASKS_OS_MAC "${ROOT_DIR}/${MASK}")
    endforeach()

    set(DEPEND_UNITS ${ARG_DEPEND_UNITS})

    # Register
    if(UNIT_TYPE STREQUAL "App")
        if(NOT BABYLON_APP_UNITS)
            set(BABYLON_APP_UNITS ${UNIT_NAME} CACHE INTERNAL "" FORCE)
        else()
            set(BABYLON_APP_UNITS "${BABYLON_APP_UNITS};${UNIT_NAME}" CACHE INTERNAL "" FORCE)
        endif()
    elseif(UNIT_TYPE STREQUAL "Module")
        if(NOT BABYLON_MODULE_UNITS)
            set(BABYLON_MODULE_UNITS ${UNIT_NAME} CACHE INTERNAL "" FORCE)
        else()
            set(BABYLON_MODULE_UNITS "${BABYLON_MODULE_UNITS};${UNIT_NAME}" CACHE INTERNAL "" FORCE)
        endif()
    else()
        bn_log_fatal("Babylon unit (${UNIT_NAME}): unknown UNIT_TYPE (${UNIT_TYPE})")
        return()
    endif()

    if(NOT BABYLON_UNITS_AVAILABLE)
        set(BABYLON_UNITS_AVAILABLE ${UNIT_NAME} CACHE INTERNAL "" FORCE)
    else()
        set(BABYLON_UNITS_AVAILABLE "${BABYLON_UNITS_AVAILABLE};${UNIT_NAME}" CACHE INTERNAL "" FORCE)
    endif()

    bn_set_unit_property(${UNIT_NAME} UNIT_TYPE "${UNIT_TYPE}")
    bn_set_unit_property(${UNIT_NAME} ROOT_DIR "${ROOT_DIR}")
    bn_set_unit_property(${UNIT_NAME} BASE_BUILD_CFG "${BASE_BUILD_CFG}")
    bn_set_unit_property(${UNIT_NAME} BUILD_CFG "${BUILD_CFG}")
    bn_set_unit_property(${UNIT_NAME} BUILD_MODE "${BUILD_MODE}")
    bn_set_unit_property(${UNIT_NAME} OUTPUT_DIR "${OUTPUT_DIR}")
    bn_set_unit_property(${UNIT_NAME} OUTPUT_NAME "${OUTPUT_NAME}")
    bn_set_unit_property(${UNIT_NAME} PCH "${PCH}")
    bn_set_unit_property(${UNIT_NAME} INCLUDE_DIRS "${INCLUDE_DIRS}")
    bn_set_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS "${SOURCE_SEARCH_MASKS}")
    bn_set_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS_OS_WIN "${SOURCE_SEARCH_MASKS_OS_WIN}")
    bn_set_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS_OS_MAC "${SOURCE_SEARCH_MASKS_OS_MAC}")
    bn_set_unit_property(${UNIT_NAME} DEPEND_UNITS "${DEPEND_UNITS}")

    bn_log_info("Babylon unit (${UNIT_NAME}) registered")
endfunction()

# Enable Babylon modules
function(bn_enable_units)
    set(OPTIONS ALL)
    cmake_parse_arguments("ARG" "${OPTIONS}" "" "" ${ARGN})

    if(ARG_ALL)
        set(UNITS ${BABYLON_UNITS_AVAILABLE})
    else()
        set(UNITS ${ARG_UNPARSED_ARGUMENTS})
    endif()

    foreach(UNIT ${UNITS})
        bn_enable_unit(${UNIT})
    endforeach()
endfunction()

# Enable Babylon unit
function(bn_enable_unit UNIT_NAME)
    if(NOT UNIT_NAME)
        bn_log_error("Not enough arguments")
        return()
    endif()

    if(NOT UNIT_NAME IN_LIST BABYLON_UNITS_AVAILABLE)
        bn_log_error("Babylon unit (${UNIT_NAME}) doesn't registered")
        return()
    endif()

    if(UNIT_NAME IN_LIST BABYLON_UNITS_ENABLED)
        return()
    endif()

    if(NOT BABYLON_UNITS_ENABLED)
        set(BABYLON_UNITS_ENABLED ${UNIT_NAME} CACHE INTERNAL "" FORCE)
    else()
        set(BABYLON_UNITS_ENABLED "${BABYLON_UNITS_ENABLED};${UNIT_NAME}" CACHE INTERNAL "" FORCE)
    endif()

    # Enable depend units
    bn_get_unit_property(${UNIT_NAME} DEPEND_UNITS DEPEND_UNITS)
    bn_enable_units(${DEPEND_UNITS})

    # Enable current unit
    if(TARGET ${UNIT_NAME})
        bn_log_error("Babylon unit ${UNIT_NAME} already exists")
        return()
    endif()

    project(${UNIT_NAME})

    bn_unit_configure_sources(${UNIT_NAME})
    bn_unit_configure_output(${UNIT_NAME})
    bn_unit_configure_dependencies(${UNIT_NAME})
    bn_unit_configure_build(${UNIT_NAME})

    bn_log_info("Babylon unit (${UNIT_NAME}) enabled")
endfunction()

# Configure Babylon unit sources
function(bn_unit_configure_sources UNIT_NAME)
    if(NOT UNIT_NAME)
        bn_log_fatal("UNIT_NAME not specified")
        return()
    endif()

    # Properties
    bn_get_unit_property(${UNIT_NAME} UNIT_TYPE UNIT_TYPE)
    if(NOT UNIT_TYPE)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()

    bn_get_unit_property(${UNIT_NAME} ROOT_DIR ROOT_DIR)
    if(NOT ROOT_DIR)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): ROOT_DIR not specified")
        return()
    endif()

    bn_get_unit_property(${UNIT_NAME} BUILD_MODE BUILD_MODE)
    if(NOT BUILD_MODE)
        set(BUILD_MODE ${BABYLON_MODULES_BUILD_MODE})
    endif()

    bn_get_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS)
    bn_get_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_WIN)
    bn_get_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS_OS_MAC SOURCE_SEARCH_MASKS_OS_MAC)

    # Find and filter source files
    bn_get_sources(SRC_FILES
        SEARCH_MASKS ${SOURCE_SEARCH_MASKS}
        SEARCH_MASKS_OS_WIN ${SOURCE_SEARCH_MASKS_OS_WIN}
        SEARCH_MASKS_OS_MAC ${SOURCE_SEARCH_MASKS_OS_MAC}
    )

    # Configure
    source_group(TREE ${ROOT_DIR} FILES ${SRC_FILES})

    if(UNIT_TYPE STREQUAL "App")
        add_executable(${UNIT_NAME} ${SRC_FILES})
    elseif(UNIT_TYPE STREQUAL "Module")
        add_library(${UNIT_NAME} ${BUILD_MODE} ${SRC_FILES})
        set_target_properties(${UNIT_NAME} PROPERTIES FOLDER "Babylon")
    endif()
endfunction()

# Configure Babylon unit output
function(bn_unit_configure_output UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        bn_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    bn_get_unit_property(${UNIT_NAME} OUTPUT_DIR OUTPUT_DIR)
    if(NOT OUTPUT_DIR)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): OUTPUT_DIR not specified")
        return()
    endif()

    bn_get_unit_property(${UNIT_NAME} OUTPUT_NAME OUTPUT_NAME)
    if(NOT OUTPUT_NAME)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): OUTPUT_NAME not specified")
        return()
    endif()

    # Configure
    set_target_properties(${UNIT_NAME} PROPERTIES
        TARGET_NAME ${OUTPUT_NAME}
        RUNTIME_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DIR}
        RUNTIME_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_DIR}
        LIBRARY_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DIR}
        LIBRARY_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_DIR}
        ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DIR}
        ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_DIR}
    )
endfunction()

# Configure Babylon unit dependencies
function(bn_unit_configure_dependencies UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        bn_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    bn_get_unit_property(${UNIT_NAME} UNIT_TYPE UNIT_TYPE)
    if(NOT UNIT_TYPE)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()

    bn_get_unit_property(${UNIT_NAME} OUTPUT_DIR OUTPUT_DIR)
    if(NOT OUTPUT_DIR)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): OUTPUT_DIR not specified")
        return()
    endif()

    bn_get_unit_property(${UNIT_NAME} INCLUDE_DIRS INCLUDE_DIRS)

    # Configure
    target_include_directories(${UNIT_NAME} PUBLIC ${INCLUDE_DIRS})

    if(UNIT_TYPE STREQUAL "Module")
        target_link_directories(${UNIT_NAME} INTERFACE ${OUTPUT_DIR})
    endif()

    bn_unit_link_depend_units(${UNIT_NAME})
endfunction()

# Link depend Babylon units
function(bn_unit_link_depend_units UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        bn_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    bn_get_unit_property(${UNIT_NAME} DEPEND_UNITS DEPEND_UNITS)

    # Configure
    foreach(DEPEND_UNIT ${DEPEND_UNITS})
        bn_unit_link_depend_unit(${UNIT_NAME} ${DEPEND_UNIT})
    endforeach()
endfunction()

# Link depend Babylon module
function(bn_unit_link_depend_unit UNIT_NAME DEPEND_UNIT)
    if(NOT TARGET ${UNIT_NAME})
        bn_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    if(NOT UNIT_NAME IN_LIST BABYLON_UNITS_AVAILABLE)
        bn_log_error("Babylon unit (${UNIT_NAME}) doesn't registered")
        return()
    endif()

    if(NOT UNIT_NAME IN_LIST BABYLON_UNITS_ENABLED)
        bn_log_error("Babylon unit (${UNIT_NAME}) doesn't enabled")
        return()
    endif()

    if(NOT DEPEND_UNIT)
        bn_log_error("Babylon unit (${UNIT_NAME}): depend unit not specified")
        return()
    endif()

    if(NOT DEPEND_UNIT IN_LIST BABYLON_UNITS_AVAILABLE)
        bn_log_error("Babylon unit (${UNIT_NAME}): depend unit (${DEPEND_UNIT}) doesn't registered")
        return()
    endif()

    if(NOT DEPEND_UNIT IN_LIST BABYLON_UNITS_ENABLED)
        bn_log_error("Babylon unit (${UNIT_NAME}): depend unit (${DEPEND_UNIT}) doesn't enabled")
        return()
    endif()

    # Properties
    bn_get_unit_property(${DEPEND_UNIT} UNIT_TYPE DEPEND_UNIT_TYPE)
    if(NOT DEPEND_UNIT_TYPE)
        bn_log_fatal("Babylon unit (${DEPEND_UNIT}): UNIT_TYPE not specified")
        return()
    endif()

    bn_get_unit_property(${DEPEND_UNIT} OUTPUT_NAME DEPEND_OUTPUT_NAME)
    if(NOT DEPEND_OUTPUT_NAME)
        bn_log_fatal("Babylon unit (${DEPEND_UNIT}): OUTPUT_NAME not specified")
        return()
    endif()

    # Configure
    if(DEPEND_UNIT_TYPE STREQUAL "Module")
        target_link_libraries(${UNIT_NAME} PUBLIC ${DEPEND_OUTPUT_NAME})
    endif()

    add_dependencies(${UNIT_NAME} ${DEPEND_UNIT})
endfunction()

# Configure Babylon unit build
function(bn_unit_configure_build UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        bn_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Helper
    macro(reset_external_configure_function)
        function(bn_unit_external_configure_build UNIT_NAME)
            bn_log_error("Babylon unit (${UNIT_NAME}): function (bn_unit_external_configure_build) doesn't exists")
        endfunction()
    endmacro()

    # Properties
    bn_get_unit_property(${UNIT_NAME} BASE_BUILD_CFG BASE_BUILD_CFG)
    bn_get_unit_property(${UNIT_NAME} BUILD_CFG BUILD_CFG)

    # Base configure
    if(NOT BASE_BUILD_CFG)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): BASE_BUILD_CFG not specified")
        return()
    endif()

    if(NOT EXISTS "${BASE_BUILD_CFG}")
        bn_log_fatal("Babylon unit (${UNIT_NAME}): BASE_BUILD_CFG (${BASE_BUILD_CFG}) doesn't exists")
        return()
    endif()

    reset_external_configure_function()

    include("${BASE_BUILD_CFG}")
    bn_unit_external_configure_build(${UNIT_NAME})

    reset_external_configure_function()

    # Additional configure
    if(NOT BUILD_CFG)
        return()
    endif()

    if(NOT EXISTS "${BUILD_CFG}")
        bn_log_fatal("Babylon unit (${UNIT_NAME}): BUILD_CFG (${BUILD_CFG}) doesn't exists")
        return()
    endif()

    include("${BUILD_CFG}")
    bn_unit_external_configure_build(${UNIT_NAME})

    reset_external_configure_function()
endfunction()
