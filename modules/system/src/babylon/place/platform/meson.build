################################################################################
# Source files
################################################################################
unit_source_files += files(
    'place_impl.h',
    'place_view_impl.h',
)

if is_os_mac
    unit_source_files += files(
        'mac/place_impl.h',
        'mac/place_impl.mm',
        'mac/place_view_impl.h',
        'mac/place_view_impl.mm',
        'mac/bln_window_controller.h',
        'mac/bln_window_controller.mm',
    )
elif is_os_win
    unit_source_files += files(
        'win/place_impl.h',
        'win/place_impl.cpp',
        'win/place_view_impl.h',
        'win/place_view_impl.cpp',
    )
endif
