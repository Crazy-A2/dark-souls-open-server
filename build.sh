#!/bin/bash
# ================================================================================================
#  DS3OS Build Script for Linux
# ================================================================================================

set -e

show_help() {
    echo "DS3OS Build Script - Usage"
    echo
    echo "build.sh [options]"
    echo
    echo "Options:"
    echo "  --plat, --arch ARCH   Target architecture (x86 or x64, default: x64)"
    echo "  --mode MODE           Build mode (debug or release, default: release)"
    echo "  --target TARGET       Target to build:"
    echo "                        server - Build Server (default)"
    echo "                        all    - Build all supported Linux targets"
    echo "  --clean               Clean build artifacts before building"
    echo "  --help                Show this help message"
    echo
}

ARCH="x64"
MODE="release"
TARGET="server"
CLEAN=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --arch|--plat)
            ARCH="$2"
            shift 2
            ;;
        --mode)
            MODE="$2"
            shift 2
            ;;
        --target)
            TARGET="$2"
            shift 2
            ;;
        --clean)
            CLEAN=1
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option: $1"
            echo
            show_help
            exit 1
            ;;
    esac
done

if [[ "$ARCH" != "x86" && "$ARCH" != "x64" ]]; then
    echo "ERROR: Invalid architecture '$ARCH'. Use x86 or x64."
    exit 1
fi

if [[ "$MODE" != "debug" && "$MODE" != "release" ]]; then
    echo "ERROR: Invalid mode '$MODE'. Use debug or release."
    exit 1
fi

if [[ "$TARGET" != "server" && "$TARGET" != "all" ]]; then
    echo "ERROR: Invalid target '$TARGET' on Linux. Supported targets: server, all."
    exit 1
fi

echo
echo "========================================"
echo "DS3OS Build Script"
echo "========================================"
echo
echo "Configuration:"
echo "  Platform: linux"
echo "  Architecture: $ARCH"
echo "  Mode: $MODE"
echo "  Target: $TARGET"
echo

if ! command -v xmake >/dev/null 2>&1; then
    echo "ERROR: XMake is not installed"
    exit 1
fi

if [[ $CLEAN -eq 1 ]]; then
    xmake clean-all
fi

xmake config --plat=linux --arch="$ARCH" --mode="$MODE"

case "$TARGET" in
    all)
        xmake build-all
        ;;
    server)
        xmake build Server
        xmake install-all
        ;;
esac

echo
echo "========================================"
echo "Build completed successfully!"
echo "Output directory: bin/${ARCH}_${MODE}"
echo "========================================"
echo
