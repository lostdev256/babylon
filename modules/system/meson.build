unit_name = 'babylon_system'

source_files = files(
    'include/babylon/common/singleton.h',
    'include/babylon/place/place.h',
    'include/babylon/place/place_manager.h',
    'include/babylon/place/place_node.h',
    'include/babylon/place/place_node_view.h',
    'include/babylon/place/place_view.h',
    'include/babylon/platform/main.h',
    'include/babylon/platform/platform.h',
    'include/babylon/system/app.h',
    'include/babylon/system/app_arguments.h',
    'include/babylon/system/app_configurator_iface.h',
    'include/babylon/system/app_controller_iface.h',
    'include/babylon/system/babylon.h',
)
source_files += files(
    'src/place/place.cpp',
    'src/place/place_manager.cpp',
    'src/place/place_node.cpp',
    'src/place/place_node_view.cpp',
    'src/place/place_view.cpp',
    'src/system/app.cpp',
    'src/system/app_arguments.cpp',
    'src/system/place_manager.cpp',
)

platform = host_machine.system()
if platform == 'windows'
    source_files += files(
        'include/babylon/place/platform/win/place_view_impl.h',
        'include/babylon/system/platform/win/app_controller_impl.h',
    )
    source_files += files(
        'src/place/platform/win/place_view_impl.cpp',
        'src/system/platform/win/app_controller_impl.cpp',
    )
elif platform == 'darwin'
    source_files += files(
        'include/babylon/place/platform/mac/place_impl.h',
        'include/babylon/place/platform/mac/place_view_impl.h',
        'include/babylon/platform/mac/app_delegate.h',
        'include/babylon/platform/mac/view_controller.h',
        'include/babylon/system/platform/mac/app_controller_impl.h',
    )
    source_files += files(
        'src/place/platform/mac/place_impl.mm',
        'src/place/platform/mac/place_view_impl.mm',
        'src/platform/mac/app_delegate.mm',
        'src/platform/mac/view_controller.mm',
        'src/system/platform/mac/app_controller_impl.mm',
    )
endif

pch_file = 'src/pch.h'
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
    #cpp_args: common_cargs,
    cpp_pch: pch_file,
    objcpp_args: ['-include', pch_file],
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
