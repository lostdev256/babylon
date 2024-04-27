################################################################################
# Babylon module default configuration
################################################################################
cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root project not found")
endif()

if(NOT BABYLON_MODULE)
    message(FATAL_ERROR "Babylon module not registered")
endif()

# build types
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()
set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" CACHE STRING "" FORCE)

# use solution folders feature
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER __CMAKE__)

# module properties
get_property(root_dir GLOBAL PROPERTY BABYLON_MODULE_ROOT_DIR_${BABYLON_MODULE})
get_property(include_dirs GLOBAL PROPERTY BABYLON_MODULE_INCLUDE_DIRS_${BABYLON_MODULE})
get_property(src_search_dirs GLOBAL PROPERTY BABYLON_MODULE_SRC_SEARCH_DIRS_${BABYLON_MODULE})
get_property(output_dir GLOBAL PROPERTY BABYLON_MODULE_OUTPUT_DIR_${BABYLON_MODULE})
get_property(output_name GLOBAL PROPERTY BABYLON_MODULE_OUTPUT_NAME_${BABYLON_MODULE})
get_property(output_debug_postfix GLOBAL PROPERTY BABYLON_MODULE_OUTPUT_NAME_DEBUG_POSTFIX_${BABYLON_MODULE})

# sources
babylon_get_sources(src_files BASE_DIR ${root_dir} SEARCH_DIRS ${src_search_dirs})

foreach(src_path ${src_files})
    cmake_path(RELATIVE_PATH src_path BASE_DIRECTORY ${root_dir} OUTPUT_VARIABLE src_rel_path)
    cmake_path(GET src_rel_path PARENT_PATH group)
    source_group(${group} FILES ${src_path})
endforeach()

add_library(${BABYLON_MODULE} STATIC ${src_files})
set_target_properties(${BABYLON_MODULE} PROPERTIES FOLDER "Babylon")

# output
set_target_properties(${BABYLON_MODULE} PROPERTIES TARGET_NAME ${output_name})
if(output_debug_postfix)
    set_target_properties(${BABYLON_MODULE} PROPERTIES DEBUG_POSTFIX ${output_debug_postfix})
endif()
set_target_properties(${BABYLON_MODULE} PROPERTIES
    OUTPUT_DIRECTORY_DEBUG   ${output_dir}
    OUTPUT_DIRECTORY_RELEASE ${output_dir}
    RUNTIME_OUTPUT_DIRECTORY_DEBUG ${output_dir}
    RUNTIME_OUTPUT_DIRECTORY_RELEASE ${output_dir}
    LIBRARY_OUTPUT_DIRECTORY_DEBUG ${output_dir}
    LIBRARY_OUTPUT_DIRECTORY_RELEASE ${output_dir}
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${output_dir}
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${output_dir}
)

# dependencies
target_include_directories(${BABYLON_MODULE} PUBLIC ${include_dirs})
target_link_directories(${BABYLON_MODULE} PUBLIC ${output_dir})

if (BABYLON_MODULE_DEPENDS)
    add_dependencies(${BABYLON_MODULE} ${BABYLON_MODULE_DEPENDS})
    target_link_libraries(${BABYLON_MODULE} PUBLIC ${BABYLON_MODULE_DEPENDS})
endif()

# configure
set_target_properties(${BABYLON_MODULE} PROPERTIES
    C_STANDARD 17
    CXX_STANDARD 20
)

target_compile_options(${BABYLON_MODULE} PUBLIC
    -Wall
    #-Wextra # TODO: MSVC
    #-pedantic # TODO: MSVC
    #-Werror # TODO: MSVC
)

if(MSVC)
    include(cfg/msvc/babylon_module_cfg)
endif()
