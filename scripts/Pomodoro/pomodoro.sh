#!/usr/bin/env bash

STATE_FILE="$HOME/.config/waybar/pomodoro_state.json"
DEFAULT_DURATION=25
STEP=1               
LOG_FILE="/tmp/pomodoro.log"

# Fonction pour logger
# log_action() {
#     echo "$(date '+%F %T') - Action: $1" >> "$LOG_FILE"
# }


update_state() {
    local duration_val=${1:-$DEFAULT_DURATION}
    local remaining_val=${2:-0}
    local running_val=${3:-false}

    jq -n --argjson d "$duration_val" \
          --argjson r "$remaining_val" \
          --argjson run "$running_val" \
        '{duration: $d, remaining: $r, running: $run}' > "$STATE_FILE"
}


if [ ! -s "$STATE_FILE" ]; then
    update_state "$DEFAULT_DURATION" 0 false
fi


eval $(jq -r '@sh "duration=\(.duration) remaining=\(.remaining) running=\(.running)"' "$STATE_FILE")

# Logger l'action dès qu'on entre dans une commande
# case "$1" in
#     click|scroll_up|scroll_down|tick)
#         log_action "$1"
#         ;;
# esac


case "$1" in
    click)
        if [ "$running" = false ] && [ "$remaining" -eq 0 ]; then
            update_state "$duration" $((duration * 60)) true
        elif [ "$running" = false ] && [ "$remaining" -gt 0 ]; then
            update_state "$duration" "$remaining" true
        else
            update_state "$duration" "$remaining" false
        fi
        ;;
    right-click)
        update_state "$duration" 0 false
        ;;

    scroll_up)
        if [ "$running" = false ]; then
            duration=$((duration + STEP))
            update_state "$duration" 0 false
        fi
        ;;
    scroll_down)
        if [ "$running" = false ] && [ "$duration" -gt "$STEP" ]; then
            duration=$((duration - STEP))
            update_state "$duration" 0 false
        fi
        ;;
    tick)
        if [ "$running" = true ]; then
            remaining=$((remaining - 1))
            if [ "$remaining" -le 0 ]; then
                notify-send "⏰ Pomodoro terminé !" "Prenez une pause !" -u critical
                update_state "$duration" 0 false
            else
                update_state "$duration" "$remaining" true
            fi
        fi
        ;;
    *)
        if [ "$running" = true ]; then
            mins=$((remaining / 60))
            secs=$((remaining % 60))
            printf "🍅 %02d:%02d" "$mins" "$secs"
        elif [ "$remaining" -gt 0 ]; then
            mins=$((remaining / 60))
            secs=$((remaining % 60))
            printf "🍅 %02d:%02d" "$mins" "$secs"
        else
            printf "🍅 %02d:00" "$duration"
        fi
        ;;
esac
