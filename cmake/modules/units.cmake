################################################################################
# Babylon units tools
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Get Babylon unit property
function(babylon_init_units)
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
function(babylon_get_unit_property UNIT_NAME PROP_NAME PROP_VALUE)
    if(NOT UNIT_NAME OR NOT PROP_NAME)
        babylon_log_error("Not enough arguments")
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
function(babylon_set_unit_property UNIT_NAME PROP_NAME PROP_VALUE)
    set(OPTIONS OVERRIDE)
    cmake_parse_arguments("ARG" "${OPTIONS}" "" "" ${ARGN})

    if(NOT UNIT_NAME OR NOT PROP_NAME)
        babylon_log_error("Not enough arguments")
        return()
    endif()

    set(UNIT_PROP_NAME "${UNIT_NAME}_BABYLON_UNIT_PROP_${PROP_NAME}")

    if(DEFINED ${UNIT_PROP_NAME})
        if(NOT ARG_OVERRIDE)
            babylon_log_error("The property ${UNIT_PROP_NAME} is already set. A new one will not be set")
            return()
        else()
            babylon_log_error("The property ${UNIT_PROP_NAME} is already set. It will be overwritten")
        endif()
    endif()

    set(${UNIT_PROP_NAME} "${PROP_VALUE}" CACHE INTERNAL "" FORCE)
endfunction()

# Search Babylon root dir for units and include they
macro(babylon_collect_internal_units)
    file(GLOB SUB_DIRS LIST_DIRECTORIES true RELATIVE "${BABYLON_ROOT_DIR}" "modules/*")
    foreach(DIR ${SUB_DIRS})
        if(IS_DIRECTORY "${BABYLON_ROOT_DIR}/${DIR}" AND EXISTS "${BABYLON_ROOT_DIR}/${DIR}/CMakeLists.txt")
            add_subdirectory(${DIR} ${DIR})
        endif()
    endforeach()
endmacro()

# Register Babylon unit
function(babylon_register_unit UNIT_NAME)
    set(SINGLE_VALUE_ARGS UNIT_TYPE ROOT_DIR OUTPUT_DIR OUTPUT_NAME)
    set(MULTI_VALUE_ARGS INCLUDE_DIRS SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_MAC DEPEND_UNITS)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT UNIT_NAME)
        babylon_log_fatal("UNIT_NAME not specified")
        return()
    endif()

    if(UNIT_NAME IN_LIST BABYLON_UNITS_AVAILABLE)
        babylon_log_warn("Babylon unit (${UNIT_NAME}) already registered")
        return()
    endif()

    # Handle parameters
    if(NOT ARG_UNIT_TYPE)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()
    set(UNIT_TYPE ${ARG_UNIT_TYPE})

    if(NOT ARG_ROOT_DIR)
        set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    else()
        set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${ARG_ROOT_DIR})
    endif()

    if(NOT ARG_OUTPUT_DIR)
        set(OUTPUT_DIR ${ROOT_DIR})
        babylon_log_warn("Babylon unit (${UNIT_NAME}): uses default output dir (${OUTPUT_DIR})")
    else()
        set(OUTPUT_DIR ${ROOT_DIR}/${ARG_OUTPUT_DIR})
    endif()

    if(NOT ARG_OUTPUT_NAME)
        set(OUTPUT_NAME ${UNIT_NAME})
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

    set(DEPEND_UNITS ${ARG_DEPEND_UNITS})

    # Register
    if(UNIT_TYPE STREQUAL "App")
        list(APPEND BABYLON_APP_UNITS ${UNIT_NAME})
    elseif(UNIT_TYPE STREQUAL "Module")
        list(APPEND BABYLON_MODULE_UNITS ${UNIT_NAME})
    else()
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): unknown UNIT_TYPE (${UNIT_TYPE})")
        return()
    endif()

    if(NOT BABYLON_UNITS_AVAILABLE)
        set(BABYLON_UNITS_AVAILABLE ${UNIT_NAME} CACHE INTERNAL "" FORCE)
    else()
        set(BABYLON_UNITS_AVAILABLE "${BABYLON_UNITS_AVAILABLE};${UNIT_NAME}" CACHE INTERNAL "" FORCE)
    endif()

    babylon_set_unit_property(${UNIT_NAME} UNIT_TYPE "${UNIT_TYPE}")
    babylon_set_unit_property(${UNIT_NAME} ROOT_DIR "${ROOT_DIR}")
    babylon_set_unit_property(${UNIT_NAME} OUTPUT_DIR "${OUTPUT_DIR}")
    babylon_set_unit_property(${UNIT_NAME} OUTPUT_NAME "${OUTPUT_NAME}")
    babylon_set_unit_property(${UNIT_NAME} INCLUDE_DIRS "${INCLUDE_DIRS}")
    babylon_set_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS "${SOURCE_SEARCH_MASKS}")
    babylon_set_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS_OS_WIN "${SOURCE_SEARCH_MASKS_OS_WIN}")
    babylon_set_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS_OS_MAC "${SOURCE_SEARCH_MASKS_OS_MAC}")
    babylon_set_unit_property(${UNIT_NAME} DEPEND_UNITS "${DEPEND_UNITS}")

    babylon_log_info("Babylon unit (${UNIT_NAME}) registered")
