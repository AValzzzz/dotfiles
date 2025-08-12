PLAYER_STATUS=$(playerctl -s -p cider status | tail -n1)
ARTIST=$(playerctl -p cider metadata artist | sed 's/&/+/g') 
TITLE=$(playerctl -p cider metadata title | sed 's/&/+/g')

if [[ $PLAYER_STATUS == "Paused" || $PLAYER_STATUS == "Playing" ]]; then
    echo "${ARTIST} - ${TITLE}"
elif [[ $PLAYER_STATUS == "Stopped" ]]; then
    echo "No Music Playing"
else
   echo "Music Player Offline"
fi
