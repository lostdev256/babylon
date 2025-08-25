unit_name = 'babylon_demo'

source_files = files(
    'src/app/app_configurator.h',
)
source_files += files(
    'src/app/app_configurator.cpp',
    'src/app/main.cpp',
)

pch_file = 'src/pch.h'
include_dirs = include_directories('src')

required_units = [
    'babylon_system',
    'babylon_ui'
]

unit_deps = []
foreach required_unit_name : required_units
    if babylon_units.has_key(required_unit_name)
        unit_deps += [babylon_units[required_unit_name]]
    else
        warning('Babylon unit "@0@" depends on "@1@", but it is not registered'.format(unit_name, required_unit_name))
    endif
endforeach

executable(
    unit_name,
    source_files,
    include_directories: include_dirs,
    #cpp_args: common_cargs,
    cpp_pch: pch_file,
    objcpp_args: ['-include', pch_file],
    dependencies: unit_deps
)
