################################################################################
# Babylon system module
################################################################################
unit_name = 'babylon_ui'

################################################################################
# Source files
################################################################################
unit_include_directories = include_directories('include')
unit_source_files = files()

################################################################################
# Dependencies
################################################################################
unit_dependencies = dependency('babylon_system')

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
