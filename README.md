# Volbar

Minimal X11 volume bar. Small, fast, themeable.

![volbar](https://img.shields.io/badge/version-1.2.0-blue)
![license](https://img.shields.io/badge/license-free-green)

## Features

- Minimal & fast GTK3 volume indicator
- Auto-detects audio backend (PipeWire/PulseAudio/ALSA)
- Daemon mode with configurable poll interval
- System tray support
- 13 included themes + CSS customization
- Multiple slider styles and placements

## Requirements

```bash
# Debian/Ubuntu
sudo apt install python3-gi gir1.2-gtk-3.0

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
| `--slider` | blocks, dots, line | blocks | Slider style |
| `--theme` | theme name | default | CSS theme |
| `--timeout` | milliseconds | 2000 | Display duration |
| `--poll-interval` | milliseconds | 200 | Daemon check interval |
| `--icon` | on, off | on | Show volume icon |
| `--percent` | on, off | on | Show percentage |

### Slider Styles

```
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
# List available themes. [root] or [user]
volbar --list-themes      
# Preview all themes in a slide show. Using default settings.
volbar --test-themes      
# Test single theme
volbar --show --theme nord
```
**[root]** Path: /usr/local/share/volbar/themes/

**[user]** Path: ~/.themes/volbar/

### Custom Themes

Create `~/.config/volbar/themes/mytheme.css`:

```css
#volbar-container {
    background-color: #1a1a1a;
    border: 2px solid #00ff00;
    border-radius: 8px;
}

label#icon { color: #00ff00; }
label#slider { color: #00ff00; }
label#percentage { color: #ffffff; }

/* Muted state */
label#icon.muted,
label#slider.muted,
label#percentage.muted { color: #ff0000; }
```

Then use with: `volbar --show --theme mytheme`

## Openbox Integration

**Autostart** (`~/.config/openbox/autostart`):
```bash
volbar --start-daemon --placement top-right --theme nord &
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
| `~/.cache/volbar.pid` | Daemon PID file |

## Help

```bash
volbar --help
man volbar
```

## License

Free software - do whatever you want with it.

## Author

Written by [musqz](https://github.com/musqz) with AI assistance _(claude)_
