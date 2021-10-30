#! /bin/bash

[ ! -d $HOME/Pictures/Screenshots ] && mkdir $HOME/Pictures/Screenshots
maim $([ -n "$1" ] && echo "-us" || echo "-u") "$HOME/Pictures/Screenshots/$(date +%c).png" &> /dev/null

if [[ $? == 0 ]]
then
    notify-send 'Snap!' 'Screenshot saved and copied to clipboard' | xclip -selection clipboard -t image/png 
fi
