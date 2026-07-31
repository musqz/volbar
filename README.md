```

███╗   ███╗ █████╗ ██████╗  ██████╗ ██╗  ██╗
████╗ ████║██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝
██╔████╔██║███████║██████╔╝██║   ██║ ╚███╔╝ 
██║╚██╔╝██║██╔══██║██╔══██╗██║   ██║ ██╔██╗ 
██║ ╚═╝ ██║██║  ██║██████╔╝╚██████╔╝██╔╝ ██╗
╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝  Community: 
```

# Volbar

Simple X11 volume bar. Tiny footprint, highly customizable.

![volbar](https://img.shields.io/badge/version-1.2.0-blue)
![license](https://img.shields.io/badge/license-free-green)

![volbar](images/volbar.png)

## Features

- Minimal & fast GTK3 volume indicator
- Auto-detects audio backend (PipeWire/PulseAudio/ALSA)
- Daemon mode with configurable poll interval
- System tray support
- Auto theme from Mabox wallpaper colors
- 13 included themes + CSS customization
- Multiple slider styles and placements

## Requirements

```bash
# Arch Linux
sudo pacman -S python-gobject gtk3
```

## Installation

```bash
git clone https://github.com/musqz/volbar.git
cd volbar
sudo ./install.sh
```

Custom prefix:
```bash
sudo ./install.sh --prefix /usr
```

## Quick Start

```bash
# Show volume bar once
volbar --show

# Start daemon (auto-shows on volume changes)
volbar --start-daemon

# Stop daemon
volbar --stop-daemon
```

## Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `--size` | small, medium, large | medium | Window size |
| `--placement` | center, top, bottom, left, right, top-left, top-right, bottom-left, bottom-right | center | Screen position |
| `--slider` | smooth, blocks, dots, line | smooth | Slider style |
| `--theme` | theme name or `auto` | default | CSS theme |
| `--timeout` | milliseconds | 2000 | Display duration |
| `--poll-interval` | milliseconds | 200 | Daemon check interval |
| `--icon` | on, off | on | Show volume icon |
| `--percent` | on, off | on | Show percentage |

### Slider Styles

`smooth` (default) is a continuous, CSS-styled filled bar. The legacy
character styles render the level with text glyphs:

```
smooth   ▰▰▰▰▰▱▱▱▱▱  (continuous filled bar)
blocks   █████░░░░░
dots     ●●●●●○○○○○
line     ━━━━━─────
```

### System Tray

| Option | Default | Description |
|--------|---------|-------------|
| `--systray-icon` | off | Enable tray icon |
| `--tray-step` | 5 | Volume step per scroll |
| `--mixer` | pavucontrol | Mixer app for menu |

## Daemon Mode

The daemon monitors volume changes by polling at `--poll-interval`:

```bash
# More responsive (10 checks/second)
volbar --start-daemon --poll-interval 100

# Less CPU (2 checks/second)
volbar --start-daemon --poll-interval 500
```

Default 200ms works well for most setups.

## Themes

**Included:** default, catppuccin, cyberpunk, dracula, gruvbox, neon-green, nord, solarized-dark, tokyo-night, vibrant-blue, vibrant-brown, vibrant-green, vibrant-orange

```bash
# List available themes
volbar --list-themes      
# Preview all themes
volbar --test-themes      
# Test single theme
volbar --show --theme nord
```

**[system]** /usr/local/share/volbar/themes/

**[user]** ~/.config/volbar/themes/

### Auto Theme

Use `--theme auto` to pull colors from Mabox's conky wallpaper-color config
(`~/.config/conky/sysinfo_mbcolor.conkyrc`):

```bash
volbar --show --theme auto
volbar --start-daemon --theme auto
```

If the conky file isn't found, volbar falls back to the default theme with a
warning naming the path it checked.

**Note:** After changing wallpaper, restart the daemon to pick up new colors:

```bash
volbar --stop-daemon
volbar --start-daemon --theme auto
```

### Custom Themes

Create `~/.config/volbar/themes/mytheme.css`:

```css
#volbar-container {
    background-color: #1a1a1a;
    border: 2px solid #00ff00;
}

label#icon { color: #00ff00; }
label#slider { color: #00ff00; }                /* legacy character styles */
label#percentage { color: #ffffff; }

/* smooth slider (default) */
levelbar#slider trough { background-color: alpha(#00ff00, 0.25); }
levelbar#slider block.filled { background-color: #00ff00; }

/* Muted state */
label#icon.muted,
label#slider.muted,
label#percentage.muted { color: #ff0000; }
levelbar#slider.muted block.filled { background-color: #ff0000; }
```

Then use with: `volbar --show --theme mytheme`

## Openbox Integration

**Autostart** (`~/.config/openbox/autostart`):
```bash
volbar --start-daemon --placement top-right --theme auto &
```

**Keybindings** (`~/.config/openbox/rc.xml`):
```xml
<keybind key="XF86AudioRaiseVolume">
  <action name="Execute">
    <command>wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+</command>
  </action>
</keybind>

<keybind key="XF86AudioLowerVolume">
  <action name="Execute">
    <command>wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-</command>
  </action>
</keybind>

<keybind key="XF86AudioMute">
  <action name="Execute">
    <command>wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle</command>
  </action>
</keybind>
```

Replace `wpctl` with `pactl` for PulseAudio.

## Files

| Path | Description |
|------|-------------|
| `~/.config/volbar/themes/` | User themes |
| `/usr/local/share/volbar/themes/` | System themes |
| `~/.config/conky/sysinfo_mbcolor.conkyrc` | Mabox conky colors (auto theme) |
| `~/.cache/volbar.pid` | Daemon PID file |

## Help

```bash
# After installing
volbar --help
man volbar

# Before installing
man ./volbar.1
```

## License

Free software - do whatever you want with it.