endfunction()

# Enable Babylon modules
function(babylon_enable_units)
    set(OPTIONS ALL)
    cmake_parse_arguments("ARG" "${OPTIONS}" "" "" ${ARGN})

    if(ARG_ALL)
        set(UNITS ${BABYLON_UNITS_AVAILABLE})
    else()
        set(UNITS ${ARG_UNPARSED_ARGUMENTS})
    endif()

    foreach(UNIT ${UNITS})
        babylon_enable_unit(${UNIT})
    endforeach()
endfunction()

# Enable Babylon unit
function(babylon_enable_unit UNIT_NAME)
    if(NOT UNIT_NAME)
        babylon_log_error("Not enough arguments")
        return()
    endif()

    if(NOT UNIT_NAME IN_LIST BABYLON_UNITS_AVAILABLE)
        babylon_log_error("Babylon unit (${UNIT_NAME}) doesn't registered")
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
    set(DEPEND_UNITS "")
    babylon_get_unit_property(${UNIT_NAME} DEPEND_UNITS DEPEND_UNITS)
    babylon_enable_units(${DEPEND_UNITS})

    # Enable current unit
    if(TARGET ${UNIT_NAME})
        babylon_log_error("Babylon unit ${UNIT_NAME} already exists")
        return()
    endif()

    project(${UNIT_NAME})

    babylon_unit_configure_sources(${UNIT_NAME})
    babylon_unit_configure_output(${UNIT_NAME})
    babylon_unit_configure_dependencies(${UNIT_NAME})
    babylon_unit_configure_build(${UNIT_NAME})

    babylon_log_info("Babylon unit (${UNIT_NAME}) enabled")
endfunction()

