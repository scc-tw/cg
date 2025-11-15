#!/bin/bash

set -euo pipefail

OPTIONS="--standalone --onefile"
OUTPUT_POSTFIX=""
NAME="cg"

ARCH=$(uname -m)

# Map architecture to consistent naming
case "$ARCH" in
    x86_64)
        ARCH_NAME="amd64"
        ;;
    aarch64|arm64)
        ARCH_NAME="arm64"
        ;;
    armv7l)
        # Keep original naming for armv7l for compatibility
        ARCH_NAME="armv7l"
        ;;
    *)
        ARCH_NAME="$ARCH"
        ;;
esac

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OUTPUT_POSTFIX=".elf"
    # For armv7l, use simple naming without 'linux-' prefix for compatibility
    if [[ "$ARCH" == "armv7l" ]]; then
        OUTPUT_NAME="$NAME-$ARCH_NAME$OUTPUT_POSTFIX"
    else
        OUTPUT_NAME="$NAME-linux-$ARCH_NAME$OUTPUT_POSTFIX"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OUTPUT_POSTFIX=".macho"
    OUTPUT_NAME="$NAME-$ARCH_NAME$OUTPUT_POSTFIX"
else
    OUTPUT_NAME="$NAME-$ARCH$OUTPUT_POSTFIX"
fi

poetry run python -m nuitka $OPTIONS main.py -o $OUTPUT_NAME
