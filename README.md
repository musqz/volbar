# Volbar

#### Work in process

        todo
         - add systray icon
         - icons style ?

Simple X11 volume bar. Tiny footprint, endless tweaking.

## Features

- Minimal & fast GTK3 volume indicator
- Auto-detects audio backend (PipeWire/PulseAudio/ALSA)
- Daemon mode for automatic display
- 12+ themes with CSS customization
- Multiple slider styles and placements
- poll-interval

## Installation

```bash
git clone https://github.com/musqz/volbar.git
cd volbar
chmod +x install.sh 
sudo ./install
```

```
# Set installation paths
BIN_DIR="$PREFIX/bin"
MAN_DIR="$PREFIX/share/man/man1"
THEME_DIR="$PREFIX/share/volbar/themes"

sudo ./install PREFIX=/usr/local
```

**Requirements:**

```bash
# Debian/Ubuntu
sudo apt install python3-gi gir1.2-gtk-3.0

# Arch Linux
sudo pacman -S python-gobject gtk3
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

## Daemon Mode Tips

**Poll Interval** - Controls how often the daemon checks for volume changes (default: 200ms)
```bash
# More responsive (checks 10x per second)
volbar --start-daemon --poll-interval 100

# Less CPU usage (checks 2x per second)
volbar --start-daemon --poll-interval 500
```

Lower values = instant feedback, slightly more CPU  
Higher values = delayed response, saves resources  

*Default 200ms works well for most users*

## Help / Man

```
volbar --help
man volbar
```

## Openbox Integration

**Add to `~/.config/openbox/autostart`:**

```bash
# Start volbar daemon
volbar --start-daemon --placement top-right --theme nord &
```

**Add to `~/.config/openbox/rc.xml` keybindings:**

```xml
<!-- Volume Up -->
<keybind key="XF86AudioRaiseVolume">
  <action name="Execute">
    <command>wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+</command>
  </action>
</keybind>

<!-- Volume Down -->
<keybind key="XF86AudioLowerVolume">
  <action name="Execute">
    <command>wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-</command>
  </action>
</keybind>

<!-- Mute Toggle -->
<keybind key="XF86AudioMute">
  <action name="Execute">
    <command>wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle</command>
  </action>
</keybind>
```

*Note: Daemon mode automatically shows the bar when volume changes. Use `pactl` if using PulseAudio instead of PipeWire.*

## Common Options

```bash
volbar --show --placement top-right --theme gruvbox
volbar --show --slider line --size large
volbar --start-daemon --placement bottom --timeout 3000
```

**Main Options:**
- `--size` small|medium|large (default: medium)
- `--placement` center|top|bottom|left|right|top-left|top-right|bottom-left|bottom-right (default: center)
- `--theme` [name] (default: default)
- `--slider` blocks|bar|dots|line|equals|hash|pipe|star|circle|diamond|triangle|arrow|square|bracket|paren (default: blocks)
- `--timeout` [ms] - Display duration (default: 2000)
- `--poll-interval` [ms] - Daemon check interval (default: 200)

**Commands:**
- `--list-themes` - Show available themes
- `--list-sliders` - Show slider styles
- `--test-themes` - Preview all themes

## Themes

**Included:** default, catppuccin, cyberpunk, dracula, gruvbox, neon-green, nord, solarized-dark, tokyo-night, vibrant-blue, vibrant-brown, vibrant-green, vibrant-orange

```bash
volbar --list-themes
volbar --test-themes
volbar --show --theme cyberpunk
```

### Create Custom Theme

Create `~/.themes/volbar/mytheme.css`:

```css
#volbar-container {
    background-color: #1a1a1a;
    border: 2px solid #00ff00;
    border-radius: 8px;
}

label#icon { color: #00ff00; }
label#slider { color: #00ff00; }
label#percentage { color: #ffffff; }

label#icon.muted,
label#slider.muted,
label#percentage.muted { color: #ff0000; }
```

Use: `volbar --show --theme mytheme`

## Sliders

Available slider styles:

      blocks          █████░░░░░
      bar             ■■■■■□□□□□
      dots            ●●●●●○○○○○
      line            ━━━━━─────
      equals          =====-----
      hash            #####·····
      pipe            |||||     
      star            ★★★★★☆☆☆☆☆
      circle          ◉◉◉◉◉◯◯◯◯◯
      diamond         ◆◆◆◆◆◇◇◇◇◇
      triangle        ▲▲▲▲▲△△△△△
      arrow           ▶▶▶▶▶▷▷▷▷▷
      square          ⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜
      bracket         [=====     ]
      paren           (─────     )
      bar-simple      ▌▌▌▌▌     

## License

Free software - do whatever you want with it.

## Author

Written by [musqz](https://github.com/musqz) with AI assistance.
