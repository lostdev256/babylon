#!/bin/bash

cd "$(dirname "$0")/../../" || exit

BUILDDIR=./build

if [ ! -d "$BUILDDIR" ]; then
    echo "Creating folder $BUILDDIR..."
    mkdir "$BUILDDIR"
fi

if [ -f "$BUILDDIR/meson-info/meson-info.json" ]; then
    echo "Reconfiguring $BUILDDIR..."
    meson setup --reconfigure "$BUILDDIR"
else
    echo "Configuring $BUILDDIR..."
    meson setup "$BUILDDIR" . --backend=xcode --native-file tools/meson/presets/babylon.ini --native-file tools/meson/presets/demo.ini
fi
