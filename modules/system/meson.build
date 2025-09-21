unit_name = 'babylon_system'

source_files = files(
    'include/babylon/platform/main.h',
    'include/babylon/platform/platform.h',
    'include/babylon/entry.h',

    'modules/common.ixx',
    'modules/common/std.ixx',

    'modules/system.ixx',
    'modules/system/app.ixx',
    'modules/system/app_arguments.ixx',
    'modules/system/app_configurator_iface.ixx',
    'modules/system/platform/app_impl.ixx',

    'src/system/app.cpp',
    'src/system/app_arguments.cpp',
)

platform = host_machine.system()
if platform == 'windows'
    source_files += files(
        'src/system/platform/win/app_impl.cpp',
    )
elif platform == 'darwin'
    source_files += files(
        'src/system/platform/mac/app_impl.mm',
    )
endif

include_dirs = include_directories('include')

platform = host_machine.system()
if platform == 'windows'
    cc = meson.get_compiler('cpp')
    unit_deps = [
        cc.find_library('gdi32'),
        cc.find_library('gdiplus'),
        cc.find_library('user32'),
        cc.find_library('advapi32'),
        cc.find_library('ole32'),
        cc.find_library('shell32'),
        cc.find_library('comdlg32'),
    ]
elif platform == 'darwin'
    unit_deps = dependency('appleframeworks', modules: ['AppKit', 'Foundation'])
endif

unit = library(
    unit_name,
    source_files,
    include_directories: include_dirs,
    build_by_default: false,
    dependencies: unit_deps,
)

babylon_units += {
    unit_name : declare_dependency(
        link_with: unit,
        include_directories: include_dirs
    )
}

#if(BABYLON_OS_WIN)
#    target_link_libraries(${UNIT_NAME} PUBLIC gdi32 gdiplus user32 advapi32 ole32 shell32 comdlg32)
#    elseif(BABYLON_OS_MAC)
#    # find_package(Cocoa REQUIRED)
#    find_library(COCOA_FRAMEWORK Cocoa)
#    find_library(CORE_VIDEO_FRAMEWORK CoreVideo)
#
#    target_link_libraries(${UNIT_NAME} PUBLIC ${COCOA_FRAMEWORK} ${CORE_VIDEO_FRAMEWORK})
#endif()
