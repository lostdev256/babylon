################################################################################
# Babylon source files utils
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BN_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Search for sources by masks
function(bn_get_sources FILES)
    set(MULTI_VALUE_ARGS SEARCH_MASKS SEARCH_MASKS_OS_WIN SEARCH_MASKS_OS_MAC)
    cmake_parse_arguments("ARG" "" "" "${MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT ARG_SEARCH_MASKS)
        bn_log_error("Not enough arguments")
        unset(${FILES} PARENT_SCOPE)
        return()
    endif()

    # Collect all source files by masks
    file(GLOB_RECURSE FOUND_FILES LIST_DIRECTORIES false ${ARG_SEARCH_MASKS})
    file(GLOB_RECURSE FOUND_FILES_OS_WIN LIST_DIRECTORIES false ${ARG_SEARCH_MASKS_OS_WIN})
    file(GLOB_RECURSE FOUND_FILES_OS_MAC LIST_DIRECTORIES false ${ARG_SEARCH_MASKS_OS_MAC})

    unset(RESULT_FILES)

    foreach(FOUND_FILE ${FOUND_FILES})
        if((NOT BN_OS_WIN AND FOUND_FILE IN_LIST FOUND_FILES_OS_WIN) OR
           (NOT BN_OS_MAC AND FOUND_FILE IN_LIST FOUND_FILES_OS_MAC))
            continue()
        endif()
        list(APPEND RESULT_FILES ${FOUND_FILE})
    endforeach()

    if(BN_OS_WIN)
        list(APPEND RESULT_FILES ${FOUND_FILES_OS_WIN})
    elseif(BN_OS_MAC)
        list(APPEND RESULT_FILES ${FOUND_FILES_OS_MAC})
    endif()

    # Remove duplicates
    list(REMOVE_DUPLICATES RESULT_FILES)

    set(${FILES} ${RESULT_FILES} PARENT_SCOPE)
endfunction()
