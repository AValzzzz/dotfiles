#!/usr/bin/env bash
STATE_FILE="$HOME/.config/waybar/pomodoro_state.json"

while true; do
    running=$(jq -r '.running' "$STATE_FILE")
    if [ "$running" = true ]; then
        ~/.config/scripts/Pomodoro/pomodoro.sh tick > /dev/null
    fi
    sleep 1
done
