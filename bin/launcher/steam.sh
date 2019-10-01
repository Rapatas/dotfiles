#!/bin/bash

exists=`xdotool search --class Steam getwindowname`

if [[ -z "${exists// }" ]]; then
	/usr/games/steam &
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"Steam"* ]]; then
	xdotool search --desktop 0 --class Steam windowminimize
else
	xdotool search --desktop 0 --class Steam windowactivate
fi
