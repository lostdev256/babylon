################################################################################
# Babylon framework
################################################################################
project(
    'babylon',
    ['cpp'],
    version: '0.0.0',
    meson_version: '>=1.9.1',
    default_options: ['cpp_std=c++23'],
)

################################################################################
# Platform
################################################################################
is_os_win = (host_machine.system() == 'windows')
is_os_mac = (host_machine.system() == 'darwin')

if is_os_win
    add_project_arguments('-DBABYLON_OS_WIN', language: ['cpp', 'objcpp'])
elif is_os_mac
    add_project_arguments('-DBABYLON_OS_MAC', language: ['cpp', 'objcpp'])
endif

################################################################################
# Compiler
################################################################################
if is_os_mac
    add_languages('objcpp', native: false, required: true)
endif

cpp_cl = meson.get_compiler('cpp')
cpp_cl_id = cpp_cl.get_id()
is_cpp_cl_gcc = (cpp_cl_id == 'gcc')
is_cpp_cl_clang = (cpp_cl_id == 'clang' or cpp_cl_id == 'appleclang')
is_cpp_cl_ms_clang = (cpp_cl_id == 'clang-cl')
is_cpp_cl_msvc = (cpp_cl_id == 'msvc' or is_cpp_cl_ms_clang)

################################################################################
# Common comiller flage
################################################################################
common_cl_flags = []

# ...

add_project_arguments(common_cl_flags, language: 'cpp')
if is_os_mac
    add_project_arguments(common_cl_flags, language: ['objcpp'])
endif

################################################################################
# Common linker flage
################################################################################
common_link_flags = []

# ...

add_project_link_arguments(common_link_flags, language: 'cpp')
if is_os_mac
    add_project_link_arguments(common_link_flags, language: ['objcpp'])
endif

################################################################################
# Modules
################################################################################
subdir('modules')

################################################################################
# Build
################################################################################
if get_option('demo')
    subdir('demo')
elif not meson.is_subproject()
    required_units = ['babylon_system']
    dependency(required_units)
endif
