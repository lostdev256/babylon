################################################################################
# Source files utils
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Search for sources by masks
function(babylon_get_sources FILES)
    set(MULTI_VALUE_ARGS SEARCH_MASKS)
    cmake_parse_arguments("ARG" "${OPTIONS}" "${SINGLE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT ARG_SEARCH_MASKS)
        babylon_log_error("Not enough arguments")
        unset(${FILES} PARENT_SCOPE)
        return()
    endif()

    file(GLOB_RECURSE FOUND_FILES LIST_DIRECTORIES false ${ARG_SEARCH_MASKS})
    set(${FILES} ${FOUND_FILES} PARENT_SCOPE)
endfunction()
