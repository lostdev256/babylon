#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
python "$CURRENT_DIR/scripts/init.py" --rootdir "$CURRENT_DIR/../../"
