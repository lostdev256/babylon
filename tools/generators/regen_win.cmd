echo off
cd %~dp0../..
meson setup --reconfigure ./build
pause