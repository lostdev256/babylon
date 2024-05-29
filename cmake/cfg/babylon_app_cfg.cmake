################################################################################
# Babylon app default configuration
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

if(NOT BABYLON_APP)
    message(FATAL_ERROR "Babylon app not specified")
endif()

# TODO
# if(APPLE)
#     set(CMAKE_MACOSX_BUNDLE ON)
# endif()

# Sources
babylon_get_sources(src_files SEARCH_MASKS ${BABYLON_APP_SOURCE_SEARCH_MASKS})

foreach(src_path ${src_files})
    cmake_path(RELATIVE_PATH src_path BASE_DIRECTORY ${BABYLON_APP_ROOT_DIR} OUTPUT_VARIABLE src_rel_path)
    cmake_path(GET src_rel_path PARENT_PATH group)
    source_group(${group} FILES ${src_path})
endforeach()

add_executable(${BABYLON_APP} ${src_files})

# Output
set_target_properties(${BABYLON_APP} PROPERTIES
    OUTPUT_DIRECTORY_DEBUG   ${BABYLON_APP_OUTPUT_DIR}
    OUTPUT_DIRECTORY_RELEASE ${BABYLON_APP_OUTPUT_DIR}
    RUNTIME_OUTPUT_DIRECTORY_DEBUG ${BABYLON_APP_OUTPUT_DIR}
    RUNTIME_OUTPUT_DIRECTORY_RELEASE ${BABYLON_APP_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY_DEBUG ${BABYLON_APP_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY_RELEASE ${BABYLON_APP_OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${BABYLON_APP_OUTPUT_DIR}
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${BABYLON_APP_OUTPUT_DIR}
    TARGET_NAME ${BABYLON_APP_OUTPUT_NAME}
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

# Dependencies
target_include_directories(${BABYLON_APP} PUBLIC ${BABYLON_APP_INCLUDE_DIRS})

if (BABYLON_APP_DEPEND_MODULES)
    add_dependencies(${BABYLON_APP} ${BABYLON_APP_DEPEND_MODULES})
    target_link_libraries(${BABYLON_APP} PUBLIC ${BABYLON_APP_DEPEND_MODULES})
endif()

# Configure
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
    set_property(DIRECTORY ${BABYLON_APP_ROOT_DIR} PROPERTY VS_STARTUP_PROJECT ${BABYLON_APP})

    set_target_properties(${BABYLON_APP} PROPERTIES
        VS_GLOBAL_KEYWORD "Win32Proj"
        VS_GLOBAL_ROOTNAMESPACE ${BABYLON_APP}
        INTERPROCEDURAL_OPTIMIZATION_RELEASE "TRUE"
    )

    target_compile_definitions(${BABYLON_APP} PUBLIC
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

    target_compile_options(${BABYLON_APP} PUBLIC
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

    target_link_options(${BABYLON_APP} PUBLIC
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
