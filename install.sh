#!/bin/bash

# Hyprland Dotfiles Installer Script
# This script installs and configures Hyprland with all necessary dependencies

# Exit on errors, but allow controlled error handling
set -e
# Allow error handling in functions
set -E

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
                waybar rofi rofi-emoji wofi mako kitty \
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
                power-profiles-daemon \
                ydotool
            
            # Enable power-profiles-daemon service
            sudo systemctl enable --now power-profiles-daemon 2>/dev/null || true
            
            # Enable ydotool service for emoji picker
            sudo systemctl enable --now ydotool.service 2>/dev/null || true
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
                fonts-noto fonts-noto-color-emoji \
                jq \
                power-profiles-daemon 2>/dev/null || true
            
            # Install pywal via pip
            pip3 install --user pywal
            
            # Try to install ydotool if available
            sudo apt install -y ydotool 2>/dev/null || print_warning "ydotool not available, emoji picker paste may not work"
            
            # Enable power-profiles-daemon if available
            sudo systemctl enable --now power-profiles-daemon 2>/dev/null || true
            sudo systemctl enable --now ydotool.service 2>/dev/null || true
            
            # Note: hyprpaper, hypridle, hyprlock may need to be compiled from source on Ubuntu
            print_warning "Some Hyprland components may need manual compilation on Ubuntu/Debian"
            print_warning "rofi-emoji plugin may need to be installed manually from: https://github.com/Mange/rofi-emoji"
            print_warning "If power-profiles-daemon is not available, power profile switching will be disabled"
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
                google-noto-fonts google-noto-emoji-fonts \
                jq \
                power-profiles-daemon \
                ydotool 2>/dev/null || true
            
            # Install pywal via pip
            pip3 install --user pywal
            
            # Enable services
            sudo systemctl enable --now power-profiles-daemon 2>/dev/null || true
            sudo systemctl enable --now ydotool.service 2>/dev/null || true
            
            print_warning "rofi-emoji may need to be installed manually from: https://github.com/Mange/rofi-emoji"
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
    
    # Create config directories
    mkdir -p ~/.config/{hypr,waybar,kitty,mako,rofi,cava,fastfetch,nvim,wal}
    mkdir -p ~/.config/hypr/scripts
    mkdir -p ~/.config/rofi/themes
    mkdir -p ~/.config/wal/templates
    
    # Create local directories
    mkdir -p ~/.local/share/wallpapers
    
    # Create oh-my-zsh custom themes directory
    mkdir -p ~/.oh-my-zsh/custom/themes
    
    # Create cache directory
    mkdir -p ~/.cache/wal
    
    # Verify critical directories were created
    if [ ! -d ~/.config/hypr ]; then
        print_error "Failed to create ~/.config/hypr directory"
        return 1
    fi
    
    print_success "Directories created successfully"
}

# Function to backup existing configurations
backup_configs() {
    print_status "Backing up existing configurations..."
    
    local backup_dir="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup config directories
    for dir in hypr waybar kitty mako rofi cava fastfetch nvim wal; do
        if [ -d "$HOME/.config/$dir" ]; then
            print_status "Backing up $dir configuration..."
            cp -r "$HOME/.config/$dir" "$backup_dir/"
        fi
    done
    
    # Backup oh-my-zsh custom theme if it exists
    if [ -f "$HOME/.oh-my-zsh/custom/themes/custom_prompt.zsh-theme" ]; then
        print_status "Backing up oh-my-zsh custom theme..."
        mkdir -p "$backup_dir/oh-my-zsh/custom/themes"
        cp "$HOME/.oh-my-zsh/custom/themes/custom_prompt.zsh-theme" "$backup_dir/oh-my-zsh/custom/themes/"
    fi
    
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
    
    # Verify we're in the correct directory
    if [ ! -d "hypr" ] || [ ! -d "waybar" ]; then
        print_error "Required directories not found. Are you in the dotfiles directory?"
        return 1
    fi
    
    # Copy configuration files
    print_status "Copying Hyprland configuration..."
    cp -r hypr/* ~/.config/hypr/ || { print_error "Failed to copy hypr config"; return 1; }
    
    print_status "Copying Waybar configuration..."
    cp -r waybar/* ~/.config/waybar/ || { print_error "Failed to copy waybar config"; return 1; }
    
    print_status "Copying terminal and app configurations..."
    cp -r kitty/* ~/.config/kitty/ || { print_error "Failed to copy kitty config"; return 1; }
    cp -r mako/* ~/.config/mako/ || { print_error "Failed to copy mako config"; return 1; }
    cp -r cava/* ~/.config/cava/ || { print_error "Failed to copy cava config"; return 1; }
    cp -r fastfetch/* ~/.config/fastfetch/ || { print_error "Failed to copy fastfetch config"; return 1; }
    
    # Copy Neovim configuration
    if [ -d "nvim" ]; then
        print_status "Copying Neovim configuration..."
        cp -r nvim/* ~/.config/nvim/ || print_warning "Failed to copy nvim config"
    else
        print_warning "Neovim config directory not found, skipping..."
    fi
    
    # Copy Rofi configuration
    if [ -d "rofi" ]; then
        print_status "Copying Rofi configuration..."
        cp -r rofi/* ~/.config/rofi/ || print_warning "Failed to copy rofi config"
    fi
    
    # Copy oh-my-zsh custom theme
    if [ -d "oh-my-zsh" ] && [ -d ~/.oh-my-zsh ]; then
        print_status "Copying oh-my-zsh custom theme..."
        cp oh-my-zsh/custom_prompt.zsh-theme ~/.oh-my-zsh/custom/themes/ || print_warning "Failed to copy zsh theme"
    elif [ -d "oh-my-zsh" ]; then
        print_warning "oh-my-zsh not installed. Theme available in: $(pwd)/oh-my-zsh/"
    fi
    
    # Copy wallpapers
    if [ -d "wallpapers" ] && [ "$(ls -A wallpapers 2>/dev/null)" ]; then
        print_status "Copying wallpapers..."
        cp wallpapers/* ~/.local/share/wallpapers/ || print_warning "Failed to copy wallpapers"
    else
        print_error "No wallpapers found!"
        return 1
    fi
    
    # Copy wal templates
    if [ -d "wal/templates" ]; then
        print_status "Copying Pywal templates..."
        cp wal/templates/* ~/.config/wal/templates/ || print_warning "Failed to copy wal templates"
    else
        print_error "Wal templates not found!"
        return 1
    fi
    
    # Make scripts executable
    if [ -d ~/.config/hypr/scripts ]; then
        print_status "Making scripts executable..."
        chmod +x ~/.config/hypr/scripts/* || print_warning "Failed to make scripts executable"
    fi
    
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
    
    # Fix hardcoded home directory in Waybar CSS
    sed -i "s|HOME_PLACEHOLDER|$HOME|g" ~/.config/waybar/style.css
    sed -i "s|/home/[^/]*/|$HOME/|g" ~/.config/waybar/style.css
    
    print_success "Configuration paths fixed"
}

