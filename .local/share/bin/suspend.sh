#!/bin/bash

# Run hyprlock in the background
hyprlock &

# Give it a bit of time to actually lock the screen
sleep 0.5

# Then suspend the system
systemctl suspend
