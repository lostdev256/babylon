echo off
cd %~dp0../..
set BUILDDIR=./build
if not exist "%BUILDDIR%" (
    echo Creating folder %BUILDDIR%...
    mkdir "%BUILDDIR%"
)
if exist %BUILDDIR%/meson-info/meson-info.json (
    echo Reconfiguring %BUILDDIR%...
    meson setup --reconfigure %BUILDDIR%
) else (
    echo Configuring %BUILDDIR%...
    meson setup %BUILDDIR% . --backend=vs --native-file tools/meson/presets/demo.ini
)

echo Fixing...
call python ./tools/scripts/fix_vs_project_filters.py %BUILDDIR%

pause