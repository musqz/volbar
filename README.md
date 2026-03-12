# Volbar

![Overview](images/volbar.jpg)

Simple X11 volume bar. Tiny footprint, highly customizable.

![volbar](https://img.shields.io/badge/version-1.2.0-blue)
![license](https://img.shields.io/badge/license-free-green)

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

##### Show volume bar once
```bash
volbar --show
```

##### Start daemon (auto-shows on volume changes)
```
volbar --start-daemon
```

##### Stopping the Daemon
```
volbar --stop-daemon
```
Always use `volbar --stop-daemon` to ensure proper cleanup.
Avoid `killall volbar`, as it may leave stale resources.

## Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `--size` | small, medium, large | medium | Window size |
| `--placement` | center, top, bottom, left, right, top-left, top-right, bottom-left, bottom-right | center | Screen position |
| `--slider` | blocks, dots, line | blocks | Slider style |
| `--theme` | theme name or `auto` | default | CSS theme |
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
# List available themes
volbar --list-themes      
# Preview all themes
volbar --test-themes      
# Test single theme
volbar --show --theme nord
```

**[system]** /usr/local/share/volbar/themes/

**[user]** ~/.config/volbar/themes/

### Auto Theme (Mabox)

On Mabox Linux, use `--theme auto` to match your wallpaper colors:

```bash
volbar --show --theme auto
volbar --start-daemon --theme auto
```

Colors are read from `'~/.config/conky/sysinfo_mbcolor.conkyrc`.

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
| `~/.config/mabox/jgobthemes/MBcolors.colorrc` | Mabox wallpaper colors |
| `~/.cache/volbar.pid` | Daemon PID file |

## Help

```bash
# After installing
volbar --help
man volbar

# Before installing
man ./volbar.1
```


