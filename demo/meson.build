################################################################################
# Babylon demo application
################################################################################
unit_name = 'babylon_demo'

################################################################################
# Source files
################################################################################
unit_include_directories = include_directories('src')
unit_source_files = files(
    'src/app/app_configurator.cpp',
    'src/app/app_configurator.h',
    'src/app/main.cpp',
)

################################################################################
# Dependencies
################################################################################
unit_dependencies = dependency('babylon_system')

################################################################################
# Target
################################################################################
executable(
    unit_name,
    unit_source_files,
    include_directories: unit_include_directories,
    dependencies: unit_dependencies,
)
