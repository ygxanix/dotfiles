#!/usr/bin/env bash
set -euo pipefail

# Installer for Hyprland dotfiles (Arch Linux)
# - Installs required packages
# - Deploys configs into XDG locations
# - Sets up wallpapers and Pywal integration
# - Fixes paths in configs to be user-agnostic

if ! command -v pacman >/dev/null 2>&1; then
  echo "This installer currently supports Arch-based systems (pacman)." >&2
  exit 1
fi

USER_HOME=${HOME}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$USER_HOME/.config"}
REPO_ROOT=$(cd "$(dirname "$0")" && pwd)

need_sudo() {
  if [ "$EUID" -ne 0 ]; then echo sudo; else echo; fi
}

install_packages() {
  local pkgs=(
    hyprland hyprpaper hypridle hyprlock waybar wofi rofi kitty mako wl-clipboard
    grim slurp swappy brightnessctl pamixer playerctl cliphist power-profiles-daemon
    polkit-gnome xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
    bluez bluez-utils blueman network-manager-applet xdotool gnome-keyring
    python-pywal fastfetch dunst cava
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
  )

  echo "Installing packages: ${pkgs[*]}"
  $(need_sudo) pacman -Syu --needed --noconfirm "${pkgs[@]}" || true
}

deploy_configs() {
  mkdir -p "$XDG_CONFIG_HOME"

  # Hypr configs
  mkdir -p "$XDG_CONFIG_HOME/hypr/scripts"
  install -Dm0644 "$REPO_ROOT/hypr/hyprland.conf" "$XDG_CONFIG_HOME/hypr/hyprland.conf"
  install -Dm0644 "$REPO_ROOT/hypr/hyprpaper.conf" "$XDG_CONFIG_HOME/hypr/hyprpaper.conf"
  install -Dm0644 "$REPO_ROOT/hypr/hypridle.conf" "$XDG_CONFIG_HOME/hypr/hypridle.conf"
  if [ -f "$REPO_ROOT/hypr/hyprlock.conf" ]; then
    install -Dm0644 "$REPO_ROOT/hypr/hyprlock.conf" "$XDG_CONFIG_HOME/hypr/hyprlock.conf"
  else
    cat > "$XDG_CONFIG_HOME/hypr/hyprlock.conf" <<'EOF'
# Minimal Hyprlock configuration
general { grace = 2 }
background {
  monitor =
  path = ~/.config/wallpapers/current.png
  blur_passes = 1
  blur_size = 4
}
input-field {
  size = 240, 50
  outline_thickness = 2
  dots_size = 0.25
  dots_spacing = 0.2
  dots_center = true
  dots_rounding = -1
  hide_input = false
  rounding = -1
}
EOF
  fi

  # Scripts
  for f in "$REPO_ROOT"/hypr/scripts/*.sh; do
    install -Dm0755 "$f" "$XDG_CONFIG_HOME/hypr/scripts/$(basename "$f")"
  done

  # Waybar
  mkdir -p "$XDG_CONFIG_HOME/waybar"
  install -Dm0644 "$REPO_ROOT/waybar/config.jsonc" "$XDG_CONFIG_HOME/waybar/config.jsonc"
  install -Dm0644 "$REPO_ROOT/waybar/style.css" "$XDG_CONFIG_HOME/waybar/style.css"

  # Kitty
  if [ -f "$REPO_ROOT/kitty/kitty.conf" ]; then
    install -Dm0644 "$REPO_ROOT/kitty/kitty.conf" "$XDG_CONFIG_HOME/kitty/kitty.conf"
  fi

  # Mako
  if [ -f "$REPO_ROOT/mako/config" ]; then
    install -Dm0644 "$REPO_ROOT/mako/config" "$XDG_CONFIG_HOME/mako/config"
  fi

  # Fastfetch
  if [ -f "$REPO_ROOT/fastfetch/config.jsonc" ]; then
    install -Dm0644 "$REPO_ROOT/fastfetch/config.jsonc" "$XDG_CONFIG_HOME/fastfetch/config.jsonc"
    [ -f "$REPO_ROOT/fastfetch/wolf.png" ] && install -Dm0644 "$REPO_ROOT/fastfetch/wolf.png" "$XDG_CONFIG_HOME/fastfetch/wolf.png"
  fi

  # Pywal template for Hyprland colors
  if [ -f "$REPO_ROOT/wal/templates/colors-hyprland.conf" ]; then
    install -Dm0644 "$REPO_ROOT/wal/templates/colors-hyprland.conf" "$XDG_CONFIG_HOME/wal/templates/colors-hyprland.conf"
  fi
}

setup_wallpapers() {
  local wp_dir="$XDG_CONFIG_HOME/wallpapers"
  mkdir -p "$wp_dir"

  # Copy repo wallpapers if present
  if compgen -G "$REPO_ROOT/wallpapers/*" >/dev/null; then
    install -Dm0644 "$REPO_ROOT"/wallpapers/* "$wp_dir/" || true
  fi

  # Choose a default wallpaper: prefer current.png/jpg if exists, else first image
  if [ -f "$wp_dir/current.png" ] || [ -f "$wp_dir/current.jpg" ] || [ -f "$wp_dir/current.jpeg" ] || [ -f "$wp_dir/current.webp" ]; then
    :
  else
    first=$(ls -1 "$wp_dir"/*.{png,jpg,jpeg,webp} 2>/dev/null | head -n 1 || true)
    if [ -n "${first:-}" ]; then
      ext="${first##*.}"
      cp -f "$first" "$wp_dir/current.$ext"
    fi
  fi

  # Update hyprpaper.conf to point to current image
  current_any=$(ls -1 "$wp_dir"/current.* 2>/dev/null | head -n 1 || true)
  if [ -n "${current_any:-}" ]; then
    esc_current=${current_any//\//\/}
    sed -i "s#^preload\s*=.*#preload = ${esc_current}#" "$XDG_CONFIG_HOME/hypr/hyprpaper.conf" || true
    sed -i "s#^wallpaper\s*=.*#wallpaper = ,${esc_current}#" "$XDG_CONFIG_HOME/hypr/hyprpaper.conf" || true
  fi
}

fix_paths_and_pywal() {
  # Replace any lingering absolute /home/<user> paths with ~
  local files=(
    "$XDG_CONFIG_HOME/waybar/style.css"
    "$XDG_CONFIG_HOME/hypr/hyprpaper.conf"
    "$XDG_CONFIG_HOME/hypr/hyprland.conf"
  )
  for f in "${files[@]}"; do
    [ -f "$f" ] || continue
    sed -i "s#${USER_HOME}/#~/#g" "$f" || true
  done

  # Generate Pywal colors from current wallpaper if available
  if command -v wal >/dev/null 2>&1; then
    current_any=$(ls -1 "$XDG_CONFIG_HOME/wallpapers"/current.* 2>/dev/null | head -n 1 || true)
    if [ -n "${current_any:-}" ]; then
      wal -i "$current_any" --saturate 0.4 || true
    fi
  fi

  # Sync Waybar colors file locally
  if [ -f "$USER_HOME/.cache/wal/colors-waybar.css" ]; then
    install -Dm0644 "$USER_HOME/.cache/wal/colors-waybar.css" "$XDG_CONFIG_HOME/waybar/colors-waybar.css"
  fi
}

post_install_notes() {
  cat <<'EOF'
Done. Next steps:
- Log into Hyprland.
- Ensure nm-applet, polkit-gnome agent, and xdg-desktop-portal are running (autostarted).
- Change wallpaper by replacing ~/.config/wallpapers/current.* and run: hyprctl reload; killall hyprpaper; hyprpaper &
EOF
}

main() {
  install_packages
  deploy_configs
  setup_wallpapers
  fix_paths_and_pywal
  post_install_notes
}

main "$@"
