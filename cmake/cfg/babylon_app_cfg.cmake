################################################################################
# Babylon app default configuration
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

# app properties
get_property(BABYLON_APP_ROOT_DIR GLOBAL PROPERTY BABYLON_APP_ROOT_DIR)
get_property(BABYLON_APP GLOBAL PROPERTY BABYLON_APP_NAME)
get_property(BABYLON_APP_OUTPUT_DIR GLOBAL PROPERTY BABYLON_APP_OUTPUT_DIR)
get_property(BABYLON_APP_OUTPUT_NAME GLOBAL PROPERTY BABYLON_APP_OUTPUT_NAME)
get_property(BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX GLOBAL PROPERTY BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX)
get_property(BABYLON_APP_INCLUDE_DIRS GLOBAL PROPERTY BABYLON_APP_INCLUDE_DIRS)
get_property(BABYLON_APP_SRC_SEARCH_DIRS GLOBAL PROPERTY BABYLON_APP_SRC_SEARCH_DIRS)
get_property(BABYLON_APP_DEPENDS GLOBAL PROPERTY BABYLON_APP_DEPENDS)

if(NOT BABYLON_APP)
    message(FATAL_ERROR "Babylon app not specified")
endif()

# TODO
# if(APPLE)
#     set(CMAKE_MACOSX_BUNDLE ON)
# endif()

# build types
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()
set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" CACHE STRING "" FORCE)

# use solution folders feature
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER __CMAKE__)

# sources
babylon_get_sources(src_files BASE_DIR ${BABYLON_APP_ROOT_DIR} SEARCH_DIRS ${BABYLON_APP_SRC_SEARCH_DIRS})

foreach(src_path ${src_files})
    cmake_path(RELATIVE_PATH src_path BASE_DIRECTORY ${BABYLON_APP_ROOT_DIR} OUTPUT_VARIABLE src_rel_path)
    cmake_path(GET src_rel_path PARENT_PATH group)
    source_group(${group} FILES ${src_path})
endforeach()

add_executable(${BABYLON_APP} ${src_files})

# output
set_target_properties(${BABYLON_APP} PROPERTIES TARGET_NAME ${BABYLON_APP_OUTPUT_NAME})
if(BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX)
    set_target_properties(${BABYLON_APP} PROPERTIES DEBUG_POSTFIX ${BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX})
endif()
set_target_properties(${BABYLON_APP} PROPERTIES
    OUTPUT_DIRECTORY_DEBUG   ${BABYLON_APP_OUTPUT_DIR}
    OUTPUT_DIRECTORY_RELEASE ${BABYLON_APP_OUTPUT_DIR}
    RUNTIME_OUTPUT_DIRECTORY_DEBUG ${BABYLON_APP_OUTPUT_DIR}
    RUNTIME_OUTPUT_DIRECTORY_RELEASE ${BABYLON_APP_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY_DEBUG ${BABYLON_APP_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY_RELEASE ${BABYLON_APP_OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${BABYLON_APP_OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${BABYLON_APP_OUTPUT_DIR}
)

# TODO
# if(APPLE)
#     if(BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX AND CMAKE_BUILD_TYPE STREQUAL "Debug")
#         set(output_name "${BABYLON_APP_OUTPUT_NAME}${BABYLON_APP_OUTPUT_NAME_DEBUG_POSTFIX}.app")
#     else()
#         set(output_name ${BABYLON_APP_OUTPUT_NAME})
#     endif()
#     set_target_properties(${BABYLON_APP} PROPERTIES MACOSX_BUNDLE_BUNDLE_NAME ${output_name})
#     set_property(GLOBAL PROPERTY MACOSX_BUNDLE_BUNDLE_NAME ${output_name})
#     set_property(DIRECTORY ${BABYLON_APP_ROOT_DIR} PROPERTY MACOSX_BUNDLE_BUNDLE_NAME ${output_name})
#     babylon_log_info("output_name: ${output_name}")
# endif()

# dependencies
target_include_directories(${BABYLON_APP} PUBLIC ${BABYLON_APP_INCLUDE_DIRS})

if (BABYLON_APP_DEPENDS)
    add_dependencies(${BABYLON_APP} ${BABYLON_APP_DEPENDS})
    target_link_libraries(${BABYLON_APP} PUBLIC ${BABYLON_APP_DEPENDS})
endif()

# configure
set_target_properties(${BABYLON_APP} PROPERTIES
    C_STANDARD 17
    CXX_STANDARD 20
)

target_compile_options(${BABYLON_APP} PUBLIC
    -Wall
    #-Wextra # TODO: MSVC
    #-pedantic # TODO: MSVC
    #-Werror # TODO: MSVC
)

if(MSVC)
    include(cfg/msvc/babylon_app_cfg)
endif()
