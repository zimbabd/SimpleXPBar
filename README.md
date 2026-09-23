# SimpleXPBar

SimpleXPBar is a lightweight World of Warcraft 3.3.5a addon that displays current XP, XP percentage, session XP per hour, and an estimated time to level.

## Features

- Blizzard-style XP bar with 20 visual segments.
- Session XP/hour tracking.
- Estimated time to level based on the current session rate.
- Draggable and lockable panel.
- Custom `SXPB.tga` minimap icon.
- Left-click minimap toggle.
- Right-click minimap menu with quick controls.
- Panel and text scaling from `0.5` to `1.5` in `0.1` steps.
- Account-wide panel position and lock state.
- Character-specific visibility, panel scale, and text scale.
- Saved settings restored after reload or login.

## Slash Commands

Commands are available through `/sxp` and `/simplexp`.

| Command | Description |
| :--- | :--- |
| `/sxp lock` | Lock or unlock the panel for dragging |
| `/sxp show` | Show the XP bar for the current character |
| `/sxp hide` | Hide the XP bar for the current character |
| `/sxp toggle` | Toggle XP bar visibility |
| `/sxp reset` | Reset the panel position to the top center |
| `/sxp scale 1.0` | Set the panel scale directly |
| `/sxp scale +0.1` | Increase the panel scale by `0.1` |
| `/sxp scale -0.1` | Decrease the panel scale by `0.1` |
| `/sxp textscale 1.0` | Set the text scale directly |
| `/sxp textscale +0.1` | Increase the text scale by `0.1` |
| `/sxp textscale -0.1` | Decrease the text scale by `0.1` |

Scale values are clamped to the `0.5`-`1.5` range. The default scale is `1.0`.

## Minimap Controls

- Left click the `SXPB.tga` icon to show or hide the XP bar.
- Right click the icon to open the command menu.
- Open `Size` in the menu to reset to `100%` or increase/decrease the panel by `0.1`.

## Saved Settings

The addon uses two WoW SavedVariables tables:

- `SimpleXPBarDB`: account-wide panel position, lock state, and minimap icon position.
- `SimpleXPBarCharDB`: per-character visibility, panel scale, and text scale.

This allows the layout to remain consistent across characters while each character can independently show or hide the bar and use its own scale.

## Installation

1. Place the `SimpleXPBar` folder in `World of Warcraft\Interface\AddOns\`.
2. Make sure the folder contains `SimpleXPBar.toc`, `SimpleXPBar.lua`, `embeds.xml`, the `lib` folder, and `SXPB.tga`.
3. Enable the addon and use `/reload` after installation or updates.

## Compatibility

- World of Warcraft 3.3.5a / Wrath of the Lich King.
- Interface version: `30300`.

## Author

zimbabd
