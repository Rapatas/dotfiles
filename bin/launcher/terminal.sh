#!/bin/bash

exists=`xdotool search --class Xfce4-terminal getwindowname`

if [[ -z "${exists// }" ]]; then
	xfce4-terminal &
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"Terminal"* ]]; then
	xdotool search --desktop 0 --class Xfce4-terminal windowminimize
else
	xdotool search --desktop 0 --class Xfce4-terminal windowactivate
fi

