#!/bin/bash

exists=`xdotool search --class Discord getwindowname`

if [[ -z "${exists// }" ]]; then
	/usr/bin/discord &
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"Discord"* ]]; then
	xdotool search --desktop 0 --class Discord windowminimize
else
	xdotool search --desktop 0 --class Discord windowactivate
fi
