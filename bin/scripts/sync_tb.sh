#!/bin/sh

rsync \
	-a \
	--delete \
	--exclude="Movies" \
	"/media/$USER/MightyDrive/Documents/" \
	"/media/$USER/Andreas TB/Backup/"
