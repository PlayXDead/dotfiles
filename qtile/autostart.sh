#!/usr/bin/env bash
xrandr --output eDP-1-1 --mode 1920x1080 --primary &
xrandr --output HDMI-0 --mode 1080x1920 &
xrandr --output HDMI-0 --rotate right &
polybar mybar & polybar mybar2
