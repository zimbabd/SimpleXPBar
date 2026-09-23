# Changelog

## v1.1 - Current

### Added

- Added `SXPB.tga` minimap icon through `LibDataBroker-1.1` and `LibDBIcon-1.0`.
- Added left-click minimap toggle.
- Added right-click minimap command menu.
- Added nested `Size` menu with `Default (100%)`, `Increase (+0.1)`, and `Decrease (-0.1)`.
- Added panel scale command: `/sxp scale <value>`.
- Added text scale command: `/sxp textscale <value>`.
- Added per-character visibility, panel scale, and text scale settings.
- Added account-wide panel position persistence.

### Changed

- Scale values are limited to `0.5`-`1.5` and rounded to `0.1` steps.
- Unsigned scale values set an exact size, for example `/sxp scale 1.0`.
- Signed scale values adjust the current size, for example `/sxp scale +0.1`.
- Replaced `C_Timer.NewTicker` with a 3.3.5-compatible `OnUpdate` timer.
- Translated addon-facing messages and command help to English.

### Fixed

- Fixed addon startup on WoW 3.3.5 clients where `C_Timer.NewTicker` is unavailable.
- Fixed scale settings being shared between characters.

## v1.0

### Added

- Added the initial draggable Blizzard-style XP bar.
- Added current XP, XP percentage, session XP/hour, and time-to-level display.
- Added `/sxp` and `/simplexp` commands for locking, visibility, and position reset.
- Added persistent account-wide layout settings.

