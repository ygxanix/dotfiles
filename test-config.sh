#!/bin/bash

# Test script to validate Hyprland dotfiles configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Test function
test_file_exists() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        print_success "$description exists: $file"
        return 0
    else
        print_error "$description missing: $file"
        return 1
    fi
}

test_dir_exists() {
    local dir="$1"
    local description="$2"
    
    if [ -d "$dir" ]; then
        print_success "$description exists: $dir"
        return 0
    else
        print_error "$description missing: $dir"
        return 1
    fi
}

test_executable() {
    local file="$1"
    local description="$2"
    
    if [ -x "$file" ]; then
        print_success "$description is executable: $file"
        return 0
    else
        print_error "$description not executable: $file"
        return 1
    fi
}

main() {
    print_status "Testing Hyprland dotfiles configuration..."
    echo
    
    local failed=0
    
    # Test configuration directories
    print_status "Checking configuration directories..."
    test_dir_exists "$HOME/.config/hypr" "Hyprland config directory" || ((failed++))
    test_dir_exists "$HOME/.config/waybar" "Waybar config directory" || ((failed++))
    test_dir_exists "$HOME/.config/rofi" "Rofi config directory" || ((failed++))
    test_dir_exists "$HOME/.config/kitty" "Kitty config directory" || ((failed++))
    test_dir_exists "$HOME/.config/mako" "Mako config directory" || ((failed++))
    
    echo
    
    # Test main configuration files
    print_status "Checking main configuration files..."
    test_file_exists "$HOME/.config/hypr/hyprland.conf" "Hyprland config" || ((failed++))
    test_file_exists "$HOME/.config/hypr/hyprpaper.conf" "Hyprpaper config" || ((failed++))
    test_file_exists "$HOME/.config/hypr/hyprlock.conf" "Hyprlock config" || ((failed++))
    test_file_exists "$HOME/.config/hypr/hypridle.conf" "Hypridle config" || ((failed++))
    test_file_exists "$HOME/.config/waybar/config.jsonc" "Waybar config" || ((failed++))
    test_file_exists "$HOME/.config/rofi/themes/powermenu-pywal.rasi" "Rofi theme" || ((failed++))
    
    echo
    
    # Test scripts
    print_status "Checking scripts..."
    test_file_exists "$HOME/.config/hypr/scripts/screenshot.sh" "Screenshot script" || ((failed++))
    test_file_exists "$HOME/.config/hypr/scripts/powermenu_pywal.sh" "Power menu script" || ((failed++))
    test_file_exists "$HOME/.config/hypr/scripts/toggle_idle.sh" "Idle toggle script" || ((failed++))
    
    test_executable "$HOME/.config/hypr/scripts/screenshot.sh" "Screenshot script" || ((failed++))
    test_executable "$HOME/.config/hypr/scripts/powermenu_pywal.sh" "Power menu script" || ((failed++))
    test_executable "$HOME/.config/hypr/scripts/toggle_idle.sh" "Idle toggle script" || ((failed++))
    
    echo
    
    # Test wallpapers and assets
    print_status "Checking wallpapers and assets..."
    test_dir_exists "$HOME/.local/share/wallpapers" "Wallpapers directory" || ((failed++))
    
    if [ -d "$HOME/.local/share/wallpapers" ]; then
        local wallpaper_count=$(find "$HOME/.local/share/wallpapers" -type f \( -name "*.jpg" -o -name "*.png" \) | wc -l)
        if [ "$wallpaper_count" -gt 0 ]; then
            print_success "Found $wallpaper_count wallpaper(s)"
        else
            print_error "No wallpapers found in ~/.local/share/wallpapers"
            ((failed++))
        fi
    fi
    
    echo
    
    # Test pywal setup
    print_status "Checking pywal setup..."
    if command -v wal >/dev/null 2>&1; then
        print_success "Pywal is installed"
        
        if [ -f "$HOME/.cache/wal/colors.sh" ]; then
            print_success "Pywal colors generated"
        else
            print_warning "Pywal colors not generated yet (run 'wal -i /path/to/wallpaper')"
        fi
    else
        print_error "Pywal not found in PATH"
        ((failed++))
    fi
    
    echo
    
    # Summary
    if [ $failed -eq 0 ]; then
        print_success "All tests passed! Configuration looks good."
        echo
        print_status "Next steps:"
        echo "1. Log out and select Hyprland session"
        echo "2. Generate colors with: wal -i ~/.local/share/wallpapers/blue.jpg"
        echo "3. Test key bindings (Super+Q for terminal, Super+S for launcher)"
        exit 0
    else
        print_error "$failed test(s) failed. Please check the configuration."
        exit 1
    fi
}

main "$@"