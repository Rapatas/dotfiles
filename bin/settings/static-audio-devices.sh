#!/bin/sh

set -e

# Just to get the prompt out of the way.
sudo true

PULSE_CONFIG='/etc/pulse/default.pa'

pactl list short sinks | column -t
echo "Type the id of the output"
read SELECTED_SINK

pactl list short sources | column -t
echo "Type the id of the input"
read SELECTED_SOURCE

# rm -r ~/.config/pulse
pactl set-default-sink $SELECTED_SINK
pactl set-default-source $SELECTED_SOURCE

sudo sed -i "s/^#set-default-sink.*$/set-default-sink $SELECTED_SINK/g" $PULSE_CONFIG
sudo sed -i "s/^#set-default-source.*$/set-default-source $SELECTED_SOURCE/g" $PULSE_CONFIG
# Stop auto changing onConnect
# sudo sed -i 's/^\(load-module module-switch-on-connect\)$/#\1/g' $PULSE_CONFIG
