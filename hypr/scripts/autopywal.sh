#!/bin/bash

HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
PYWAL_CMD="wal -i --saturate 0.4"
SLEEP_TIME=5

get_wallpaper_path() {
    grep 'wallpaper\s*=' "$HYPRLAND_CONF" | 
    tail -n 1 | 
    awk -F '[=,]' '{print $NF}' | 
    tr -d '[:space:]"'
}

CURRENT_WALLPAPER=""

while true; do
    NEW_WALLPAPER=$(get_wallpaper_path)

    if [ -n "$NEW_WALLPAPER" ] && [ "$NEW_WALLPAPER" != "$CURRENT_WALLPAPER" ]; then
        echo "Zmiana tapety wykryta: $NEW_WALLPAPER. Uruchamiam Pywal..."

        if [ -f "$NEW_WALLPAPER" ]; then
            $PYWAL_CMD "$NEW_WALLPAPER"
            CURRENT_WALLPAPER="$NEW_WALLPAPER"
        else
            echo "BŁĄD: Plik tapety nie istnieje: $NEW_WALLPAPER"
        fi
    fi

    sleep "$SLEEP_TIME"
done
