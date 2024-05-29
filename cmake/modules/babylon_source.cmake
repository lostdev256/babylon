################################################################################
# Source files utils
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Search for sources by masks
function(babylon_get_sources files)
    set(multi_value_args SEARCH_MASKS)
    cmake_parse_arguments("ARG" "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    if(NOT ARG_SEARCH_MASKS)
        babylon_log_error("Not enough arguments")
        return()
    endif()

    file(GLOB_RECURSE found_files LIST_DIRECTORIES false ${ARG_SEARCH_MASKS})
    set(${files} ${found_files} PARENT_SCOPE)
endfunction()