# Configure Babylon unit sources
function(babylon_unit_configure_sources UNIT_NAME)
    if(NOT UNIT_NAME)
        babylon_log_fatal("UNIT_NAME not specified")
        return()
    endif()

    # Properties
    set(UNIT_TYPE "")
    babylon_get_unit_property(${UNIT_NAME} UNIT_TYPE UNIT_TYPE)
    if(NOT UNIT_TYPE)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()

    set(ROOT_DIR "")
    babylon_get_unit_property(${UNIT_NAME} ROOT_DIR ROOT_DIR)
    if(NOT UNIT_TYPE)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): ROOT_DIR not specified")
        return()
    endif()

    set(BUILD_MODE "")
    babylon_get_unit_property(${UNIT_NAME} BUILD_MODE BUILD_MODE)
    if(NOT BUILD_MODE)
        set(BUILD_MODE ${BABYLON_MODULES_BUILD_MODE})
    endif()

    set(SOURCE_SEARCH_MASKS "")
    set(SOURCE_SEARCH_MASKS_OS_WIN "")
    set(SOURCE_SEARCH_MASKS_OS_MAC "")
    babylon_get_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS SOURCE_SEARCH_MASKS)
    babylon_get_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS_OS_WIN SOURCE_SEARCH_MASKS_OS_WIN)
    babylon_get_unit_property(${UNIT_NAME} SOURCE_SEARCH_MASKS_OS_MAC SOURCE_SEARCH_MASKS_OS_MAC)

    # Find and filter source files
    set(SRC_FILES "")
    babylon_get_sources(SRC_FILES
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
function(babylon_unit_configure_output UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        babylon_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    set(OUTPUT_DIR "")
    babylon_get_unit_property(${UNIT_NAME} OUTPUT_DIR OUTPUT_DIR)
    if(NOT OUTPUT_DIR)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): OUTPUT_DIR not specified")
        return()
    endif()

    set(OUTPUT_NAME "")
    babylon_get_unit_property(${UNIT_NAME} OUTPUT_NAME OUTPUT_NAME)
    if(NOT OUTPUT_NAME)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): OUTPUT_NAME not specified")
        return()
    endif()

    # Configure
    set_target_properties(${UNIT_NAME} PROPERTIES
        OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DIR}
        OUTPUT_DIRECTORY_RELEASE ${OUTPUT_DIR}
        TARGET_NAME ${OUTPUT_NAME}
    )

    # TODO: разобраться и вынести куда надо
    # if(BABYLON_OS_MAC)
    #     set_target_properties(${BABYLON_UNIT_NAME} PROPERTIES
    #         MACOSX_BUNDLE "ON"
    #         MACOSX_BUNDLE_INFO_PLIST ${BABYLON_CMAKE_PLATFORM_CFG_DIR}/Info.plist.in
    #         MACOSX_BUNDLE_NAME ${BABYLON_UNIT_NAME}
    #         MACOSX_BUNDLE_VERSION ${PROJECT_VERSION}
    #         MACOSX_BUNDLE_COPYRIGHT ""
    #         MACOSX_BUNDLE_GUI_IDENTIFIER "org.${BABYLON_UNIT_NAME}.gui"
    #         MACOSX_BUNDLE_ICON_FILE "Icon.icns"
    #         MACOSX_BUNDLE_INFO_STRING ""
    #         MACOSX_BUNDLE_LONG_VERSION_STRING ""
    #         MACOSX_BUNDLE_SHORT_VERSION_STRING ""
    #     )
    # endif()
    #
    # if(APPLE)
    #     if(BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX AND CMAKE_BUILD_TYPE STREQUAL "Debug")
    #         set(output_name "${BABYLON_UNIT_OUTPUT_NAME}${BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX}.app")
    #     else()
    #         set(output_name ${BABYLON_UNIT_OUTPUT_NAME})
    #     endif()
    #     set_target_properties(${BABYLON_UNIT_NAME} PROPERTIES MACOSX_BUNDLE_BUNDLE_NAME ${output_name})
    #     set_property(GLOBAL PROPERTY MACOSX_BUNDLE_BUNDLE_NAME ${output_name})
    #     set_property(DIRECTORY ${BABYLON_UNIT_ROOT_DIR} PROPERTY MACOSX_BUNDLE_BUNDLE_NAME ${output_name})
    #     babylon_log_info("output_name: ${output_name}")
    # endif()
endfunction()

# Configure Babylon unit dependencies
function(babylon_unit_configure_dependencies UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        babylon_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    set(UNIT_TYPE "")
    babylon_get_unit_property(${UNIT_NAME} UNIT_TYPE UNIT_TYPE)
    if(NOT UNIT_TYPE)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()

    set(OUTPUT_DIR "")
    babylon_get_unit_property(${UNIT_NAME} OUTPUT_DIR OUTPUT_DIR)
    if(NOT OUTPUT_DIR)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): OUTPUT_DIR not specified")
        return()
    endif()

    set(INCLUDE_DIRS "")
    babylon_get_unit_property(${UNIT_NAME} INCLUDE_DIRS INCLUDE_DIRS)

    # Configure
    target_include_directories(${UNIT_NAME} PUBLIC ${INCLUDE_DIRS})

    if(UNIT_TYPE STREQUAL "Module")
        target_link_directories(${UNIT_NAME} INTERFACE ${OUTPUT_DIR})
    endif()

    babylon_unit_link_depend_units(${UNIT_NAME})

    # TODO: разобраться и вынести куда надо
    # if(BABYLON_OS_WIN)
    #     target_link_libraries(${BABYLON_UNIT_NAME} PUBLIC gdi32 gdiplus user32 advapi32 ole32 shell32 comdlg32)
    # elseif(BABYLON_OS_MAC)
    #     find_library(Cocoa Cocoa)
    #     target_link_libraries(${BABYLON_UNIT_NAME} PUBLIC $<$<PLATFORM_ID:Darwin>:${Cocoa}>)
    # endif()
