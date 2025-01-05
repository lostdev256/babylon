################################################################################
# Babylon units tools
################################################################################
cmake_minimum_required(VERSION 3.31.0 FATAL_ERROR)

# Get Babylon unit property
function(babylon_get_unit_property UNIT_NAME PROP_NAME PROP_VALUE)
    if(NOT UNIT_NAME OR NOT PROP_NAME)
        babylon_log_error("Not enough arguments")
        unset(${PROP_VALUE} PROP_VALUE)
        return()
    endif()

    set(UNIT_PROP_NAME ${UNIT_NAME}_BABYLON_UNIT_PROP_${PROP_NAME})

    if(NOT DEFINED UNIT_PROP_NAME)
        unset(${PROP_VALUE} PROP_VALUE)
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

    set(UNIT_PROP_NAME ${UNIT_NAME}_BABYLON_UNIT_PROP_${PROP_NAME})

    if(DEFINED UNIT_PROP_NAME)
        if(NOT ARG_OVERRIDE)
            babylon_log_error("The property ${UNIT_PROP_NAME} is already set. A new one will not be set")
            return()
        else()
            babylon_log_error("The property ${UNIT_PROP_NAME} is already set. It will be overwritten")
        endif()
    endif()

    set(${UNIT_PROP_NAME} ${PROP_VALUE} CACHE INTERNAL "")
endfunction()

# Set Babylon unit property
function(babylon_enable_unit UNIT_NAME)
endfunction()
