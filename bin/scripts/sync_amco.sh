#!/bin/sh

rsync \
  -a \
  --delete \
  --exclude="repo" \
  "$HOME/dox/amco/" \
  "/media/$USER/16GB_FAST/amco/"
