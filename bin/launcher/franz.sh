#!/bin/bash

exists=`xdotool search --class Franz getwindowname`

if [[ -z "${exists// }" ]]; then
	/opt/franz/Franz &
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"Franz"* ]]; then
	xdotool search --desktop 0 --class Franz windowminimize
else
	xdotool search --desktop 0 --class Franz windowactivate
fi
