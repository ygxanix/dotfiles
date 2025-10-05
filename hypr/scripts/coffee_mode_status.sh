#!/bin/bash

PID_FILE="/tmp/coffee_mode_pid"

if [ -f "$PID_FILE" ]; then
    echo '{"text": "☕", "class": "coffee-active", "tooltip": "Coffee Mode: Aktywny (Kliknij, aby wyłączyć)"}'
else
    echo '{"text": "🧊", "class": "coffee-inactive", "tooltip": "Coffee Mode: Wyłączony (Kliknij, aby włączyć)"}'
fi
