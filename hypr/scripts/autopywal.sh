#!/bin/bash

HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
HYPERPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
PYWAL_CMD="wal -i --saturate 0.4"
SLEEP_TIME=5

get_wallpaper_path() {
    if [ -f "$HYPERPAPER_CONF" ]; then
        grep -E '^wallpaper\s*=' "$HYPERPAPER_CONF" | tail -n 1 | awk -F '[=,]' '{print $NF}' | tr -d '[:space:]"'
    else
        grep 'wallpaper\s*=' "$HYPRLAND_CONF" | tail -n 1 | awk -F '[=,]' '{print $NF}' | tr -d '[:space:]"'
    fi
}

CURRENT_WALLPAPER=""

while true; do
    NEW_WALLPAPER=$(get_wallpaper_path)

    if [ -n "$NEW_WALLPAPER" ] && [ "$NEW_WALLPAPER" != "$CURRENT_WALLPAPER" ]; then
        echo "Zmiana tapety wykryta: $NEW_WALLPAPER. Uruchamiam Pywal..."

        if [ -f "$NEW_WALLPAPER" ]; then
            $PYWAL_CMD "$NEW_WALLPAPER"
            # Sync Waybar's local colors import
            if [ -f "$HOME/.cache/wal/colors-waybar.css" ]; then
                install -D -m 0644 "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors-waybar.css"
            fi
            CURRENT_WALLPAPER="$NEW_WALLPAPER"
        else
            echo "BŁĄD: Plik tapety nie istnieje: $NEW_WALLPAPER"
        fi
    fi

    sleep "$SLEEP_TIME"
done
