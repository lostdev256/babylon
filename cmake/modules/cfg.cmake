################################################################################
# Babylon default unit configuration
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Default additional build configuration. Override this if needed in your cfg.cmake file
function(babylon_unit_external_configure_build UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        babylon_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    set(UNIT_TYPE "")
    babylon_get_unit_property(${UNIT_NAME} UNIT_TYPE UNIT_TYPE)
    if(NOT UNIT_TYPE)
        babylon_log_fatal("Babylon unit (${UNIT_NAME}): UNIT_TYPE not specified")
        return()
    endif()

    # TODO:
    # set_property(DIRECTORY ${BABYLON_UNIT_ROOT_DIR} PROPERTY VS_STARTUP_PROJECT ${BABYLON_UNIT_NAME})

    if(MSVC)
        set_target_properties(${UNIT_NAME} PROPERTIES
            VS_GLOBAL_KEYWORD "Win32Proj"
            VS_GLOBAL_ROOTNAMESPACE ${UNIT_NAME}
        )
    endif()

    set_target_properties(${UNIT_NAME} PROPERTIES
        CXX_STANDARD ${CMAKE_CXX_STANDARD}
        C_STANDARD ${CMAKE_C_STANDARD}
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



    # TODO: разобраться
    # if(BABYLON_OS_MAC)
    #     set_target_properties(${BABYLON_UNIT_NAME} PROPERTIES
    #         MACOSX_BUNDLE "ON"
    #         MACOSX_BUNDLE_INFO_PLIST ${BABYLON_CMAKE_PLATFORM_CFG_DIR}/Info.plist.in
    #         MACOSX_BUNDLE_NAME ${BABYLON_UNIT_NAME}
    #         MACOSX_BUNDLE_VERSION ${PROJECT_VERSION}
    #         MACOSX_BUNDLE_COPYRIGHT ""
    #         MACOSX_BUNDLE_GUI_IDENTIFIER "org.${BABYLON_UNIT_NAME}.gui"
    #         MACOSX_BUNDLE_ICON_FILE "Icon.icns"
    #         MACOSX_BUNDLE_INFO_STRING ""
    #         MACOSX_BUNDLE_LONG_VERSION_STRING ""
    #         MACOSX_BUNDLE_SHORT_VERSION_STRING ""
    #     )
    # endif()
    #
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


    # target_compile_definitions(${UNIT_NAME} PRIVATE ${COMPILE_DEFINES})
    # target_compile_options(${UNIT_NAME} PRIVATE ${COMPILE_OPTIONS})
    # target_link_options(${UNIT_NAME} PRIVATE ${LINK_OPTIONS})
endfunction()
