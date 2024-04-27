################################################################################
# MSVC Babylon app default configuration
################################################################################
cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

if(NOT BABYLON_APP)
    message(FATAL_ERROR "Babylon app not specified")
endif()

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
