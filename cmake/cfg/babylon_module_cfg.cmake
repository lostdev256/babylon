################################################################################
# Babylon module default configuration
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Project
project(${BABYLON_MODULE})

# Sources
babylon_get_sources(SRC_FILES SEARCH_MASKS ${BABYLON_MODULE_SOURCE_SEARCH_MASKS})
source_group(TREE ${BABYLON_MODULE_ROOT_DIR} FILES ${SRC_FILES})
add_library(${BABYLON_MODULE} STATIC ${SRC_FILES})
set_target_properties(${BABYLON_MODULE} PROPERTIES FOLDER "Babylon")

# Output
set_target_properties(${BABYLON_MODULE} PROPERTIES
    OUTPUT_DIRECTORY_DEBUG ${BABYLON_MODULE_OUTPUT_DIR}
    OUTPUT_DIRECTORY_RELEASE ${BABYLON_MODULE_OUTPUT_DIR}
    RUNTIME_OUTPUT_DIRECTORY_DEBUG ${BABYLON_MODULE_OUTPUT_DIR}
    RUNTIME_OUTPUT_DIRECTORY_RELEASE ${BABYLON_MODULE_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY_DEBUG ${BABYLON_MODULE_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY_RELEASE ${BABYLON_MODULE_OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${BABYLON_MODULE_OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${BABYLON_MODULE_OUTPUT_DIR}
    TARGET_NAME ${BABYLON_MODULE}
)

# Dependencies
target_include_directories(${BABYLON_MODULE} PUBLIC ${BABYLON_MODULE_INCLUDE_DIRS})
target_link_directories(${BABYLON_MODULE} PUBLIC ${BABYLON_MODULE_OUTPUT_DIR})

foreach(DEPEND_MODULE ${BABYLON_MODULE_DEPEND_MODULES})
    babylon_link_depend_module(${BABYLON_MODULE} ${DEPEND_MODULE})
endforeach()

# Configure
set_target_properties(${BABYLON_MODULE} PROPERTIES CXX_STANDARD ${CMAKE_CXX_STANDARD})

target_compile_options(${BABYLON_MODULE} PUBLIC
    -Wall
    #-Wextra # TODO: MSVC
    #-pedantic # TODO: MSVC
    #-Werror # TODO: MSVC
    -std=c++${CMAKE_CXX_STANDARD}
)

if(MSVC)
    set_target_properties(${BABYLON_MODULE} PROPERTIES
        VS_GLOBAL_KEYWORD "Win32Proj"
        VS_GLOBAL_ROOTNAMESPACE ${BABYLON_MODULE}
        INTERPROCEDURAL_OPTIMIZATION_RELEASE "TRUE"
    )

    target_compile_definitions(${BABYLON_MODULE} PUBLIC
        "$<$<CONFIG:Debug>:"
        "_DEBUG"
        ">"
        "$<$<CONFIG:Release>:"
        "NDEBUG"
        ">"
        "_LIB;"
        "UNICODE;"
        "_UNICODE"
    )

    target_compile_options(${BABYLON_MODULE} PUBLIC
        /GS
        /W4
        #/Wall
        #/WX- # TODO
        /Zc:wchar_t
        /Gm-
        /fp:precise
        /WX-
        /Zc:forScope
        /std:c17
        /std:c++20
        /Gz
        /EHsc
        /nologo
        /permissive-
        /sdl
        /Y-

        $<$<CONFIG:Debug>:
        /Zi;
        /Od;
        /Ob0;
        /RTC1;
        /MDd
        >
        $<$<CONFIG:Release>:
        /Zc:inline
        /GL;
        /O2;
        /Ob2;
        /MD;
        /Oi;
        /Gy
        >
    )

    target_link_options(${BABYLON_MODULE} PUBLIC
        /SUBSYSTEM:CONSOLE
        /DEBUG;

        $<$<CONFIG:Debug>:
        /INCREMENTAL
        >
        $<$<CONFIG:Release>:
        /OPT:REF;
        /OPT:ICF;
        /INCREMENTAL:NO
        >
    )
endif()
