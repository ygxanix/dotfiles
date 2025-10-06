# Hyprland Dotfiles Installation Guide

This repository contains a complete Hyprland desktop environment configuration with an automated installer script, featuring **dynamic window coloring** that adapts to your wallpaper.

## Features

- **Hyprland**: Modern Wayland compositor with beautiful animations
- **Dynamic Window Coloring**: Windows automatically adapt colors from your wallpaper using Material Design principles
- **Waybar**: Customizable status bar with system information
- **Rofi**: Application launcher and power menu
- **Hyprpaper**: Wallpaper manager
- **Hyprlock**: Screen locker with custom styling
- **Hypridle**: Idle management with coffee mode
- **Mako**: Notification daemon
- **Kitty**: GPU-accelerated terminal emulator with transparency
- **Pywal**: Automatic color scheme generation from wallpapers
- **Cava**: Audio visualizer with custom shaders
- **Neovim**: Pre-configured with NvChad
- **Custom scripts**: Screenshot, power management, emoji picker, and more

### NEW: Dynamic Window Coloring ✨

The setup now includes automatic window coloring that:
- Extracts colors from your wallpaper using Pywal
- Applies Material Design-inspired transparency and blur
- Adjusts vibrancy, contrast, and brightness for optimal viewing
- Provides per-application opacity settings
- Dims inactive windows for better focus
- Updates all colors when you change wallpapers

## Quick Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd hyprland-dotfiles
   ```

2. **Run the installer:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Log out and select Hyprland session from your display manager**

## Manual Installation

If you prefer to install manually or want to understand what the installer does:

### Prerequisites

#### Arch Linux / Manjaro
```bash
sudo pacman -Syu --needed \
    hyprland hyprpaper hypridle hyprlock \
    waybar rofi wofi mako kitty \
    grim slurp wl-clipboard cliphist \
    brightnessctl pamixer \
    python-pywal \
    polkit-gnome gnome-keyring \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt6ct \
    network-manager-applet \
    blueman \
    fastfetch \
    cava \
    ttf-nerd-fonts-symbols-mono \
    noto-fonts noto-fonts-emoji \
    jq \
    power-profiles-daemon
```

**Optional packages:**
```bash
# File managers
sudo pacman -S --needed dolphin thunar

# Text editors
sudo pacman -S --needed neovim code

# Browsers
sudo pacman -S --needed firefox chromium

# Media players
yay -S spotify  # requires AUR helper
```

#### Ubuntu / Debian (22.04+)
```bash
sudo apt update && sudo apt install -y \
    hyprland waybar rofi mako-notifier kitty \
    grim slurp wl-clipboard \
    brightnessctl pamixer \
    python3-pip \
    polkit-gnome gnome-keyring \
    xdg-desktop-portal-wlr \
    xdg-desktop-portal-gtk \
    qt6ct \
    network-manager-gnome \
    blueman \
    fastfetch \
    cava \
    fonts-noto fonts-noto-color-emoji \
    jq

# Install Pywal via pip
pip3 install --user pywal

# Note: On Debian/Ubuntu, you may need to install Hyprland from source
# or use a PPA as it's not in official repositories for older versions
```

**For Hyprland on Ubuntu/Debian:**
```bash
# Option 1: Build from source (recommended)
sudo apt install -y git build-essential cmake meson ninja-build \
    libwayland-dev libxkbcommon-dev libinput-dev libglvnd-dev \
    libpixman-1-dev libdrm-dev libgbm-dev

git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all
sudo make install

# Option 2: Use unofficial PPA (at your own risk)
# Search for community PPAs or use Nix package manager
```

#### Fedora
```bash
sudo dnf install -y \
    hyprland waybar rofi mako kitty \
    grim slurp wl-clipboard \
    brightnessctl pamixer \
    python3-pip \
    polkit-gnome gnome-keyring \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt6ct \
    NetworkManager-applet \
    blueman \
    fastfetch \
    cava \
    google-noto-fonts google-noto-emoji-fonts \
    jq \
    power-profiles-daemon

# Install Pywal via pip
pip3 install --user pywal

# Install Nerd Fonts
sudo dnf install -y 'google-noto*-fonts' fontawesome-fonts
```

**For Nerd Fonts on Fedora:**
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache -fv
```

