<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:02569B,100:005078&height=200&section=header&text=~/dotfiles&fontSize=60&fontColor=ffffff&animation=fadeIn&fontAlignY=38" alt="Dotfiles Banner"/>

<br/>

_Personal configuration of dotfiles for Arch Linux (Hyprland targeted)_

</div>

## 📸 Screenshots

![obraz](https://github.com/user-attachments/assets/cb3f9911-199b-44ae-8d86-e1385b79f877)
![obraz](https://github.com/user-attachments/assets/3b445614-ef1d-4ff2-a1d2-5c7908c4e234)
![obraz](https://github.com/user-attachments/assets/35855465-12c1-48fc-807d-d3f6d1e17499)
![obraz](https://github.com/user-attachments/assets/ab019299-e3f2-4f4a-b847-30c9ed226789)
![obraz](https://github.com/user-attachments/assets/09233ac4-37da-4964-92d2-55489796df99)
![obraz](https://github.com/user-attachments/assets/0206be83-c734-4be9-8688-f0368737e228)
![obraz](https://github.com/user-attachments/assets/18186e50-f173-4d90-b78f-46775afb0e1f)

## 🚀 Quick Installation

**Automated installer available!** Simply run:

```bash
git clone <your-repo-url>
cd hyprland-dotfiles
chmod +x install.sh
./install.sh
```

The installer will:
- Install all required packages for your distribution
- Create proper directory structure
- Backup existing configurations
- Fix all path issues
- Set up wallpapers and color schemes
- Configure all components properly
- **NEW**: Enable dynamic window coloring based on wallpaper colors

For detailed installation instructions, see [INSTALL.md](INSTALL.md)

## ✨ Key Features

### 🎨 Dynamic Window Coloring
- **Automatic color extraction** from wallpapers using Pywal
- **Material Design-inspired** window transparency and blur
- **Per-application opacity** settings for optimal visibility
- **Vibrancy effects** that adapt to your wallpaper
- **Enhanced blur** with configurable vibrancy, contrast, and brightness
- **Dim inactive windows** for better focus management

### 🖥️ Window Manager Features
- Beautiful animations with custom bezier curves
- Smart gaps and borders that respond to wallpaper colors
- Blur effects on transparent windows
- Dynamic border colors from wallpaper palette
- Custom opacity per application

## 📦 What's Included

- **Hyprland**: Modern Wayland compositor with beautiful animations
- **Waybar**: Customizable status bar with Pywal integration
- **Rofi**: Application launcher and power menu
- **Hyprpaper**: Wallpaper manager  
- **Hyprlock**: Screen locker with blur effects
- **Hypridle**: Idle management with coffee mode
- **Mako**: Notification daemon
- **Kitty**: Terminal emulator with transparency
- **Pywal**: Automatic color scheme generation
- **Cava**: Audio visualizer with custom shaders
- **Neovim**: Pre-configured with NvChad
- **Custom scripts**: Screenshot, power management, and more

## 📁 Complete File Structure

### Root Directory
```
.
├── install.sh              # Automated installation script
├── test-config.sh          # Configuration testing script
├── INSTALL.md              # Detailed installation guide
├── README.md               # This file
└── wallpapers/             # Collection of wallpapers
```

### 🎨 `cava/` - Audio Visualizer Configuration
Configuration for the CAVA audio visualizer with custom visual effects.

- **`config`** - Main CAVA configuration file
  - Audio input/output settings
  - Bar configuration and sensitivity
  - Color schemes (uses Pywal colors)
  
- **`shaders/`** - OpenGL shader effects for advanced visualizations
  - `bar_spectrum.frag` - Classic spectrum bar shader
  - `eye_of_phi.frag` - Golden ratio spiral visualization
  - `northern_lights.frag` - Aurora-style animation
  - `pass_through.vert` - Vertex shader passthrough
  - `spectrogram.frag` - Spectrogram visualization
  - `winamp_line_style_spectrum.frag` - Winamp-style line spectrum
  
- **`themes/`** - Color themes
  - `solarized_dark` - Solarized dark color scheme
  - `tricolor` - Three-color gradient scheme

### 🪟 `hypr/` - Hyprland Window Manager Configuration
Core configuration for the Hyprland compositor.

- **`hyprland.conf`** - Main Hyprland configuration
  - Monitor setup and workspace configuration
  - Window rules and animations
  - **Dynamic window coloring** with opacity and blur
  - Keybindings (see Keybindings section below)
  - Environment variables
  - Input device configuration
  - **Material Design window effects**
  - Per-application opacity rules
  - Vibrancy and blur enhancement settings
  
- **`hyprpaper.conf`** - Wallpaper daemon configuration
  - Wallpaper paths and preload settings
  - Multi-monitor wallpaper setup
  
- **`hyprlock.conf`** - Lock screen configuration
  - Lock screen appearance with blur
  - Time and user display
  - Input field styling with Pywal colors
  
- **`hypridle.conf`** - Idle management
  - Screen timeout settings
  - Lock screen triggers
  - Power management integration

#### `hypr/scripts/` - Utility Scripts
Custom bash scripts for enhanced functionality.

- **`autopywal.sh`** - Automatic Pywal color generation
  - Watches for wallpaper changes
  - Automatically regenerates color schemes
  - Updates all applications with new colors
  
- **`coffee_mode_status.sh`** - Coffee mode indicator
  - Returns current idle inhibitor status
  - JSON output for Waybar integration
  
- **`emoji_picker.sh`** - Emoji selector
  - Rofi-based emoji picker
  - Copies selected emoji to clipboard
  
- **`powermenu_pywal.sh`** - Power menu
  - Shutdown, reboot, logout, lock options
  - Styled with Pywal colors
  - Rofi-based interface
  
- **`screenshot.sh`** - Screenshot utility
  - Area selection
  - Full screen capture
  - Window capture
  - Saves to ~/Pictures/Screenshots
  - Clipboard integration
  
- **`toggle_idle.sh`** - Toggle idle management (Coffee mode)
  - Enable/disable screen timeout
  - Useful for watching videos or presentations
  
- **`toggle_power_profile.sh`** - Power profile switcher
  - Switch between performance, balanced, and power-save modes
  - Shows current profile in Waybar
  - Requires power-profiles-daemon

### 🎨 `kitty/` - Terminal Emulator
Configuration for the Kitty terminal emulator.

- **`kitty.conf`** - Main Kitty configuration
  - Font settings (JetBrains Mono Nerd Font)
  - **Transparency** (0.9 opacity for wallpaper blending)
  - Cursor trail effects
  - Window padding
  - Pywal color integration
  - **Blur support** for transparent background

### 🔔 `mako/` - Notification Daemon
Configuration for the Mako notification system.

- **`config`** - Notification appearance and behavior
  - Notification position and timeout
  - Styling with Pywal colors
  - Action buttons
  - Progress bar styling

### 📝 `nvim/` - Neovim Configuration
Complete Neovim setup based on NvChad with custom configurations.

- **`init.lua`** - Neovim entry point
  - Loads core configurations
  - Initializes plugin manager
  
- **`coc-settings.json`** - COC.nvim language server settings
  
- **`lazy-lock.json`** - Plugin version lock file

#### `nvim/lua/` - Lua Configuration Files
- **`autocmds.lua`** - Automatic commands and events
- **`chadrc.lua`** - NvChad configuration
- **`mappings.lua`** - Custom key mappings
- **`options.lua`** - Neovim options and settings

#### `nvim/lua/configs/` - Plugin Configurations
- **`compile_flags.txt`** - C/C++ compilation flags
- **`conform.lua`** - Code formatting configuration
- **`lazy.lua`** - Lazy.nvim plugin manager setup
- **`lspconfig.lua`** - Language Server Protocol configuration

#### `nvim/lua/plugins/` - Plugin Definitions
- **`init.lua`** - Plugin declarations and settings

### 🎨 `oh-my-zsh/` - Zsh Shell Theme
Custom Zsh prompt theme.

- **`custom_prompt.zsh-theme`** - Custom shell prompt
  - Git integration
  - Current directory display
  - Color customization

### 🚀 `rofi/` - Application Launcher
Configuration for Rofi application launcher and menus.

#### `rofi/themes/` - Rofi Themes
- **`powermenu-pywal.rasi`** - Power menu theme
  - Styled with Pywal colors
  - Rounded corners and transparency
  - Button layouts and hover effects

### 🎨 `wal/` - Pywal Configuration
Pywal color scheme templates.

#### `wal/templates/` - Color Templates
- **`colors-hyprland.conf`** - Hyprland color template
  - Extracts 16 colors from wallpaper
  - Defines variables for borders, backgrounds, etc.
  - **NEW**: Window tinting color variables
  - **NEW**: Dim color for inactive windows
  - Auto-generates on wallpaper change

### 🖼️ `wallpapers/` - Wallpaper Collection
Beautiful wallpapers for your desktop. Add your own wallpapers here!

The included wallpapers cover various styles:
- Nature and landscapes
- Abstract art
- Minimalist designs
- Anime/Gaming themes
- Photography

**Usage**: Place new wallpapers here and run:
```bash
wal -i ~/.local/share/wallpapers/your-wallpaper.jpg
```

### 📊 `waybar/` - Status Bar Configuration
Configuration for the Waybar status bar.

- **`config.jsonc`** - Waybar modules and behavior
  - Left: Date, time, workspaces, network
  - Center: Arch logo
  - Right: System tray, power profile, battery, temperature, audio, power menu
  - Module configurations (network, battery, audio, etc.)
  - Custom module scripts integration
  
- **`style.css`** - Waybar styling
  - **Dynamic colors from Pywal**
  - Transparency and blur effects
  - Module-specific styling
  - Workspace indicators
  - Hover effects
  - Battery state colors

## 🎯 Prerequisites (Auto-installed by script)

### Core Packages
- **Window Manager**: Hyprland ecosystem (hyprland, hyprpaper, hypridle, hyprlock)
- **Status Bar**: Waybar
- **Launcher**: Rofi, Wofi
- **Notifications**: Mako
- **Terminal**: Kitty
- **Screenshot**: Grim, Slurp
- **Clipboard**: wl-clipboard, cliphist
- **System Control**: brightnessctl, pamixer

### Additional Tools
- **Color Generation**: python-pywal (or python3-pywal)
- **Auth**: polkit-gnome, gnome-keyring
- **Desktop Portal**: xdg-desktop-portal-hyprland, xdg-desktop-portal-gtk
- **Theme**: qt6ct
- **Network**: network-manager-applet (nm-applet)
- **Bluetooth**: blueman
- **System Info**: fastfetch
- **Audio Visualizer**: cava
- **Power Management**: power-profiles-daemon (optional, for power profile switching)

### Fonts
- **Nerd Fonts**: ttf-nerd-fonts-symbols-mono (Arch) or nerd-fonts (other distros)
- **System Fonts**: noto-fonts, noto-fonts-emoji
- **Recommended**: JetBrains Mono Nerd Font (for terminal and code editors)

### Optional but Recommended
- **File Manager**: dolphin or thunar
- **Text Editor**: code (VS Code) or your preferred editor
- **Browser**: firefox or your preferred browser
- **Media Player**: spotify (for styled transparency)
- **Notes**: obsidian (if you use it)

## ⌨️ Key Bindings

### Window Management
- **Super + Q**: Open terminal (Kitty)
- **Super + S**: Application launcher (Rofi)
- **Super + A**: Close active window
- **Super + E**: File manager
- **Super + Z**: Toggle floating
- **Super + J**: Toggle split
- **Super + Return**: Fullscreen
- **Super + Shift + M**: Exit Hyprland

### Workspaces
- **Super + 1-9**: Switch to workspace 1-9
- **Super + Shift + 1-9**: Move window to workspace 1-9
- **Super + Tab**: Cycle through windows
- **Super + Ctrl + Arrows**: Move focus

### Window Manipulation
- **Super + Shift + Arrows**: Resize active window
- **Super + Alt + Arrows**: Move active window
- **Super + Shift + Period**: Swap with next window
- **Super + Shift + C**: Center window
- **Super + Mouse Left**: Move window
- **Super + Mouse Right**: Resize window

### Utilities
- **Super + X**: Power menu
- **Super + Shift + S**: Screenshot (area selection)
- **Super + V**: Clipboard history
- **Super + Period**: Emoji picker
- **Super + K**: Toggle idle/coffee mode
- **Super + I**: Network manager (nmtui)
- **Super + B**: Bluetooth manager

### Media Keys
- **XF86MonBrightnessUp/Down**: Adjust brightness
- **XF86AudioRaiseVolume/LowerVolume**: Volume control
- **XF86AudioMute**: Toggle mute

## 🎨 How Dynamic Window Coloring Works

The dynamic window coloring feature creates a **Material Design-inspired** look where windows automatically adapt to your wallpaper colors:

1. **Pywal** extracts a 16-color palette from your wallpaper
2. The colors are applied to:
   - Window borders (active and inactive)
   - Window backgrounds (through transparency)
   - Waybar modules
   - Terminal colors
   - Application themes
3. **Window transparency** (85-95% opacity) allows the wallpaper to show through
4. **Enhanced blur** with vibrancy creates depth and visual hierarchy
5. **Dim inactive windows** for better focus on active window
6. **Per-application opacity** ensures optimal visibility for different app types

### Customizing Window Colors

Edit `~/.config/hypr/hyprland.conf` to adjust:

```conf
decoration {
    active_opacity = 0.95      # Active window opacity (0.0-1.0)
    inactive_opacity = 0.88    # Inactive window opacity (0.0-1.0)
    
    blur {
        size = 3               # Blur radius
        passes = 5             # Blur quality (higher = better but slower)
        vibrancy = 0.1696      # Color vibrancy through blur
        contrast = 0.8916      # Contrast adjustment
        brightness = 0.8172    # Brightness adjustment
        noise = 0.0117         # Noise amount for texture
    }
    
    dim_inactive = true        # Dim inactive windows
    dim_strength = 0.12        # How much to dim (0.0-1.0)
}
```

### Per-Application Opacity

Customize opacity for specific applications in `hyprland.conf`:

```conf
windowrulev2 = opacity 0.95 0.88, class:^(kitty)$
windowrulev2 = opacity 0.92 0.85, class:^(code)$
# Format: opacity ACTIVE INACTIVE, class:REGEX
```

## 🎨 Customization

### Changing Wallpapers
1. Add wallpapers to `~/.local/share/wallpapers/`
2. Update `~/.config/hypr/hyprpaper.conf`:
   ```conf
   preload = ~/.local/share/wallpapers/your-wallpaper.jpg
   wallpaper = ,~/.local/share/wallpapers/your-wallpaper.jpg
   ```
3. Regenerate colors:
   ```bash
   wal -i ~/.local/share/wallpapers/your-wallpaper.jpg
   ```
4. Reload Hyprland: `Super + Shift + R` or restart Hyprland

### Adjusting Colors
Colors are automatically generated from wallpapers, but you can adjust:
- Saturation: Edit `autopywal.sh` and change `--saturate` value
- Manual colors: Edit `~/.cache/wal/colors-hyprland.conf` (regenerated on wallpaper change)

### Modifying Animations
Edit animation timings in `hyprland.conf`:
```conf
animation = windows, 1, 4.79, easeOutQuint
# Format: animation = NAME, ENABLED, SPEED, CURVE, STYLE
```

### Monitor Configuration
Update for your displays in `hyprland.conf`:
```conf
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
```

## 🔧 Troubleshooting

### Colors Not Updating
```bash
# Force reload Pywal
wal -R

# Restart Waybar
killall waybar && waybar &

# Reload Hyprland config
hyprctl reload
```

### Transparency/Blur Not Working
- Check if your GPU supports required OpenGL features
- Update graphics drivers
- Reduce blur passes if performance is slow
- Check window class with: `hyprctl clients`

### Scripts Not Working
```bash
# Make scripts executable
chmod +x ~/.config/hypr/scripts/*

# Check script paths in config files
grep -r "~/.config/hypr/scripts" ~/.config/
```

### Window Rules Not Applied
```bash
# Find window class
hyprctl clients

# Test window rule
hyprctl keyword windowrulev2 "opacity 0.9 0.8,class:YOUR_CLASS"
```

### Performance Issues
If you experience lag with blur/transparency:
1. Reduce blur passes: `passes = 2` (in decoration.blur)
2. Reduce blur size: `size = 2`
3. Disable vibrancy: `vibrancy = 0.0`
4. Lower opacity: Use higher values (less transparent)

### Installation Issues
- Ensure all dependencies are installed
- Check distribution-specific package names
- Some packages may not be available in older distributions
- Compile from source if necessary (Hyprland ecosystem)

## 📚 Configuration Files Location

After installation:
- **Configurations**: `~/.config/`
- **Wallpapers**: `~/.local/share/wallpapers/`
- **Color schemes**: `~/.cache/wal/`
- **Scripts**: `~/.config/hypr/scripts/`
- **Backups**: `~/.config/dotfiles_backup_*`

## 🔄 Updating

To update your dotfiles:
```bash
cd hyprland-dotfiles
git pull
./install.sh  # Re-run installer to update
```

**Note**: Your custom wallpapers and user-modified configs will be backed up.

## 🙏 Acknowledgments

This configuration is built on the shoulders of giants:

- **Hyprland Community** - For the amazing Wayland compositor
- **Pywal Project** - For automatic color generation
- **NvChad** - For the Neovim configuration framework
- **All open-source contributors** - Who make Linux customization possible

## 📝 Notes for Future Updates

### Adding New Applications
1. Install the application
2. Add window rules to `hyprland.conf` if transparency/opacity is needed
3. Add launcher entry to Rofi (if applicable)
4. Update this README with configuration details

### Adding New Scripts
1. Create script in `hypr/scripts/`
2. Make executable: `chmod +x hypr/scripts/your-script.sh`
3. Add keybinding to `hyprland.conf`
4. Document in this README

### Modifying Color Generation
1. Edit `wal/templates/colors-hyprland.conf` for new color variables
2. Update `hyprland.conf` to use the new variables
3. Regenerate colors: `wal -R`

### Testing Changes
```bash
# Test configuration without applying
./test-config.sh

# Check Hyprland config syntax
hyprctl reload

# Check for errors
journalctl -f -t Hyprland
```

## 💡 Tips and Tricks

### Better Performance
- Reduce animation speeds
- Lower blur quality
- Disable dim_inactive for better FPS
- Use `new_optimizations = true` in blur settings

### Better Visuals
- Use high-quality wallpapers (1920x1080 or higher)
- Adjust saturation in pywal (0.3-0.6 recommended)
- Fine-tune vibrancy for your monitor
- Use matching GTK themes

### Workflow Optimization
- Create custom workspaces for different tasks
- Use window rules to auto-place applications
- Bind frequently used apps to keys
- Utilize the clipboard history feature

## 📄 License

Feel free to use and modify these configurations for your personal use. Attribution appreciated but not required.

---

<div align="center">

Made with ❤️ for the Linux community

**[⬆ Back to Top](#)**

</div>
