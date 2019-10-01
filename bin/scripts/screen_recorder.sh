#!/bin/sh

ffmpeg \
	-f x11grab \
	-framerate 30 \
	-s 707x399 \
	-i :0.0+329,180 \
	-vcodec huffyuv \
	output.avi
