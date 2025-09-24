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

unit_deps = []
foreach required_unit_name : required_units
    if babylon_units.has_key(required_unit_name)
        unit_deps += [babylon_units[required_unit_name]]
    else
        warning('Babylon unit "@0@" depends on "@1@", but it is not registered'.format(unit_name, required_unit_name))
    endif
endforeach

common_cpp_args = []

executable(
    unit_name,
    source_files,
    include_directories: include_dirs,
    cpp_args: common_cpp_args,
    dependencies: unit_deps
)
