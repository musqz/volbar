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
UNINSTALL=false
while [ $# -gt 0 ]; do
    case $1 in
        --prefix=*)
            PREFIX="${1#*=}"
            shift
            ;;
        --prefix)
            if [ -z "$2" ]; then
                echo "✗ --prefix needs a directory"
                exit 1
            fi
            PREFIX="$2"
            shift 2
            ;;
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--prefix DIR] [--uninstall]"
            echo ""
            echo "  --prefix DIR   Install location (default: /usr/local)"
            echo "  --uninstall    Remove volbar from the prefix instead of installing"
            exit 0
            ;;
        *)
            echo "✗ Unknown option: $1 (see $0 --help)"
            exit 1
            ;;
    esac
done

if [ -z "$PREFIX" ]; then
    echo "✗ --prefix must not be empty"
    exit 1
fi

# Installation paths
BIN_DIR="$PREFIX/bin"
MAN_DIR="$PREFIX/share/man/man1"
DATA_DIR="$PREFIX/share/volbar"
THEME_DIR="$DATA_DIR/themes"

# Check for root if (un)installing in system directories
if [[ "$PREFIX" == "/usr" || "$PREFIX" == "/usr/local" ]]; then
    if [ "$EUID" -ne 0 ]; then
        echo "✗ System (un)install requires root privileges"
        echo "  Run: sudo $0 --prefix $PREFIX$($UNINSTALL && echo " --uninstall")"
        exit 1
    fi
fi

if $UNINSTALL; then
    echo "Uninstall prefix: $PREFIX"
    echo ""

    # A pacman-installed volbar must be removed with pacman
    if command -v pacman &> /dev/null && pacman -Qqo "$BIN_DIR/volbar" &> /dev/null; then
        echo "✗ $BIN_DIR/volbar belongs to the pacman package '$(pacman -Qqo "$BIN_DIR/volbar")'"
        echo "  Remove it with: sudo pacman -R volbar"
        exit 1
    fi

    if [ ! -e "$BIN_DIR/volbar" ] && [ ! -d "$DATA_DIR" ] && [ ! -e "$MAN_DIR/volbar.1" ]; then
        echo "✗ volbar is not installed in $PREFIX"
        exit 1
    fi

    # Stop running daemons first (SIGTERM lets them remove their PID file)
    DAEMON_PATTERN="^[^ ]*python[^ ]* $BIN_DIR/volbar .*--start-daemon"
    if pkill -TERM -f "$DAEMON_PATTERN"; then
        echo "→ Stopped running volbar daemon"
        sleep 0.5
    fi

    echo "→ Removing volbar..."
    for path in "$BIN_DIR/volbar" "$MAN_DIR/volbar.1" "$DATA_DIR"; do
        if [ -e "$path" ]; then
            rm -rf "$path"
            echo "  removed $path"
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ✓ Uninstall complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Your own themes in ~/.config/volbar/ were kept."
    echo "Delete them by hand if you no longer need them."
    exit 0
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

# Install main script (replace @@VERSION@@ placeholder)
echo "→ Installing volbar..."
sed "s/@@VERSION@@/$VERSION/g" "$SCRIPT_DIR/volbar" > "$BIN_DIR/volbar"
chmod +x "$BIN_DIR/volbar"
echo "  $BIN_DIR/volbar"

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
