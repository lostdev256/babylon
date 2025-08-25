unit_name = 'babylon_ui'

source_files = files(
    'include/babylon/dummy.h',
)
source_files += files(
    'src/dummy.cpp',
)

pch_file = 'src/pch.h'
include_dirs = include_directories('include')

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
