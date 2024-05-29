################################################################################
# Babylon module default configuration
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Sources
babylon_get_sources(src_files SEARCH_MASKS ${BABYLON_MODULE_SOURCE_SEARCH_MASKS})

foreach(src_path ${src_files})
    cmake_path(RELATIVE_PATH src_path BASE_DIRECTORY ${BABYLON_MODULE_ROOT_DIR} OUTPUT_VARIABLE src_rel_path)
    cmake_path(GET src_rel_path PARENT_PATH group)
    source_group(${group} FILES ${src_path})
endforeach()

add_library(${BABYLON_MODULE} STATIC ${src_files})
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
    TARGET_NAME ${BABYLON_MODULE_OUTPUT_NAME}
)

# Dependencies
target_include_directories(${BABYLON_MODULE} PUBLIC ${BABYLON_MODULE_INCLUDE_DIRS})
target_link_directories(${BABYLON_MODULE} PUBLIC ${BABYLON_MODULE_OUTPUT_DIR})

if (BABYLON_MODULE_DEPEND_MODULES)
    add_dependencies(${BABYLON_MODULE} ${BABYLON_MODULE_DEPEND_MODULES})
    target_link_libraries(${BABYLON_MODULE} PUBLIC ${BABYLON_MODULE_DEPEND_MODULES})
endif()

# Configure
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
