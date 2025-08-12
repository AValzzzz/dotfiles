CURRENT_SONG="PATH/TO/SCRIPTS/current_song.sh"

zscroll -p " | " --delay 0.2 \
    --length 40 \
    --match-command "playerctl -p cider status" \
    --match-text "Playing" "--scroll 1" \
    --match-text "Paused" "--before-text ' ' --scroll 0" \
    --update-interval 1 \
    --update-check true $CURRENT_SONG &
wait