endfunction()

# Link depend Babylon units
function(babylon_unit_link_depend_units UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        babylon_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    set(DEPEND_UNITS "")
    babylon_get_unit_property(${UNIT_NAME} DEPEND_UNITS DEPEND_UNITS)

    # Configure
    foreach(DEPEND_UNIT ${DEPEND_UNITS})
        babylon_unit_link_depend_unit(${UNIT_NAME} ${DEPEND_UNIT})
    endforeach()
endfunction()

# Link depend Babylon module
function(babylon_unit_link_depend_unit UNIT_NAME DEPEND_UNIT)
    if(NOT TARGET ${UNIT_NAME})
        babylon_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    if(NOT UNIT_NAME IN_LIST BABYLON_UNITS_AVAILABLE)
        babylon_log_error("Babylon unit (${UNIT_NAME}) doesn't registered")
        return()
    endif()

    if(NOT UNIT_NAME IN_LIST BABYLON_UNITS_ENABLED)
        babylon_log_error("Babylon unit (${UNIT_NAME}) doesn't enabled")
        return()
    endif()

    if(NOT DEPEND_UNIT)
        babylon_log_error("Babylon unit (${UNIT_NAME}): depend unit not specified")
        return()
    endif()

    if(NOT DEPEND_UNIT IN_LIST BABYLON_UNITS_AVAILABLE)
        babylon_log_error("Babylon unit (${UNIT_NAME}): depend unit (${DEPEND_UNIT}) doesn't registered")
        return()
    endif()

    if(NOT DEPEND_UNIT IN_LIST BABYLON_UNITS_ENABLED)
        babylon_log_error("Babylon unit (${UNIT_NAME}): depend unit (${DEPEND_UNIT}) doesn't enabled")
        return()
    endif()

    # Properties
    set(DEPEND_UNIT_TYPE "")
    babylon_get_unit_property(${DEPEND_UNIT} UNIT_TYPE DEPEND_UNIT_TYPE)
    if(NOT DEPEND_UNIT_TYPE)
        babylon_log_fatal("Babylon unit (${DEPEND_UNIT}): UNIT_TYPE not specified")
        return()
    endif()

    set(DEPEND_OUTPUT_NAME "")
    babylon_get_unit_property(${DEPEND_UNIT} OUTPUT_NAME DEPEND_OUTPUT_NAME)
    if(NOT DEPEND_OUTPUT_NAME)
        babylon_log_fatal("Babylon unit (${DEPEND_UNIT}): OUTPUT_NAME not specified")
        return()
    endif()

    # Configure
    if(DEPEND_UNIT_TYPE STREQUAL "Module")
        target_link_libraries(${UNIT_NAME} PUBLIC ${DEPEND_OUTPUT_NAME})
    endif()

    add_dependencies(${UNIT_NAME} ${DEPEND_UNIT})
endfunction()

# Configure Babylon unit build
function(babylon_unit_configure_build UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        babylon_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    set(COMPILE_DEFINES "")
    babylon_get_unit_property(${UNIT_NAME} COMPILE_DEFINES COMPILE_DEFINES)

    set(COMPILE_OPTIONS "")
    babylon_get_unit_property(${UNIT_NAME} COMPILE_OPTIONS COMPILE_OPTIONS)

    set(LINK_OPTIONS "")
    babylon_get_unit_property(${UNIT_NAME} LINK_OPTIONS LINK_OPTIONS)

    # Configure
    set_target_properties(${UNIT_NAME} PROPERTIES
        CXX_STANDARD ${CMAKE_CXX_STANDARD}
        C_STANDARD ${CMAKE_C_STANDARD}
    )

    target_compile_definitions(${UNIT_NAME} PRIVATE ${COMPILE_DEFINES})

    if(BABYLON_OS_WIN)
        target_compile_definitions(${UNIT_NAME} PRIVATE BABYLON_OS_WIN=${BABYLON_OS_WIN})
    elseif(BABYLON_OS_MAC)
        target_compile_definitions(${UNIT_NAME} PRIVATE BABYLON_OS_MAC=${BABYLON_OS_MAC})
    endif()

    target_compile_options(${UNIT_NAME} PRIVATE ${COMPILE_OPTIONS})
    target_link_options(${UNIT_NAME} PRIVATE ${LINK_OPTIONS})
endfunction()
