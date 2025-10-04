################################################################################
# Source files
################################################################################
unit_source_files += files(
    'app_impl.h',
    'main.h',
)

if is_os_mac
    unit_source_files += files(
        'mac/app_impl.h',
        'mac/app_impl.mm',
        'mac/bln_app_delegate.h',
        'mac/bln_app_delegate.mm',
        'mac/bln_loop_controller.h',
        'mac/bln_loop_controller.mm',
    )
elif is_os_win
    unit_source_files += files(
        'win/app_impl.h',
        'win/app_impl.cpp',
    )
endif
