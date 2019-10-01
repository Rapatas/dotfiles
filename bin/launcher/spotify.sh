#!/bin/bash

exists=`xdotool search --class Spotify getwindowname`

if [[ -z "${exists// }" ]]; then
	spotify &
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"Spotify"* ]]; then
	xdotool search --desktop 0 --class Spotify windowminimize
else
	xdotool search --desktop 0 --class Spotify windowactivate
fi
