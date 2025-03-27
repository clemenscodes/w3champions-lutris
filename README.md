# W3Champions Lutris Installer

Installs **WebView2**, **Battle.net**, and **W3Champions** for Warcraft III.  
**Proton-GE-9-26** is recommended for optimal performance.

---

## Dependencies

- Proton-GE-9-26: [Repository](https://github.com/GloriousEggroll/proton-ge-custom)
- Vulkan drivers: [Installation guide](https://github.com/lutris/lutris/wiki/Installing-drivers)
- Battle.Net troubleshooting: [Common issues](https://github.com/lutris/lutris/wiki/Game:-Blizzard-App)

---

## Installation Steps

1. **Create Wine prefix**: A 64-bit Wine prefix is auto-created.
2. **Install WebView2**: Required for W3Champions functionality.
3. **Set Registry Key**: Forces WebView2 compatibility with Windows 7.
4. **Install Battle.net**: Launches the Battle.net installer.
5. **Install W3Champions**: Installs W3Champions via MSI package.

---

## Post-Install Instructions

1. Launch **Battle.net** and log in.
2. Install/run **Warcraft III** through Battle.net.
3. **Keep Battle.net running** before launching W3Champions.

---

## Configuration Tips

### Window Modes (Edit game settings in Lutris)

- Fullscreen: `-windowmode fullscreen`
- Windowed: `-windowmode windowed`

Full command-line options: [Patch Notes](https://us.forums.blizzard.com/en/warcraft3/t/1-31-0-patch-notes/5721)

---

## Notes

- Lag issues? Toggle between window modes above.
