################################################################################
# Source files
################################################################################
unit_source_files += files(
    'app_impl.h',
)

if is_os_mac
    unit_source_files += files(
        'mac/app_impl.h',
        'mac/app_impl.mm',
    )
elif is_os_win
    unit_source_files += files(
        'win/app_impl.h',
        'win/app_impl.mm',
    )
endif
