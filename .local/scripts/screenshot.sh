#! /bin/bash

[ ! -d $HOME/Pictures ] && mkdir $HOME/Pictures

IMG_NAME="$HOME/Pictures/Screenshot.png"

maim $([ -n "$1" ] && echo "-us" || echo "-u") $IMG_NAME

if [[ $? == 0 ]]
then
    xclip -selection clipboard -t image/png -i $IMG_NAME
    notify-send 'Snap!' "Screenshot saved and copied to clipboard.\n($IMG_NAME)"
fi
    