#### OpenSUSE
```bash
sudo zypper install -y \
    hyprland waybar rofi mako kitty \
    grim slurp wl-clipboard \
    brightnessctl pamixer \
    python3-pip \
    polkit-gnome gnome-keyring \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt6ct \
    NetworkManager-applet \
    blueman \
    fastfetch \
    cava \
    noto-sans-fonts noto-emoji-fonts \
    jq

pip3 install --user pywal
```

### Font Installation (All Distributions)

**JetBrains Mono Nerd Font (Recommended):**
```bash
# Download and install
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache -fv
```

### Manual Configuration

1. **Create directories:**
   ```bash
   mkdir -p ~/.config/{hypr,waybar,kitty,mako,rofi,cava,fastfetch,wal}
   mkdir -p ~/.config/hypr/scripts
   mkdir -p ~/.config/wal/templates
   mkdir -p ~/.local/share/wallpapers
   mkdir -p ~/.cache/wal
   ```

2. **Copy configuration files:**
   ```bash
   cp -r hypr/* ~/.config/hypr/
   cp -r waybar/* ~/.config/waybar/
   cp -r kitty/* ~/.config/kitty/
   cp -r mako/* ~/.config/mako/
   cp -r rofi/* ~/.config/rofi/
   cp -r cava/* ~/.config/cava/
   cp -r fastfetch/* ~/.config/fastfetch/
   cp wallpapers/* ~/.local/share/wallpapers/
   cp -r wal/* ~/.config/wal/
   ```

3. **Make scripts executable:**
   ```bash
   chmod +x ~/.config/hypr/scripts/*
   ```

4. **Fix Waybar CSS path:**
   ```bash
   # Update the hardcoded path in waybar/style.css
   sed -i "s|/home/wolfie|$HOME|g" ~/.config/waybar/style.css
   ```

5. **Generate initial color scheme:**
   ```bash
   wal -i ~/.local/share/wallpapers/blue.jpg -n
   ```

6. **Start Hyprland:**
   - Log out and select Hyprland from your display manager
   - Or run `Hyprland` from a TTY

## Configuration Details

### Fixed and Enhanced Features

The installer and manual setup now include:

1. **Hyprpaper**: Updated wallpaper paths from hardcoded user directories to `~/.local/share/wallpapers/`
2. **Hyprlock**: Lock screen with proper wallpaper paths and blur effects
3. **Rofi**: Complete theme file for the power menu with Pywal integration
4. **Waybar**: Fixed hardcoded home directory paths
5. **Scripts**: All scripts use proper home directory references
6. **Dynamic Window Coloring**: NEW feature with Material Design-inspired effects

### Dynamic Window Coloring Details

The window coloring system works through several components:

1. **Pywal Template** (`wal/templates/colors-hyprland.conf`)
   - Extracts 16 colors from wallpaper
   - Generates tinting variables
   - Creates dim colors for inactive windows

2. **Hyprland Configuration** (`hypr/hyprland.conf`)
   - Active opacity: 0.95 (95% visible)
   - Inactive opacity: 0.88 (88% visible)
   - Enhanced blur with 5 passes
   - Vibrancy: 0.1696 for color saturation
   - Contrast: 0.8916 for better readability
   - Brightness: 0.8172 for optimal viewing
   - Per-application opacity rules

3. **Automatic Updates**
   - Colors regenerate when wallpaper changes
   - All applications update automatically
   - Terminal, Waybar, Rofi all sync colors

### Key Bindings

- **Super + Q**: Open terminal (Kitty)
- **Super + S**: Application launcher (Rofi)
- **Super + A**: Close active window
- **Super + E**: File manager
- **Super + X**: Power menu
- **Super + Shift + S**: Screenshot area
- **Super + V**: Clipboard history
- **Super + Period**: Emoji picker
- **Super + K**: Toggle idle/coffee mode
- **Super + I**: Network manager
- **Super + B**: Bluetooth manager
- **Super + 1-9**: Switch workspaces
- **Super + Shift + 1-9**: Move window to workspace
- **Super + Tab**: Cycle windows
- **Super + Return**: Fullscreen
- **Media Keys**: Brightness and volume control

### File Locations

- **Configurations**: `~/.config/`
- **Wallpapers**: `~/.local/share/wallpapers/`
- **Color schemes**: `~/.cache/wal/`
- **Scripts**: `~/.config/hypr/scripts/`

### Customization

#### Wallpapers
Add your wallpapers to `~/.local/share/wallpapers/` and update:
- `~/.config/hypr/hyprpaper.conf` for desktop wallpaper
- `~/.config/hypr/hyprlock.conf` for lock screen wallpaper

