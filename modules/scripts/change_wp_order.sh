#!/usr/bin/env bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/walls/"

# Interval between changes (in seconds)
INTERVAL=900

# File to store the last wallpaper index
STATE_FILE="$HOME/.last_wallpaper_index"

# Get list of image files (sorted for consistent order)
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort)

# Check if wallpapers were found
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No images found in $WALLPAPER_DIR"
    exit 1
fi

TOTAL_WALLPAPERS=${#WALLPAPERS[@]}

# Function to save the current index
save_state() {
    local index=$1
    echo "$index" > "$STATE_FILE"
}

# Function to load the last index
load_state() {
    if [ -f "$STATE_FILE" ]; then
        local idx=$(cat "$STATE_FILE")
        # Validate that the index is within range
        if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -lt "$TOTAL_WALLPAPERS" ]; then
            echo "$idx"
            return
        fi
    fi
    echo "0" # Default to first image if invalid or missing
}

echo "Found $TOTAL_WALLPAPERS wallpapers."

# Determine starting index
START_INDEX=$(load_state)
echo "Resuming from wallpaper index: $START_INDEX"

# Infinite loop
while true; do
    # Use modulo arithmetic to ensure we wrap around if the index somehow exceeds total
    for (( i=0; i<TOTAL_WALLPAPERS; i++ )); do
        current_index=$(( (START_INDEX + i) % TOTAL_WALLPAPERS ))
        wallpaper="${WALLPAPERS[$current_index]}"
        
        echo "Setting wallpaper: $(basename "$wallpaper")"
        awww img "$wallpaper" --resize fit -t random
        
        # Save state before sleeping
        save_state "$current_index"
        
        sleep "$INTERVAL"
    done
    
    # Reset start index to 0 for the next full cycle, 
    # but the logic above handles wrapping automatically anyway.
    START_INDEX=0
done
