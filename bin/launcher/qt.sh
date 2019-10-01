#!/bin/bash

exists=`xdotool search --class QtCreator getwindowname`

if [[ -z "${exists// }" ]]; then
	~/Qt/Tools/QtCreator/bin/qtcreator &
fi

wname=`xdotool getwindowfocus getwindowname`

if [[ "$wname" == *"qtcreator"* ]]; then
	xdotool search --desktop 0 --class QtCreator windowminimize
else
	xdotool search --desktop 0 --class QtCreator windowactivate
fi
