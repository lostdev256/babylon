################################################################################
# Babylon base unit configuration (BASE_BUILD_CFG)
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BN_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Default base build configuration. Override this if needed in your BASE_BUILD_CFG cfg.cmake file
function(bn_unit_external_configure_build UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        bn_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    # Properties
    bn_get_unit_property(${UNIT_NAME} UNIT_TYPE UNIT_TYPE)
    if(NOT UNIT_TYPE)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()

    bn_get_unit_property(${UNIT_NAME} ROOT_DIR ROOT_DIR)
    if(NOT ROOT_DIR)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): ROOT_DIR not specified")
        return()
    endif()

    bn_get_unit_property(${UNIT_NAME} OUTPUT_NAME OUTPUT_NAME)
    if(NOT OUTPUT_NAME)
        bn_log_fatal("Babylon unit (${UNIT_NAME}): OUTPUT_NAME not specified")
        return()
    endif()

    bn_get_unit_property(${UNIT_NAME} PCH PCH)

    set(IS_APP_UNIT FALSE)
    if(UNIT_TYPE STREQUAL "App")
        set(IS_APP_UNIT TRUE)
    endif()

    set(IS_STARTUP_UNIT FALSE)
    if(IS_APP_UNIT)
        list(LENGTH BN_APP_UNITS APPS_COUNT)
        if(APPS_COUNT GREATER 0)
            list(GET BN_APP_UNITS -1 STARTUP_UNIT)
            if(STARTUP_UNIT STREQUAL ${UNIT_NAME})
                set(IS_STARTUP_UNIT TRUE)
            endif()
        endif()
    endif()

    # Configure
    if(CMAKE_GENERATOR STREQUAL "Xcode" AND IS_STARTUP_UNIT)
        set_target_properties(${UNIT_NAME} PROPERTIES XCODE_SCHEME_NAME "DefaultScheme")
    endif()

    if(MSVC)
        if(IS_STARTUP_UNIT)
            set_property(DIRECTORY ${ROOT_DIR} PROPERTY VS_STARTUP_PROJECT ${UNIT_NAME})
        endif()

        set_target_properties(${UNIT_NAME} PROPERTIES
            VS_GLOBAL_KEYWORD "Win32Proj"
            VS_GLOBAL_ROOTNAMESPACE ${UNIT_NAME}
        )
    endif()

    if(BN_OS_MAC AND IS_APP_UNIT)
        set_target_properties(${UNIT_NAME} PROPERTIES
            MACOSX_BUNDLE ON
            MACOSX_BUNDLE_INFO_PLIST "${BN_CMAKE_PLATFORM_MODULES_DIR}/mac/Info.plist.in"
            MACOSX_BUNDLE_NAME "${OUTPUT_NAME}"
            MACOSX_BUNDLE_VERSION "${PROJECT_VERSION}"
            MACOSX_BUNDLE_COPYRIGHT ""
            MACOSX_BUNDLE_GUI_IDENTIFIER "lost.babylon.${OUTPUT_NAME}"
            MACOSX_BUNDLE_ICON_FILE "Icon.icns"
            MACOSX_BUNDLE_INFO_STRING ""
            MACOSX_BUNDLE_LONG_VERSION_STRING ""
            MACOSX_BUNDLE_SHORT_VERSION_STRING ""
            XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "lost.babylon.${OUTPUT_NAME}"
        )
    endif()

    set_target_properties(${UNIT_NAME} PROPERTIES
        C_STANDARD ${CMAKE_C_STANDARD}
        CXX_STANDARD ${CMAKE_CXX_STANDARD}
    )

    if(BN_OS_WIN)
        target_compile_definitions(${UNIT_NAME} PRIVATE BN_OS_WIN)
    elseif(BN_OS_MAC)
        target_compile_definitions(${UNIT_NAME} PRIVATE BN_OS_MAC)
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
        $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-pedantic>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-pedantic>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/permissive- /Zc:forScope /Zc:wchar_t /Zc:inline /Zc:__cplusplus /Zc:preprocessor>

        # Обработка исключений
        $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-fexceptions>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-fexceptions>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/EHsc>

        # Соглашения о вызовах (stdcall для WinAPI)
        $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/Gz>

        # Операции с плавающей точкой
        # $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-ffloat-store>
        # $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-ffloat-store>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/fp:precise>

        # CRT
        $<$<CONFIG:Debug>:$<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/MDd>>
        $<$<CONFIG:Release>:$<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/MD>>

        # Предупреждения
        $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-Wall -Wextra $<$<BOOL:${BN_CL_WARNING_AS_ERROR}>:-Werror>>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-Wall -Wextra $<$<BOOL:${BN_CL_WARNING_AS_ERROR}>:-Werror>>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/Wall $<$<BOOL:${BN_CL_WARNING_AS_ERROR}>:/WX>>
        
        # Защита
        $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-fstack-protector-strong>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-fstack-protector-strong>
        $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/GS /sdl>

        $<$<BOOL:${BN_CL_ASAN}>:
            $<$<CONFIG:Debug>:
                $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-fsanitize=address -fsanitize=undefined>
                $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-fsanitize=address -fsanitize=undefined>
                $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/RTC1>
            >
        >

        # Оптимизация сборки
        $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/Gm->

        # Оптимизация
        $<$<CONFIG:Debug>:
            $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-O0>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-O0>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/Od /Ob0>
        >
        $<$<CONFIG:Release>:
            $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-O2 -finline-functions -flto -ffunction-sections>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-O2 -finline-functions -flto -ffunction-sections>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/O2 /Ob2 /Oi /GL /Gy>
        >

        # Отладка
        $<$<CONFIG:Debug>:
            $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-g3>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-ggdb3>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/Zi>
        >
    )

    target_link_options(${UNIT_NAME} PRIVATE
        # System
        $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/SUBSYSTEM:CONSOLE>

        # Оптимизация сборки
        $<$<CONFIG:Debug>:
            # $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-incremental>
            # $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-incremental>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/INCREMENTAL>
        >
        $<$<CONFIG:Release>:
            $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/INCREMENTAL:NO>
        >

        # Оптимизация
        $<$<CONFIG:Debug>:
            $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/OPT:NOREF /OPT:NOICF>
        >
        $<$<CONFIG:Release>:
            $<$<BOOL:${BN_CL_FLAGS_STYLE_CLANG}>:-flto -dead-strip>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_GNU}>:-flto --gc-sections>
            $<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/LTCG /OPT:REF /OPT:ICF>
        >

        # Отладка
        $<$<CONFIG:Debug>:$<$<BOOL:${BN_CL_FLAGS_STYLE_MSVC}>:/DEBUG>>
    )
endfunction()
