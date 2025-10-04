################################################################################
# Babylon system module
################################################################################
unit_name = 'babylon_system'

################################################################################
# Source files
################################################################################
unit_include_directories = include_directories('src')
unit_source_files = files(
    'src/babylon/entry.h',
)

subdir('src/babylon/place')
subdir('src/babylon/system')

################################################################################
# Dependencies
################################################################################
unit_dependencies = []

if is_os_mac
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
elif is_os_win
    unit_dependencies += [
        cpp_cl.find_library('gdi32'),
        cpp_cl.find_library('gdiplus'),
        cpp_cl.find_library('user32'),
        cpp_cl.find_library('advapi32'),
        cpp_cl.find_library('ole32'),
        cpp_cl.find_library('shell32'),
        cpp_cl.find_library('comdlg32'),
    ]
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
