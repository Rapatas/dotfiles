#!/bin/sh

xinput list
echo "What's the id of your mouse?"
read id

xinput set-button-map $id 1 2 3 0 0
