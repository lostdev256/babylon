################################################################################
# Babylon demo application
################################################################################
unit_name = 'babylon_demo'

source_files = files(
    'src/app/app_configurator.h',
    'src/app/app_configurator.cpp',
    'src/app/main.cpp',
)

include_dirs = include_directories('src')

required_units = [
    'babylon_system'
]

common_cpp_args = []

executable(
    unit_name,
    source_files,
    include_directories: include_dirs,
    cpp_args: common_cpp_args,
    dependencies: dependency(required_units)
)


#set_target_properties(${UNIT_NAME} PROPERTIES
#    MACOSX_BUNDLE ON
#    MACOSX_BUNDLE_INFO_PLIST "${BABYLON_CMAKE_PLATFORM_MODULES_DIR}/mac/Info.plist.in"
#    MACOSX_BUNDLE_NAME "${OUTPUT_NAME}"
#    MACOSX_BUNDLE_VERSION "${PROJECT_VERSION}"
#    MACOSX_BUNDLE_COPYRIGHT ""
#    MACOSX_BUNDLE_GUI_IDENTIFIER "lost.babylon.${OUTPUT_NAME}"
#    MACOSX_BUNDLE_ICON_FILE "Icon.icns"
#    MACOSX_BUNDLE_INFO_STRING ""
#    MACOSX_BUNDLE_LONG_VERSION_STRING ""
#    MACOSX_BUNDLE_SHORT_VERSION_STRING ""
#    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "lost.babylon.${OUTPUT_NAME}"
#)


#target_compile_definitions(${UNIT_NAME} PRIVATE
#    WIN32
#    _WINDOWS
#    $<$<CONFIG:Debug>:_DEBUG>
#    $<$<CONFIG:Release>:NDEBUG>
#    $<$<STREQUAL:${UNIT_TYPE},Module>:_LIB>
#)