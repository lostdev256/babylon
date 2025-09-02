echo off
cd %~dp0../..
meson setup ./build . --backend=vs --native-file tools/meson/presets/demo.ini
pause