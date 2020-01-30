#!/bin/bash

if [ "$#" != 2 ]; then
    echo "Usage: ./launcher.sh win_class prog_exec"
    exit 1
fi

PROG_CLASS=$1
PROG_EXEC=$2

# If no windows exist, launch the program and stop.
exists_str=$(xdotool search --class $PROG_CLASS)
if [[ -z "${exists_str// }" ]]; then

    $PROG_EXEC &

else

    found_it=false

    # If focused window is in the list we got earlier, minimize it and stop.
    focus=$(xdotool getwindowfocus)
    mapfile -t exists <<< "$exists_str"
    for i in "${exists[@]}"; do
        if [ "$i" == "$focus"  ]; then
            found_it=true
        fi
    done

    if $found_it; then
        xdotool search --desktop 0 --class $PROG_CLASS windowminimize
    else
        # Unminimize the window.
        xdotool search --desktop 0 --class $PROG_CLASS windowactivate
    fi

fi


# Opera:
# class: Opera
# command: opera

# Chrome:
# class: Google-chrome
# command: google-chrome-stable
