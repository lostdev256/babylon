################################################################################
# Babylon system module
################################################################################
unit_name = 'babylon_system'

################################################################################
# Source files
################################################################################
unit_include_directories = include_directories('include')
unit_source_files = files(
    'include/babylon/entry.h',
    'include/babylon/platform/main.h',
    'include/babylon/platform/platform.h',
    'include/babylon/system/app.h',
    'include/babylon/system/app_arguments.h',
    'include/babylon/system/app_configurator_iface.h',
    'include/babylon/system/platform/app_impl.h',
    'src/system/app.cpp',
    'src/system/app_arguments.cpp',
)

if is_os_win
    unit_source_files += files('src/system/platform/win/app_impl.cpp')
elif is_os_mac
    unit_source_files += files('src/system/platform/mac/app_impl.mm')
endif

################################################################################
# Dependencies
################################################################################
unit_dependencies = []

if is_os_win
    unit_dependencies += [
        cpp_cl.find_library('gdi32'),
        cpp_cl.find_library('gdiplus'),
        cpp_cl.find_library('user32'),
        cpp_cl.find_library('advapi32'),
        cpp_cl.find_library('ole32'),
        cpp_cl.find_library('shell32'),
        cpp_cl.find_library('comdlg32'),
    ]
elif is_os_mac
    unit_dependencies += dependency(
        'appleframeworks',
        modules: [
            'Foundation',
            'AppKit',
            'CoreVideo',
            'QuartzCore',
            'CoreGraphics',
            'CoreMedia',
        ],
    )
endif

################################################################################
# Target
################################################################################
unit = library(
    unit_name,
    unit_source_files,
    include_directories: unit_include_directories,
    dependencies: unit_dependencies,
    build_by_default: false,
)

meson.override_dependency(
    unit_name,
    declare_dependency(
        link_with: unit,
        include_directories: unit_include_directories,
    ),
)
