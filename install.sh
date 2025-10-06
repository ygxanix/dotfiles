#!/bin/bash

# Hyprland Dotfiles Installer Script
# This script installs and configures Hyprland with all necessary dependencies

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect package manager
detect_package_manager() {
    if command_exists pacman; then
        echo "pacman"
    elif command_exists apt; then
        echo "apt"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists zypper; then
        echo "zypper"
    else
        print_error "No supported package manager found!"
        exit 1
    fi
}

# Function to install packages based on distribution
install_packages() {
    local pm=$(detect_package_manager)
    print_status "Detected package manager: $pm"
    
    case $pm in
        "pacman")
            print_status "Installing packages for Arch Linux..."
            sudo pacman -Syu --needed --noconfirm \
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
            ;;
        "apt")
            print_status "Installing packages for Ubuntu/Debian..."
            sudo apt update
            sudo apt install -y \
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
            
            # Install pywal via pip
            pip3 install --user pywal
            
            # Note: hyprpaper, hypridle, hyprlock may need to be compiled from source on Ubuntu
            print_warning "Some Hyprland components may need manual compilation on Ubuntu/Debian"
            ;;
        "dnf")
            print_status "Installing packages for Fedora..."
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
            
            # Install pywal via pip
            pip3 install --user pywal
            ;;
        *)
            print_error "Unsupported package manager: $pm"
            exit 1
            ;;
    esac
}

# Function to create necessary directories
create_directories() {
    print_status "Creating configuration directories..."
    
    mkdir -p ~/.config/{hypr,waybar,kitty,mako,rofi,cava,fastfetch}
    mkdir -p ~/.config/hypr/scripts
    mkdir -p ~/.local/share/wallpapers
    mkdir -p ~/.cache/wal
    
    print_success "Directories created successfully"
}

# Function to backup existing configurations
backup_configs() {
    print_status "Backing up existing configurations..."
    
    local backup_dir="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    for dir in hypr waybar kitty mako rofi cava fastfetch; do
        if [ -d "$HOME/.config/$dir" ]; then
            print_status "Backing up $dir configuration..."
            cp -r "$HOME/.config/$dir" "$backup_dir/"
        fi
    done
    
    if [ "$(ls -A $backup_dir 2>/dev/null)" ]; then
        print_success "Backup created at: $backup_dir"
    else
        rmdir "$backup_dir"
        print_status "No existing configurations to backup"
    fi
}