# Function to setup pywal
setup_pywal() {
    print_status "Setting up pywal with default wallpaper..."
    
    # Check if pywal is available
    if ! command_exists wal; then
        print_error "Pywal not found! Colors will not work correctly."
        print_status "Installing pywal..."
        pip3 install --user pywal || {
            print_error "Failed to install pywal via pip"
            return 1
        }
    fi
    
    # Check if default wallpaper exists
    local default_wallpaper="$HOME/.local/share/wallpapers/blue.jpg"
    if [ ! -f "$default_wallpaper" ]; then
        print_error "Default wallpaper not found at: $default_wallpaper"
        print_warning "Looking for any available wallpaper..."
        
        # Try to find any wallpaper
        local any_wallpaper=$(find ~/.local/share/wallpapers/ -type f \( -iname "*.jpg" -o -iname "*.png" \) | head -n 1)
        
        if [ -n "$any_wallpaper" ]; then
            print_status "Using wallpaper: $any_wallpaper"
            wal -i "$any_wallpaper" -n
            print_success "Pywal color scheme generated"
        else
            print_error "No wallpapers found! Please add wallpapers to ~/.local/share/wallpapers/"
            return 1
        fi
    else
        # Generate color scheme from default wallpaper
        wal -i "$default_wallpaper" -n
        if [ $? -eq 0 ]; then
            print_success "Pywal color scheme generated successfully"
        else
            print_error "Failed to generate color scheme with pywal"
            return 1
        fi
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
    
    # Installation steps with error handling
    print_status "Step 1/9: Installing packages..."
    if ! install_packages; then
        print_error "Package installation failed!"
        exit 1
    fi
    
    print_status "Step 2/9: Creating directories..."
    if ! create_directories; then
        print_error "Directory creation failed!"
        exit 1
    fi
    
    print_status "Step 3/9: Backing up existing configurations..."
    backup_configs || print_warning "Backup step had issues, but continuing..."
    
    print_status "Step 4/9: Installing dotfiles..."
    if ! install_dotfiles; then
        print_error "Dotfiles installation failed!"
        exit 1
    fi
    
    print_status "Step 5/9: Creating Hyprlock configuration..."
    create_hyprlock_config || print_warning "Hyprlock config creation failed, continuing..."
    
    print_status "Step 6/9: Creating Rofi theme..."
    create_rofi_theme || print_warning "Rofi theme creation failed, continuing..."
    
    print_status "Step 7/9: Fixing configuration paths..."
    if ! fix_config_paths; then
        print_error "Path fixing failed!"
        exit 1
    fi
    
    print_status "Step 8/9: Setting up Pywal color scheme..."
    if ! setup_pywal; then
        print_error "Pywal setup failed! Colors will not work correctly."
        print_warning "You can run 'wal -i /path/to/wallpaper.jpg' manually later."
    fi
    
    print_status "Step 9/9: Enabling system services..."
    enable_services || print_warning "Some services may not have been enabled"
    
    print_success "Installation completed successfully!"
    print_status "Please log out and select Hyprland from your display manager."
    print_status "You may need to reboot for all changes to take effect."
    
    # Show next steps
    echo
    print_status "=== Next Steps ==="
    echo "1. Log out and select Hyprland session"
    echo "2. Press Super+S to open application launcher"
    echo "3. Press Super+Q to open terminal"
    echo "4. Press Super+X for power menu"
    echo "5. Customize wallpapers in ~/.local/share/wallpapers/"
    echo
    print_status "=== New Features ==="
    echo "✨ Dynamic Window Coloring - Windows adapt to wallpaper colors!"
    echo "   - Change wallpaper with: wal -i /path/to/wallpaper.jpg"
    echo "   - Adjust opacity in ~/.config/hypr/hyprland.conf"
    echo "   - Customize blur and vibrancy settings"
    echo
    print_status "=== Key Bindings ==="
    echo "Super+Q: Terminal          Super+X: Power Menu"
    echo "Super+S: App Launcher      Super+K: Coffee Mode"
    echo "Super+V: Clipboard         Super+Shift+S: Screenshot"
    echo "Super+Period: Emoji Picker Super+I: Network Settings"
    echo
    print_status "Configuration files are located in ~/.config/"
    print_status "Backup created in ~/.config/dotfiles_backup_* (if any existed)"
    echo
    print_success "Enjoy your new Hyprland setup with dynamic window coloring! 🎨"
}

# Run main function
main "$@"