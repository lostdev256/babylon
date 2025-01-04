################################################################################
# Babylon module default configuration
################################################################################
cmake_minimum_required(VERSION 3.31.0 FATAL_ERROR)

if(NOT BABYLON_UNIT_NAME)
    message(FATAL_ERROR "Babylon unit not specified")
endif()

if(BABYLON_UNIT_TYPE STREQUAL "App")
    set(BABYLON_APP_UNIT ON)
endif()

# Project
if(NOT BABYLON_APP_UNIT)
    project(${BABYLON_UNIT_NAME})
endif()

# Sources
babylon_get_sources(SRC_FILES
    SEARCH_MASKS ${BABYLON_UNIT_SOURCE_SEARCH_MASKS}
    SEARCH_MASKS_OS_WIN ${BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_WIN}
    SEARCH_MASKS_OS_MAC ${BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_MAC}
)
source_group(TREE ${BABYLON_UNIT_ROOT_DIR} FILES ${SRC_FILES})
add_library(${BABYLON_UNIT_NAME} STATIC ${SRC_FILES})
set_target_properties(${BABYLON_UNIT_NAME} PROPERTIES FOLDER "Babylon")

# Output
set_target_properties(${BABYLON_UNIT_NAME} PROPERTIES
    OUTPUT_DIRECTORY_DEBUG ${BABYLON_UNIT_OUTPUT_DIR}
    OUTPUT_DIRECTORY_RELEASE ${BABYLON_UNIT_OUTPUT_DIR}
    RUNTIME_OUTPUT_DIRECTORY_DEBUG ${BABYLON_UNIT_OUTPUT_DIR}
    RUNTIME_OUTPUT_DIRECTORY_RELEASE ${BABYLON_UNIT_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY_DEBUG ${BABYLON_UNIT_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY_RELEASE ${BABYLON_UNIT_OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${BABYLON_UNIT_OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${BABYLON_UNIT_OUTPUT_DIR}
    TARGET_NAME ${BABYLON_UNIT_OUTPUT_NAME}
)

# Dependencies
target_include_directories(${BABYLON_UNIT_NAME} PUBLIC ${BABYLON_UNIT_INCLUDE_DIRS})
target_link_directories(${BABYLON_UNIT_NAME} PUBLIC ${BABYLON_UNIT_OUTPUT_DIR})

foreach(DEPEND_MODULE ${BABYLON_UNIT_DEPEND_MODULES})
    babylon_link_depend_module(${BABYLON_UNIT_NAME} ${DEPEND_MODULE})
endforeach()

if(BABYLON_OS_WIN)
    target_link_libraries(${BABYLON_UNIT_NAME} PUBLIC gdi32 gdiplus user32 advapi32 ole32 shell32 comdlg32)
elseif(BABYLON_OS_MAC)
    find_library(Cocoa Cocoa)
    target_link_libraries(${BABYLON_UNIT_NAME} PUBLIC $<$<PLATFORM_ID:Darwin>:${Cocoa}>)
endif()

# Configure
set_target_properties(${BABYLON_UNIT_NAME} PROPERTIES CXX_STANDARD ${CMAKE_CXX_STANDARD})

if(BABYLON_OS_WIN)
    target_compile_definitions(${BABYLON_UNIT_NAME} PUBLIC BABYLON_OS_WIN=${BABYLON_OS_WIN})
elseif(BABYLON_OS_MAC)
    target_compile_definitions(${BABYLON_UNIT_NAME} PUBLIC BABYLON_OS_MAC=${BABYLON_OS_MAC})
endif()

target_compile_options(${BABYLON_UNIT_NAME} PUBLIC
    -Wall
    #-Wextra # TODO: MSVC
    #-pedantic # TODO: MSVC
    #-Werror # TODO: MSVC
    -std=c++${CMAKE_CXX_STANDARD}
)

if(MSVC)
    set_target_properties(${BABYLON_UNIT_NAME} PROPERTIES
        VS_GLOBAL_KEYWORD "Win32Proj"
        VS_GLOBAL_ROOTNAMESPACE ${BABYLON_UNIT_NAME}
        INTERPROCEDURAL_OPTIMIZATION_RELEASE "TRUE"
    )

    target_compile_definitions(${BABYLON_UNIT_NAME} PUBLIC
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

    target_compile_options(${BABYLON_UNIT_NAME} PUBLIC
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
        /std:c++${CMAKE_CXX_STANDARD}
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

    target_link_options(${BABYLON_UNIT_NAME} PUBLIC
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
