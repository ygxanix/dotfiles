#!/bin/bash

PROFILES=("balanced" "power-saver" "performance")
PROFILE_NAMES=("Balans" "Saver" "Performance")
ICONS=("󰾅 " "󰌪 " " ")
STATE_FILE="/tmp/current_power_profile_index"

get_current_profile_info() {
    local current_daemon_profile=$(powerprofilesctl get)
    local current_index=0

    case "$current_daemon_profile" in
        "balanced") current_index=0 ;;
        "power-saver") current_index=1 ;;
        "performance") current_index=2 ;;
        *) current_index=0 ;; 
    esac

    echo "$current_index" > "$STATE_FILE" 

    echo "{\"text\":\"${ICONS[$current_index]} ${PROFILE_NAMES[$current_index]}\", \"tooltip\":\"Tryb energii: ${PROFILE_NAMES[$current_index]}\"}"
}

toggle_next_profile() {
    if [ ! -f "$STATE_FILE" ]; then
        get_current_profile_info > /dev/null 
        CURRENT_INDEX=$(cat "$STATE_FILE") 
    else
        CURRENT_INDEX=$(cat "$STATE_FILE")
    fi

    NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#PROFILES[@]} ))

    NEXT_PROFILE="${PROFILES[$NEXT_INDEX]}"

    powerprofilesctl set "$NEXT_PROFILE"

    echo "$NEXT_INDEX" > "$STATE_FILE"

    get_current_profile_info
}

if [ "$1" == "--toggle" ]; then
    toggle_next_profile
else
    get_current_profile_info
fi
