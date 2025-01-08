################################################################################
# Babylon base unit configuration (BASE_BUILD_CFG)
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Default base build configuration. Override this if needed in your BASE_BUILD_CFG cfg.cmake file
function(babylon_unit_external_configure_build UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        babylon_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    set(UNIT_TYPE "")
    babylon_get_unit_property(${UNIT_NAME} UNIT_TYPE UNIT_TYPE)
    if(NOT UNIT_TYPE)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()

    set(ROOT_DIR "")
    babylon_get_unit_property(${UNIT_NAME} ROOT_DIR ROOT_DIR)
    if(NOT ROOT_DIR)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): ROOT_DIR not specified")
        return()
    endif()

    set(OUTPUT_NAME "")
    babylon_get_unit_property(${UNIT_NAME} OUTPUT_NAME OUTPUT_NAME)
    if(NOT OUTPUT_NAME)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): OUTPUT_NAME not specified")
        return()
    endif()

    set(PCH "")
    babylon_get_unit_property(${UNIT_NAME} PCH PCH)

    # Configure
    if(MSVC)
        list(LENGTH BABYLON_APP_UNITS APPS_COUNT)
        if(APPS_COUNT GREATER 0)
            list(GET BABYLON_APP_UNITS -1 STARTUP_UNIT)
            if(STARTUP_UNIT STREQUAL ${UNIT_NAME})
                set_property(DIRECTORY ${ROOT_DIR} PROPERTY VS_STARTUP_PROJECT ${UNIT_NAME})
            endif()
        endif()

        set_target_properties(${UNIT_NAME} PROPERTIES
            VS_GLOBAL_KEYWORD "Win32Proj"
            VS_GLOBAL_ROOTNAMESPACE ${UNIT_NAME}
        )
    endif()

    if(BABYLON_OS_MAC AND UNIT_TYPE STREQUAL "App")
        set_target_properties(${UNIT_NAME} PROPERTIES
            MACOSX_BUNDLE "ON"
            MACOSX_BUNDLE_INFO_PLIST "${BABYLON_CMAKE_PLATFORM_MODULES_DIR}/mac/Info.plist.in"
            MACOSX_BUNDLE_NAME "${OUTPUT_NAME}"
            MACOSX_BUNDLE_VERSION "${PROJECT_VERSION}"
            MACOSX_BUNDLE_COPYRIGHT ""
            MACOSX_BUNDLE_GUI_IDENTIFIER "org.${OUTPUT_NAME}.gui"
            MACOSX_BUNDLE_ICON_FILE "Icon.icns"
            MACOSX_BUNDLE_INFO_STRING ""
            MACOSX_BUNDLE_LONG_VERSION_STRING ""
            MACOSX_BUNDLE_SHORT_VERSION_STRING ""
        )
    endif()

    set_target_properties(${UNIT_NAME} PROPERTIES
        C_STANDARD ${CMAKE_C_STANDARD}
        CXX_STANDARD ${CMAKE_CXX_STANDARD}
    )

    if(BABYLON_OS_WIN)
        target_compile_definitions(${UNIT_NAME} PRIVATE BABYLON_OS_WIN)
    elseif(BABYLON_OS_MAC)
        target_compile_definitions(${UNIT_NAME} PRIVATE BABYLON_OS_MAC)
    endif()

    if(MSVC)
        target_compile_definitions(${UNIT_NAME} PRIVATE
            WIN32
            _WINDOWS
            $<$<CONFIG:Debug>:_DEBUG>
            $<$<CONFIG:Release>:NDEBUG>
            $<$<STREQUAL:${UNIT_TYPE},Module>:_LIB>
        )
    endif()

    if(PCH)
        target_precompile_headers(${UNIT_NAME} PRIVATE "${PCH}")
    endif()

    target_compile_options(${UNIT_NAME} PRIVATE
        # Опции стандарта
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-pedantic>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-pedantic>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/permissive- /Zc:forScope /Zc:wchar_t /Zc:inline /Zc:__cplusplus /Zc:preprocessor>

        # Обработка исключений
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-fexceptions>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-fexceptions>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/EHsc>

        # Соглашения о вызовах (stdcall для WinAPI)
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/Gz>

        # Операции с плавающей точкой
        # $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-ffloat-store>
        # $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-ffloat-store>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/fp:precise>

        # CRT
        $<$<CONFIG:Debug>:$<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/MDd>>
        $<$<CONFIG:Release>:$<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/MD>>

        # Предупреждения
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-Wall -Wextra $<$<BOOL:${BABYLON_CL_WARNING_AS_ERROR}>:-Werror>>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-Wall -Wextra $<$<BOOL:${BABYLON_CL_WARNING_AS_ERROR}>:-Werror>>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/Wall $<$<BOOL:${BABYLON_CL_WARNING_AS_ERROR}>:/WX>>
        
        # Защита
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-fstack-protector-strong>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-fstack-protector-strong>
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/GS /sdl>

        $<$<BOOL:${BABYLON_CL_ASAN}>:
            $<$<CONFIG:Debug>:
                $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-fsanitize=address -fsanitize=undefined>
                $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-fsanitize=address -fsanitize=undefined>
                $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/RTC1>
            >
        >

        # Оптимизация сборки
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/Gm->

        # Оптимизация
        $<$<CONFIG:Debug>:
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-O0>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-O0>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/Od /Ob0>
        >
        $<$<CONFIG:Release>:
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-O2 -finline-functions -flto -ffunction-sections>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-O2 -finline-functions -flto -ffunction-sections>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/O2 /Ob2 /Oi /GL /Gy>
        >

        # Отладка
        $<$<CONFIG:Debug>:
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-g3>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-ggdb3>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/Zi>
        >
    )

    target_link_options(${UNIT_NAME} PRIVATE
        # System
        $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/SUBSYSTEM:CONSOLE>

        # Оптимизация сборки
        $<$<CONFIG:Debug>:
            # $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-incremental>
            # $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-incremental>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/INCREMENTAL>
        >
        $<$<CONFIG:Release>:
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/INCREMENTAL:NO>
        >

        # Оптимизация
        $<$<CONFIG:Debug>:
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/OPT:NOREF /OPT:NOICF>
        >
        $<$<CONFIG:Release>:
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_CLANG}>:-flto -dead-strip>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_GNU}>:-flto --gc-sections>
            $<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/LTCG /OPT:REF /OPT:ICF>
        >

        # Отладка
        $<$<CONFIG:Debug>:$<$<BOOL:${BABYLON_CL_FLAGS_STYLE_MSVC}>:/DEBUG>>
    )
endfunction()
