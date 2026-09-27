# Changelog

All notable changes to volbar are listed here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- `CHANGELOG.md` and an Arch/Mabox `PKGBUILD` in `packaging/`.

## [1.3.0] - 2026-09-27

### Added
- `--theme auto` follows wallpaper changes live: the daemon watches
  `~/.config/conky/sysinfo_mbcolor.conkyrc` and reloads its colors when
  Mabox's Colorizer rewrites it. No daemon restart needed.
- Smooth `levelbar` slider, now the default style (`--slider smooth`).
- Clear error messages for invalid `--size`, `--placement`, `--slider`
  and non-numeric `--timeout`, `--poll-interval`, `--tray-step`.

### Changed
- `version.txt` is the single source of the version; `install.sh` writes
  it into the installed script and man page.
- Only the window/container corners are un-rounded (left to picom); the
  smooth slider keeps its rounded ends.

### Removed
- pywal support (upstream archived in April 2024). `--theme auto` uses
  Mabox conky colors only.

### Fixed
- Tray scroll and mute now work with PulseAudio (`pactl`) and ALSA
  (`amixer`), not only PipeWire (`wpctl`).
- System themes are found under `/usr/share/volbar/themes` too, so
  `install.sh --prefix /usr` works.
- `--test-themes` no longer mixes styles from previously shown themes.
- GLib timeouts no longer repeat, and the daemon no longer prints a
  GLib-CRITICAL warning after hiding the bar.

## [1.2.0] - 2026-02-04

### Added
- `--theme auto`: generate the theme from Mabox conky wallpaper colors.

## [1.1.1] - 2026-01-19

### Changed
- Reduced to three character sliders (blocks, dots, line) and improved
  window sizing.

### Fixed
- `--stop-daemon` and hiding the bar over fullscreen windows.

## [1.1.0] - 2026-01-03

- First tagged release.

[Unreleased]: https://github.com/musqz/volbar/compare/v.1.3.0...HEAD
[1.3.0]: https://github.com/musqz/volbar/compare/v.1.2.0...v.1.3.0
[1.2.0]: https://github.com/musqz/volbar/compare/v.1.1.1...v.1.2.0
[1.1.1]: https://github.com/musqz/volbar/compare/v.1.1.0...v.1.1.1
[1.1.0]: https://github.com/musqz/volbar/releases/tag/v.1.1.0
