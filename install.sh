#!/bin/bash
# Volbar installer

set -e

VERSION="1.0.0"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Volbar v${VERSION} Installer"
echo "  Simple volume bar for X11 desktops"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Parse arguments
PREFIX="/usr/local"
if [ "$1" = "--prefix" ] && [ -n "$2" ]; then
    PREFIX="$2"
fi

if [ "$PREFIX" = "/usr/bin" ] || [ "$PREFIX" = "/usr" ]; then
    if [ "$EUID" -ne 0 ]; then
        echo "✗ System install requires root privileges"
        echo "  Run: sudo $0 --prefix /usr/local"
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
    echo "  Install with: sudo pacman -S python-gobject"
    echo "                sudo apt install python3-gi"
    exit 1
fi
echo "✓ Python 3 and PyGObject found"

# Check for audio backend
BACKEND_FOUND=false
for cmd in wpctl pactl amixer; do
    if command -v $cmd &> /dev/null; then
        echo "✓ Found audio backend: $cmd"
        BACKEND_FOUND=true
        break
    fi
done

if [ "$BACKEND_FOUND" = false ]; then
    echo "⚠ No audio backend found (wpctl, pactl, amixer)"
fi

echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set installation paths
BIN_DIR="$PREFIX/bin"
MAN_DIR="$PREFIX/share/man/man1"
THEME_DIR="$PREFIX/share/volbar/themes"

# Check if required files exist
if [ ! -f "$SCRIPT_DIR/volbar" ]; then
    echo "✗ volbar script not found in $SCRIPT_DIR"
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/volbar.1" ]; then
    echo "✗ volbar.1 man page not found in $SCRIPT_DIR"
    exit 1
fi

if [ ! -d "$SCRIPT_DIR/themes" ]; then
    echo "✗ themes directory not found in $SCRIPT_DIR"
    exit 1
fi

# Create directories
echo "→ Creating directories..."
mkdir -p "$BIN_DIR"
mkdir -p "$MAN_DIR"
mkdir -p "$THEME_DIR"

# Install main script
echo "→ Installing volbar..."
cp "$SCRIPT_DIR/volbar" "$BIN_DIR/volbar"
chmod +x "$BIN_DIR/volbar"
echo "✓ Installed to $BIN_DIR/volbar"

# Install man page
echo "→ Installing man page..."
if [ "$EUID" -eq 0 ]; then
    cp "$SCRIPT_DIR/volbar.1" "$MAN_DIR/volbar.1"
    echo "✓ Installed to $MAN_DIR/volbar.1"
else
    echo "⚠ Man page requires root privileges to install"
    echo "  Run as root: sudo $0 --prefix $PREFIX"
fi

# Install themes
echo "→ Installing themes..."
cp "$SCRIPT_DIR/themes"/*.css "$THEME_DIR/" 2>/dev/null || true
THEME_COUNT=$(ls "$SCRIPT_DIR/themes"/*.css 2>/dev/null | wc -l)
echo "✓ Installed $THEME_COUNT themes to $THEME_DIR/"
echo ""

# Success message
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Binary:   $BIN_DIR/volbar"
echo "Manual:   $MAN_DIR/volbar.1"
echo "Themes:   $THEME_DIR/"
echo ""
echo "Usage:"
echo "  volbar --show"
echo "  volbar --help"
echo "  man volbar"
echo ""
