#!/bin/bash

exists=`xdotool search --name "File Manager" getwindowname`

if [[ -z "${exists// }" ]]; then
	thunar &
	sleep .1
	xdotool search --class Thunar windowactivate
	exit 0
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"File Manager"* ]]; then
	xdotool search --desktop 0 --class Thunar windowminimize
else
	xdotool search --desktop 0 --class Thunar windowactivate
fi