# Function to install dotfiles
install_dotfiles() {
    print_status "Installing dotfiles..."
    
    # Copy configuration files
    cp -r hypr/* ~/.config/hypr/
    cp -r waybar/* ~/.config/waybar/
    cp -r kitty/* ~/.config/kitty/
    cp -r mako/* ~/.config/mako/
    cp -r cava/* ~/.config/cava/
    cp -r fastfetch/* ~/.config/fastfetch/
    
    # Copy wallpapers
    cp wallpapers/* ~/.local/share/wallpapers/
    
    # Copy wal templates
    mkdir -p ~/.config/wal/templates
    cp wal/templates/* ~/.config/wal/templates/
    
    # Make scripts executable
    chmod +x ~/.config/hypr/scripts/*
    
    print_success "Dotfiles installed successfully"
}

# Function to create missing Hyprlock configuration
create_hyprlock_config() {
    print_status "Creating Hyprlock configuration..."
    
    cat > ~/.config/hypr/hyprlock.conf << 'EOF'
# Hyprlock Configuration

general {
    disable_loading_bar = true
    grace = 300
    hide_cursor = true
    no_fade_in = false
}

background {
    monitor =
    path = ~/.local/share/wallpapers/blue.jpg
    blur_passes = 3
    blur_size = 8
}

input-field {
    monitor =
    size = 200, 50
    position = 0, -80
    dots_center = true
    fade_on_empty = false
    font_color = rgb(202, 211, 245)
    inner_color = rgb(91, 96, 120)
    outer_color = rgb(24, 25, 38)
    outline_thickness = 5
    placeholder_text = <span foreground="##cad3f5">Password...</span>
    shadow_passes = 2
}

label {
    monitor =
    text = cmd[update:1000] echo "$TIME"
    color = rgb(200, 200, 200)
    font_size = 55
    font_family = Noto Sans
    position = -100, -40
    halign = right
    valign = bottom
    shadow_passes = 5
    shadow_size = 10
}

label {
    monitor =
    text = $USER
    color = rgb(200, 200, 200)
    font_size = 20
    font_family = Noto Sans
    position = -100, 160
    halign = right
    valign = bottom
    shadow_passes = 5
    shadow_size = 10
}

image {
    monitor =
    path = ~/.config/fastfetch/wolf.png
    size = 280
    rounding = -1
    border_size = 4
    border_color = rgb(221, 221, 221)
    rotate = 0
    reload_time = -1
    reload_cmd = 
    position = 0, 200
    halign = center
    valign = center
}
EOF
    
    print_success "Hyprlock configuration created"
}

# Function to create Rofi theme
create_rofi_theme() {
    print_status "Creating Rofi theme..."
    
    mkdir -p ~/.config/rofi/themes
    
    cat > ~/.config/rofi/themes/powermenu-pywal.rasi << 'EOF'
* {
    background-color: transparent;
    text-color: @foreground;
    margin: 0px;
    padding: 0px;
    spacing: 0px;
}

window {
    location: center;
    width: 480;
    border-radius: 24px;
    background-color: @background;
    border: 2px;
    border-color: @selected;
}

mainbox {
    padding: 12px;
}

listview {
    background-color: transparent;
    margin: 0px 0px 0px 0px;
    spacing: 5px;
    cycle: true;
    dynamic: true;
    layout: vertical;
}

element {
    background-color: transparent;
    text-color: @foreground;
    orientation: horizontal;
    border-radius: 12px;
    padding: 6px 6px 6px 6px;
}

element-text {
    background-color: transparent;
    text-color: inherit;
    expand: true;
    horizontal-align: 0.5;
    vertical-align: 0.5;
    margin: 2px 0px 2px 2px;
}

element normal.urgent,
element alternate.urgent {
    background-color: @urgent;
}

element normal.active,
element alternate.active {
    background-color: @background-alt;
    color: @foreground;
}

element selected {
    background-color: @selected;
    text-color: @foreground;
    border: 0px;
    border-radius: 12px;
    border-color: @border;
}

element selected.urgent {
    background-color: @urgent;
}

element selected.active {
    background-color: @background-alt;
    color: @foreground;
}
EOF
    
    print_success "Rofi theme created"
}

# Function to fix configuration paths
fix_config_paths() {
    print_status "Fixing configuration paths..."
    
    # Fix Hyprpaper configuration
    local default_wallpaper="$HOME/.local/share/wallpapers/blue.jpg"
    
    cat > ~/.config/hypr/hyprpaper.conf << EOF
# ~/.config/hypr/hyprpaper.conf

preload = $default_wallpaper

wallpaper = ,$default_wallpaper

splash = false
ipc = off
EOF
    
    # Update Hyprland config to use correct paths
    sed -i "s|~/.config/hypr/scripts/|$HOME/.config/hypr/scripts/|g" ~/.config/hypr/hyprland.conf
    sed -i "s|~/.config/rofi/themes/powermenu-pywal.rasi|$HOME/.config/rofi/themes/powermenu-pywal.rasi|g" ~/.config/hypr/scripts/powermenu_pywal.sh
    
    # Update Waybar config paths
    sed -i "s|~/.config/hypr/scripts/|$HOME/.config/hypr/scripts/|g" ~/.config/waybar/config.jsonc
    
    print_success "Configuration paths fixed"
}

# Function to setup pywal
setup_pywal() {
    print_status "Setting up pywal with default wallpaper..."
    
    # Generate color scheme from default wallpaper
    if command_exists wal; then
        wal -i ~/.local/share/wallpapers/blue.jpg -n
        print_success "Pywal color scheme generated"
    else
        print_warning "Pywal not found, colors may not work correctly"
    fi
}

# Function to enable services
enable_services() {
    print_status "Setting up system services..."
    
    # Enable NetworkManager if not already enabled
    if systemctl is-enabled NetworkManager >/dev/null 2>&1; then
        print_status "NetworkManager is already enabled"
    else
        sudo systemctl enable NetworkManager
        print_success "NetworkManager enabled"
    fi
    
    # Enable Bluetooth if available
    if systemctl list-unit-files | grep -q bluetooth.service; then
        sudo systemctl enable bluetooth
        print_success "Bluetooth service enabled"
    fi
}

# Main installation function
main() {
    print_status "Starting Hyprland dotfiles installation..."
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_error "Please don't run this script as root!"
        exit 1
    fi
    
    # Check if we're in the right directory
    if [ ! -f "hypr/hyprland.conf" ]; then
        print_error "Please run this script from the dotfiles directory!"
        exit 1
    fi
    
    print_status "This script will install Hyprland and configure your system."
    print_warning "Make sure you have a backup of your current configuration!"
    
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Installation cancelled."
        exit 0
    fi
    
    # Installation steps
    install_packages
    create_directories
    backup_configs
    install_dotfiles
    create_hyprlock_config
    create_rofi_theme
    fix_config_paths
    setup_pywal
    enable_services
    
    print_success "Installation completed successfully!"
    print_status "Please log out and select Hyprland from your display manager."
    print_status "You may need to reboot for all changes to take effect."
    
    # Show next steps
    echo
    print_status "Next steps:"
    echo "1. Log out and select Hyprland session"
    echo "2. Press Super+S to open application launcher"
    echo "3. Press Super+Q to open terminal"
    echo "4. Press Super+X for power menu"
    echo "5. Customize wallpapers in ~/.local/share/wallpapers/"
    echo
    print_status "Configuration files are located in ~/.config/"
    print_status "Backup created in ~/.config/dotfiles_backup_* (if any existed)"
}

# Run main function
main "$@"