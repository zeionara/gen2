#!/bin/bash

xdph_log=/home/zeio/.config/hypr/xdph.log.txt

sleep 1
killall xdg-desktop-portal-hyprland
killall xdg-desktop-portal-gnome
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
logger 'killed all xdg-desktop'
sleep 1
# dbus-run-session /usr/libexec/xdg-desktop-portal-hyprland &
# echo >> "$xdph_log"
# echo $(date +"%Y-%m-%d %H:%M:%S") Starting hyprland >> "$xdph_log"
# echo >> "$xdph_log"
# /usr/libexec/xdg-desktop-portal-hyprland -v >> "$xdph_log" 2>&1 &
/usr/libexec/xdg-desktop-portal-hyprland &
logger 'xdg-desktop-portal-hyprland started'
sleep 2
# dbus-run-session /usr/libexec/xdg-desktop-portal &
/usr/libexec/xdg-desktop-portal &
logger 'xdg-desktop-portal started'
