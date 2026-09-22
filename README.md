# SimpleXPBar

**SimpleXPBar** is a lightweight and high-performance addon for World of Warcraft (WoW 3.3.5a / Classic) designed to track experience progression, real-time **Session XP/Hour statistics**, and estimated Time to Level (TTL).

The interface features a classic Blizzard-style layout with 20 distinct visual segments and full positioning customizability.

---

## 🌟 Key Features

* **Accurate Session XP/Hour:** Displays a stable and reliable average leveling speed without violent spikes from single mob kills.
* **Time to Level (TTL) Projection:** Calculates the remaining time required to reach your next level based on your current session rate.
* **Blizzard-Style Segmentation:** Features 20 clean dividers (each representing 5% XP), matching the default Blizzard interface feel.
* **Drag and Drop Positioning:** Effortlessly move the bar anywhere on your screen using your mouse.
* **Saved Settings:** Frame location, lock state, and visibility options automatically persist across game restarts.
* **Minimal Resource Footprint:** Built on an optimized Ace3 structure using safe `C_Timer` loops for minimal CPU/memory impact.

---

## 🖥️ Layout Preview

<img width="989" height="63" alt="WoWScrnShot_092226_232631 — копия" src="https://github.com/user-attachments/assets/a584786f-2365-42f6-9b19-cd10025316a7" />


---

## 🛠️ Slash Commands

Control the addon using either `/sxp` or `/simplexp` in the in-game chat:

| Command | Description |
| :--- | :--- |
| `/sxp lock` | Lock or unlock the bar (enables/disables mouse dragging) |
| `/sxp show` | Display the experience bar |
| `/sxp hide` | Hide the experience bar |
| `/sxp toggle` | Toggle bar visibility (show/hide) |
| `/sxp reset` | Reset the bar position to the top-center of the screen |

---

## 📥 Installation

1. Download or extract the `SimpleXPBar` folder.
2. Place the folder into your WoW client directory:  
   `World of Warcraft\_retail_\Interface\AddOns\`  
   *(or for 3.3.5a / Classic)*:  
   `World of Warcraft\Interface\AddOns\`
3. Ensure the folder contains the following files:
   * `SimpleXPBar.toc`
   * `SimpleXPBar.lua`
   * `embeds.xml`
4. Launch or reload your game using `/reload`.

---

## 👨‍💻 Author Info

* **Author:** zimbabd
* **Version:** 1.0
* **Interface Compatibility:** WoW 3.3.5a (Wrath of the Lich King)
