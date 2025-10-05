#!/bin/bash

PID_FILE="/tmp/coffee_mode_pid"
INHIBIT_REASON="Coffee Mode: Preventing screen sleep and lock"
INHIBIT_WHAT="idle"

if [ -f "$PID_FILE" ]; then

    PID=$(cat "$PID_FILE")
    
    if kill "$PID" 2>/dev/null; then
        echo "Dezaktywacja Coffee Mode (PID: $PID)..."
        rm "$PID_FILE"
        notify-send "☕ Coffee Mode" "❌ Dezaktywowany. Polityka wygaszania (hypridle) przywrócona."
    else
        rm "$PID_FILE"
        notify-send "☕ Coffee Mode" "⚠️ Błąd: Nieznany proces. Usunięto plik stanu."
    fi

else
    
    echo "Aktywacja Coffee Mode..."
    
    systemd-inhibit --what=$INHIBIT_WHAT --why="$INHIBIT_REASON" sleep infinity &
    echo $! > "$PID_FILE"
    
    notify-send "☕ Coffee Mode" "✅ Aktywowany. Blokada wygaszania jest aktywna."
fi
