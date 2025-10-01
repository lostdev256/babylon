# Babylon

## Meson setup/build presets
- **tools/meson/presets/babylon.ini** - Base framework preset
- **tools/meson/presets/debug.ini**, **tools/meson/presets/release.ini** - Build type presets
- **tools/meson/presets/asan.ini** - **ASAN** build preset
- **tools/meson/presets/demo.ini** - Build babylon demo app
> For example (setup/build debug babylon demo app):
> `meson setup --native-file ./tools/meson/presets/babylon.ini --native-file ./tools/meson/presets/debug.ini --native-file ./tools/meson/presets/demo.ini`
> `meson build --native-file ./tools/meson/presets/babylon.ini --native-file ./tools/meson/presets/debug.ini --native-file ./tools/meson/presets/demo.ini`
