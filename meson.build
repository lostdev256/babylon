project(
    'Babylon',
    ['cpp', 'objcpp'],
    version: '0.0.1',
    meson_version: '1.9.1',
    default_options: [
        'cpp_std=c++23'
    ]
)

babylon_units = {}
#meson.include('tools/meson/babylon.meson')
# Platform
platform = host_machine.system()
if platform == 'windows'
    add_project_arguments('-DBABYLON_OS_WIN', language: ['cpp', 'objcpp'])
elif platform == 'darwin'
    add_project_arguments('-DBABYLON_OS_MAC', language: ['cpp', 'objcpp'])
endif

#add_project_arguments('-fmodules-ts', language: ['cpp', 'objcpp'])

subdir('modules')

if get_option('demo')
    subdir('demo')
elif not meson.is_subproject()
    deps = []
    foreach unit_name, unit_deps : babylon_units
        deps += unit_deps
        message('Babylon unit "@0@" enabled'.format(unit_name))
    endforeach
    declare_dependency(dependencies: deps)
endif
