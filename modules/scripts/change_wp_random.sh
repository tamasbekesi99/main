#!/usr/bin/env bash

# Set the path to the wallpapers directory
wallpapersDir="$HOME/walls/"

# Get a list of all image files in the wallpapers directory
wallpapers=("$wallpapersDir"/*)

# Start an infinite loop
while true; do
    # Check if the wallpapers array is empty
    if [ ${#wallpapers[@]} -eq 0 ]; then
        # If the array is empty, refill it with the image files
        wallpapers=("$wallpapersDir"/*)
    fi

    # Select a random wallpaper from the array
    wallpaperIndex=$(( RANDOM % ${#wallpapers[@]} ))
    selectedWallpaper="${wallpapers[$wallpaperIndex]}"

    # Update the wallpaper using the awww img command
    awww img "$selectedWallpaper" --resize fit -t random

    # Remove the selected wallpaper from the array
    unset "wallpapers[$wallpaperIndex]"

    # Delay for 15 min hours before selecting the next wallpaper
    wallpapers=("${wallpapers[@]}")
    sleep 900s
done
