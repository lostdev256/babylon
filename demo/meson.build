unit_name = 'babylon_demo'

source_files = files(
    'modules/app.ixx',
    'modules/app/app_configurator.ixx',

    'src/app/main.cpp',
    'src/app/app_configurator.cpp',
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

cc = meson.get_compiler('cpp')
is_clang = cc.get_id() == 'clang'

common_cpp_args = []
#if is_clang
#    common_cpp_args += ['-fmodules-ts']
#    objcpp_args += ['-fmodules-ts']
#endif

executable(
    unit_name,
    source_files,
    include_directories: include_dirs,
    cpp_args: common_cpp_args,
    dependencies: unit_deps
)