Then regenerate colors:
```bash
wal -i ~/.local/share/wallpapers/your-wallpaper.jpg
```

The window colors will automatically update!

#### Window Opacity and Blur
Edit `~/.config/hypr/hyprland.conf`:

```conf
decoration {
    active_opacity = 0.95      # Adjust for active windows (0.0-1.0)
    inactive_opacity = 0.88    # Adjust for inactive windows (0.0-1.0)
    
    blur {
        enabled = true
        size = 3               # Blur radius (higher = more blur)
        passes = 5             # Blur quality (higher = better quality, slower)
        vibrancy = 0.1696      # Color vibrancy (0.0-1.0)
        contrast = 0.8916      # Contrast adjustment (0.0-2.0)
        brightness = 0.8172    # Brightness adjustment (0.0-2.0)
        noise = 0.0117         # Noise amount for texture
    }
    
    dim_inactive = true        # Dim inactive windows
    dim_strength = 0.12        # Dimming amount (0.0-1.0)
}
```

#### Per-Application Opacity
Add custom opacity for specific applications:

```conf
# Format: windowrulev2 = opacity ACTIVE INACTIVE, class:REGEX
windowrulev2 = opacity 0.95 0.88, class:^(kitty)$
windowrulev2 = opacity 0.92 0.85, class:^(code)$
windowrulev2 = opacity 0.90 0.83, class:^(firefox)$
```

To find application class names:
```bash
hyprctl clients | grep class
```

#### Colors
The configuration uses Pywal for automatic color generation. Colors are applied to:
- Hyprland borders and UI
- Window backgrounds (through transparency)
- Waybar styling
- Terminal colors
- Rofi themes
- Application colors

Adjust saturation:
```bash
# Edit autopywal.sh and change --saturate value
wal -i ~/wallpaper.jpg --saturate 0.5
```

#### Monitors
Update monitor configuration in `~/.config/hypr/hyprland.conf`:
```conf
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
# Format: monitor = NAME, RESOLUTION@REFRESH, POSITION, SCALE
```

List available monitors:
```bash
hyprctl monitors
```

## Troubleshooting

### Common Issues

1. **Hyprland won't start**
   - Check if all dependencies are installed
   - Verify GPU drivers are up to date
   - Check logs: `journalctl -f -t Hyprland`

2. **No wallpaper**
   - Ensure wallpaper exists at the specified path
   - Check hyprpaper is running: `ps aux | grep hyprpaper`
   - Restart hyprpaper: `killall hyprpaper && hyprpaper &`

3. **Scripts not working**
   - Verify scripts are executable: `ls -la ~/.config/hypr/scripts/`
   - Make executable: `chmod +x ~/.config/hypr/scripts/*`
   - Check script paths in config files

4. **Colors not applied**
   - Run `wal -R` to restore colors
   - Check if Pywal cache exists: `ls ~/.cache/wal/`
   - Regenerate colors: `wal -i ~/wallpaper.jpg`

5. **Transparency/Blur not working**
   - Verify GPU supports required OpenGL features
   - Update graphics drivers
   - Check if blur is enabled in `hyprland.conf`
   - Reduce blur passes if performance is slow

6. **Window rules not applied**
   - Find correct window class: `hyprctl clients`
   - Test rule manually: `hyprctl keyword windowrulev2 "opacity 0.9 0.8,class:YOUR_CLASS"`
   - Reload config: `hyprctl reload`

7. **Waybar not showing colors**
   - Check CSS path is correct (not hardcoded)
   - Verify Pywal generated Waybar colors: `ls ~/.cache/wal/colors-waybar.css`
   - Restart Waybar: `killall waybar && waybar &`

8. **Power profile switching not working**
   - Install power-profiles-daemon: `sudo pacman -S power-profiles-daemon`
   - Enable service: `sudo systemctl enable --now power-profiles-daemon`
   - Check status: `powerprofilesctl`

### Performance Issues

If you experience lag with blur and transparency:

1. **Reduce blur quality:**
   ```conf
   blur {
       size = 2        # Reduce from 3
       passes = 2      # Reduce from 5
   }
   ```

2. **Disable effects:**
   ```conf
   dim_inactive = false
   vibrancy = 0.0
   ```

3. **Increase opacity (less transparency):**
   ```conf
   active_opacity = 1.0
   inactive_opacity = 0.95
   ```

