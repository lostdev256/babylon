################################################################################
# Source files utils
################################################################################
cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

function(babylon_get_sources files)
    set(single_value_args BASE_DIR)
    set(multi_value_args SEARCH_DIRS)
    cmake_parse_arguments("ARG" "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    if(NOT ARG_BASE_DIR OR NOT ARG_SEARCH_DIRS)
        babylon_log_error("Not enough arguments")
        return()
    endif()

    unset(search_dirs)
    foreach(search_dir ${ARG_SEARCH_DIRS})
        list(APPEND search_dirs "${search_dir}/*.h")
        list(APPEND search_dirs "${search_dir}/*.cpp")
    endforeach()

    file(GLOB_RECURSE found_files LIST_DIRECTORIES false ${search_dirs})
    set(${files} ${found_files} PARENT_SCOPE)
endfunction()
