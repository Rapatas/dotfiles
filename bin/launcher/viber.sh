#!/bin/bash

exists=`xdotool search --class Viber getwindowname`

if [[ -z "${exists// }" ]]; then
	/opt/franz/Viber &
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"Viber"* ]]; then
	xdotool search --desktop 0 --class Viber windowminimize
else
	xdotool search --desktop 0 --class Viber windowactivate
fi
