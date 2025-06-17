################################################################################
# Babylon additional unit configuration (BUILD_CFG)
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Additional build configuration
function(bn_unit_external_configure_build UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        bn_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()

    if(BABYLON_OS_WIN)
        target_link_libraries(${UNIT_NAME} PUBLIC gdi32 gdiplus user32 advapi32 ole32 shell32 comdlg32)
    elseif(BABYLON_OS_MAC)
        # find_package(Cocoa REQUIRED)
        find_library(COCOA_FRAMEWORK Cocoa)
        find_library(CORE_VIDEO_FRAMEWORK CoreVideo)

        target_link_libraries(${UNIT_NAME} PUBLIC ${COCOA_FRAMEWORK} ${CORE_VIDEO_FRAMEWORK})
    endif()
endfunction()
