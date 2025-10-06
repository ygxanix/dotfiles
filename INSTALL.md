# Hyprland Dotfiles Installation Guide

This repository contains a complete Hyprland desktop environment configuration with an automated installer script.

## Features

- **Hyprland**: Modern Wayland compositor with beautiful animations
- **Waybar**: Customizable status bar with system information
- **Rofi**: Application launcher and power menu
- **Hyprpaper**: Wallpaper manager
- **Hyprlock**: Screen locker with custom styling
- **Hypridle**: Idle management
- **Mako**: Notification daemon
- **Kitty**: GPU-accelerated terminal emulator
- **Pywal**: Automatic color scheme generation from wallpapers
- **Custom scripts**: Screenshot, power management, and more

## Quick Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd hyprland-dotfiles
   ```

2. **Run the installer:**
   ```bash
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
    noto-fonts noto-fonts-emoji
```

#### Ubuntu / Debian
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
    fonts-noto fonts-noto-color-emoji

pip3 install --user pywal
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
    google-noto-fonts google-noto-emoji-fonts

pip3 install --user pywal
```

### Manual Configuration

1. **Create directories:**
   ```bash
   mkdir -p ~/.config/{hypr,waybar,kitty,mako,rofi,cava,fastfetch}
   mkdir -p ~/.config/hypr/scripts
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

4. **Generate initial color scheme:**
   ```bash
   wal -i ~/.local/share/wallpapers/blue.jpg -n
   ```

## Configuration Details

### Fixed Issues

The installer fixes several path issues found in the original configuration:

1. **Hyprpaper**: Updated wallpaper paths from hardcoded user directories to `~/.local/share/wallpapers/`
2. **Hyprlock**: Created missing configuration file with proper wallpaper paths
3. **Rofi**: Added missing theme file for the power menu
4. **Scripts**: Ensured all script paths use proper home directory references

### Key Bindings

- **Super + Q**: Open terminal (Kitty)
- **Super + S**: Application launcher (Rofi)
- **Super + A**: Close active window
- **Super + E**: File manager
- **Super + X**: Power menu
- **Super + Shift + S**: Screenshot area
- **Super + V**: Clipboard history
- **Super + K**: Toggle idle mode
- **Super + 1-9**: Switch workspaces
- **Super + Shift + 1-9**: Move window to workspace

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

#### Colors
The configuration uses Pywal for automatic color generation. Colors are applied to:
- Hyprland borders and UI
- Waybar styling
- Terminal colors
- Rofi themes

#### Monitors
Update monitor configuration in `~/.config/hypr/hyprland.conf`:
```
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
```

## Troubleshooting

### Common Issues

1. **Hyprland won't start**: Check if all dependencies are installed
2. **No wallpaper**: Ensure wallpaper exists at the specified path
3. **Scripts not working**: Verify scripts are executable (`chmod +x`)
4. **Colors not applied**: Run `wal -R` to restore colors

### Logs
Check Hyprland logs:
```bash
journalctl -f -t Hyprland
```

### Reset Configuration
If something goes wrong, you can restore from backup:
```bash
# Backups are created in ~/.config/dotfiles_backup_*
cp -r ~/.config/dotfiles_backup_*/hypr ~/.config/
```

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Hyprland documentation: https://hyprland.org/
3. Check component-specific documentation for Waybar, Rofi, etc.

## Credits

This configuration includes:
- Hyprland community configurations
- Waybar themes and modules
- Pywal integration
- Custom scripts for enhanced functionality