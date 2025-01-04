################################################################################
# Babylon app default configuration
################################################################################
cmake_minimum_required(VERSION 3.31.0 FATAL_ERROR)

if(NOT BABYLON_UNIT_NAME)
    message(FATAL_ERROR "Babylon app not specified")
endif()

# Sources
babylon_get_sources(SRC_FILES
    SEARCH_MASKS ${BABYLON_UNIT_SOURCE_SEARCH_MASKS}
    SEARCH_MASKS_OS_WIN ${BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_WIN}
    SEARCH_MASKS_OS_MAC ${BABYLON_UNIT_SOURCE_SEARCH_MASKS_OS_MAC}
)
source_group(TREE ${BABYLON_UNIT_ROOT_DIR} FILES ${SRC_FILES})
add_executable(${BABYLON_UNIT_NAME} ${SRC_FILES})

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

if(BABYLON_OS_MAC)
    set_target_properties(${BABYLON_UNIT_NAME} PROPERTIES
        MACOSX_BUNDLE "ON"
#        MACOSX_BUNDLE_INFO_PLIST ${BABYLON_CMAKE_PLATFORM_CFG_DIR}/Info.plist.in
        MACOSX_BUNDLE_NAME ${BABYLON_UNIT_NAME}
#        MACOSX_BUNDLE_VERSION ${PROJECT_VERSION}
#        MACOSX_BUNDLE_COPYRIGHT ""
#        MACOSX_BUNDLE_GUI_IDENTIFIER "org.${BABYLON_UNIT_NAME}.gui"
#        MACOSX_BUNDLE_ICON_FILE "Icon.icns"
#        MACOSX_BUNDLE_INFO_STRING ""
#        MACOSX_BUNDLE_LONG_VERSION_STRING ""
#        MACOSX_BUNDLE_SHORT_VERSION_STRING ""
    )
endif()

# TODO
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

# Dependencies
target_include_directories(${BABYLON_UNIT_NAME} PUBLIC ${BABYLON_UNIT_INCLUDE_DIRS})

if (BABYLON_UNIT_DEPEND_MODULES)
    foreach(DEPEND_MODULE ${BABYLON_UNIT_DEPEND_MODULES})
        target_link_libraries(${BABYLON_UNIT_NAME} PUBLIC ${${DEPEND_MODULE}_BABYLON_UNIT_OUTPUT_NAME})
    endforeach()
    add_dependencies(${BABYLON_UNIT_NAME} ${BABYLON_UNIT_DEPEND_MODULES})
endif()

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
    set_property(DIRECTORY ${BABYLON_UNIT_ROOT_DIR} PROPERTY VS_STARTUP_PROJECT ${BABYLON_UNIT_NAME})

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
        "_WINDOWS;"
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
