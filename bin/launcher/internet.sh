#!/bin/bash

exists=`xdotool search --class Firefox getwindowname`

if [[ -z "${exists// }" ]]; then
	firefox &
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"Firefox"* ]]; then
	xdotool search --desktop 0 --class Firefox windowminimize
else
	xdotool search --desktop 0 --class Firefox windowactivate
fi

# Opera:
# class: Opera
# name: Opera
# command: opera

# Chrome:
# class: Google-chrome
# command: google-chrome-stable