4. **Check GPU usage:**
   ```bash
   # For NVIDIA
   nvidia-smi
   
   # For AMD
   radeontop
   
   # For Intel
   intel_gpu_top
   ```

### Logs

Check Hyprland logs:
```bash
# Real-time logs
journalctl -f -t Hyprland

# Last session logs
journalctl -b -t Hyprland

# Specific errors
journalctl -p err -t Hyprland
```

Check Waybar logs:
```bash
# Run in terminal to see output
killall waybar
waybar
```

### Reset Configuration

If something goes wrong, you can restore from backup:
```bash
# List backups
ls -la ~/.config/dotfiles_backup_*

# Restore from backup
cp -r ~/.config/dotfiles_backup_TIMESTAMP/hypr ~/.config/

# Or remove and reinstall
rm -rf ~/.config/hypr
./install.sh
```

## Additional Packages

### Development Tools
```bash
# Arch/Manjaro
sudo pacman -S git base-devel cmake ninja gcc

# Ubuntu/Debian
sudo apt install git build-essential cmake ninja-build

# Fedora
sudo dnf groupinstall "Development Tools"
sudo dnf install cmake ninja-build
```

### Media Codecs
```bash
# Arch/Manjaro
sudo pacman -S ffmpeg gstreamer gst-plugins-good gst-plugins-bad gst-plugins-ugly

# Ubuntu/Debian
sudo apt install ffmpeg gstreamer1.0-plugins-good gstreamer1.0-plugins-bad

# Fedora
sudo dnf install ffmpeg gstreamer1-plugins-good gstreamer1-plugins-bad-free
```

### Graphics Drivers

**NVIDIA:**
```bash
# Arch/Manjaro
sudo pacman -S nvidia nvidia-utils

# Ubuntu/Debian
sudo apt install nvidia-driver-535  # or latest version

# Fedora
sudo dnf install akmod-nvidia
```

**AMD:**
```bash
# Usually included in kernel
# Install Vulkan support
sudo pacman -S vulkan-radeon lib32-vulkan-radeon  # Arch
sudo apt install mesa-vulkan-drivers  # Ubuntu
```

**Intel:**
```bash
# Usually included
# Install Vulkan support
sudo pacman -S vulkan-intel lib32-vulkan-intel  # Arch
sudo apt install mesa-vulkan-drivers  # Ubuntu
```

## Post-Installation

### Verify Installation
```bash
# Check Hyprland version
hyprctl version

# Check if all services are running
ps aux | grep -E "waybar|hyprpaper|mako|hypridle"

# Check Pywal installation
wal --version

# Test window rules
hyprctl clients
```

### First-Time Setup

1. **Set your wallpaper:**
   ```bash
   cp /path/to/your/wallpaper.jpg ~/.local/share/wallpapers/
   wal -i ~/.local/share/wallpapers/wallpaper.jpg
   ```

2. **Update hyprpaper.conf:**
   ```bash
   nano ~/.config/hypr/hyprpaper.conf
   # Change the wallpaper path
   ```

3. **Reload Hyprland:**
   ```bash
   hyprctl reload
   ```

4. **Test features:**
   - Take a screenshot: Super + Shift + S
   - Open power menu: Super + X
   - Check clipboard history: Super + V
   - Toggle coffee mode: Super + K

### Recommended Additional Software

- **File Manager**: dolphin, thunar, nautilus
- **Text Editor**: neovim, code (VS Code)
- **Browser**: firefox, chromium, brave
- **Media Player**: vlc, mpv
- **Image Viewer**: imv, feh
- **PDF Viewer**: zathura, evince
- **Notes**: obsidian, joplin
- **Communication**: discord, slack
- **Music**: spotify, cmus

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Hyprland documentation: https://hyprland.org/
3. Check component-specific documentation:
   - Waybar: https://github.com/Alexays/Waybar
   - Rofi: https://github.com/davatorium/rofi
   - Pywal: https://github.com/dylanaraps/pywal
4. Search existing issues in this repository
5. Create a new issue with:
   - Your distribution and version
   - Output of `hyprctl version`
   - Relevant log excerpts
   - Steps to reproduce

## Credits

This configuration includes:
- Hyprland community configurations
- Waybar themes and modules
- Pywal integration for dynamic theming
- Custom scripts for enhanced functionality
- Material Design-inspired window effects
- Community contributions and feedback

Special thanks to:
- The Hyprland development team
- Pywal creator and contributors
- All open-source projects that make this possible
