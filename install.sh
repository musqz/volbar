#!/usr/bin/env bash
# Volbar installer
set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read version from version.txt
if [ -f "$SCRIPT_DIR/version.txt" ]; then
    VERSION=$(cat "$SCRIPT_DIR/version.txt" | tr -d '[:space:]')
else
    VERSION="unknown"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Volbar v${VERSION} Installer"
echo "  Simple X11 volume bar. Tiny footprint, highly customizable."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Parse arguments
PREFIX="/usr/local"
for arg in "$@"; do
    case $arg in
        --prefix=*)
            PREFIX="${arg#*=}"
            shift
            ;;
        --prefix)
            PREFIX="$2"
            shift 2
            ;;
    esac
done

# Check for root if installing to system directories
if [[ "$PREFIX" == "/usr" || "$PREFIX" == "/usr/local" ]]; then
    if [ "$EUID" -ne 0 ]; then
        echo "✗ System install requires root privileges"
        echo "  Run: sudo $0 --prefix $PREFIX"
        exit 1
    fi
fi

echo "Installation prefix: $PREFIX"
echo ""

# Check dependencies
echo "→ Checking dependencies..."

if ! command -v python3 &> /dev/null; then
    echo "✗ Python 3 not found"
    echo "  Install with: sudo pacman -S python"
    echo "                sudo apt install python3"
    exit 1
fi

if ! python3 -c "import gi" 2>/dev/null; then
    echo "✗ PyGObject (GTK3) not found"
    echo "  Install with: sudo pacman -S python-gobject gtk3"
    echo "                sudo apt install python3-gi gir1.2-gtk-3.0"
    exit 1
fi

echo "✓ Python 3 and PyGObject found"

# Check for audio backend
BACKEND_FOUND=false
for cmd in wpctl pactl amixer; do
    if command -v $cmd &> /dev/null; then
        echo "✓ Audio backend: $cmd"
        BACKEND_FOUND=true
        break
    fi
done

if [ "$BACKEND_FOUND" = false ]; then
    echo "⚠ No audio backend found (wpctl, pactl, amixer)"
fi

echo ""

# Set installation paths
BIN_DIR="$PREFIX/bin"
MAN_DIR="$PREFIX/share/man/man1"
THEME_DIR="$PREFIX/share/volbar/themes"
DATA_DIR="$PREFIX/share/volbar"

# Check if required files exist
if [ ! -f "$SCRIPT_DIR/volbar" ]; then
    echo "✗ volbar script not found in $SCRIPT_DIR"
    exit 1
fi

# Create directories
echo "→ Creating directories..."
mkdir -p "$BIN_DIR"
mkdir -p "$MAN_DIR"
mkdir -p "$THEME_DIR"
mkdir -p "$DATA_DIR"

# Install main script
echo "→ Installing volbar..."
cp "$SCRIPT_DIR/volbar" "$BIN_DIR/volbar"
chmod +x "$BIN_DIR/volbar"
echo "  $BIN_DIR/volbar"

# Install version.txt
if [ -f "$SCRIPT_DIR/version.txt" ]; then
    cp "$SCRIPT_DIR/version.txt" "$DATA_DIR/version.txt"
    echo "  $DATA_DIR/version.txt"
fi

# Install man page (replace @@VERSION@@ placeholder)
if [ -f "$SCRIPT_DIR/volbar.1" ]; then
    echo "→ Installing man page..."
    sed "s/@@VERSION@@/$VERSION/g" "$SCRIPT_DIR/volbar.1" > "$MAN_DIR/volbar.1"
    echo "  $MAN_DIR/volbar.1"
else
    echo "⚠ Man page not found, skipping"
fi

# Install themes
if [ -d "$SCRIPT_DIR/themes" ]; then
    echo "→ Installing themes..."
    THEME_COUNT=$(ls "$SCRIPT_DIR/themes"/*.css 2>/dev/null | wc -l)
    if [ "$THEME_COUNT" -gt 0 ]; then
        cp "$SCRIPT_DIR/themes"/*.css "$THEME_DIR/"
        echo "  $THEME_COUNT themes → $THEME_DIR/"
    fi
else
    echo "⚠ Themes directory not found, skipping"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Usage:"
echo "  volbar --show           Show volume bar"
echo "  volbar --start-daemon   Start daemon"
echo "  volbar --help           Show all options"
echo "  man volbar              Manual page"
echo ""
