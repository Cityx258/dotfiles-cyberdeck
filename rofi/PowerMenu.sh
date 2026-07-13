#!/bin/bash

chosen=$(echo -e "󰍃 Logout\n󰤄 Suspend\n󰜉 Reboot\n󰐥 Shutdown" | rofi -dmenu -p "Power" -theme ~/.config/rofi/powermenu.rasi)

case $chosen in
    "󰍃 Logout")   hyprctl dispatch exit ;;
    "󰤄 Suspend")  systemctl suspend ;;
    "󰜉 Reboot")   systemctl reboot ;;
    "󰐥 Shutdown") systemctl poweroff ;;
esac
