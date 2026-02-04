#!/bin/bash
wallpaper_path="$HOME/.wallpapers"
swww img "$(find "$wallpaper_path" -type f | shuf -n 1)" --transition-type any --transition-fps 60
