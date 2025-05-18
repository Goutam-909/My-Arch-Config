#!/usr/bin/env bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# This script for selecting wallpapers (SUPER W) with pywal integration

# Wallpapers Path
wallpaperDir="$HOME/Pictures/wallpapers"
themesDir="$HOME/.config/rofi/themes"
currentWallpaper="/home/goutam01/.cache/current_wallpaper"

# Transition config
FPS=60
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

# Check if pywal is installed
if ! command -v wal &>/dev/null; then
  echo "pywal is not installed. Please install it first."
  exit 1
fi

# Retrieve image files as a list
PICS=($(find -L "${wallpaperDir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort ))

# Use date variable to increase randomness
randomNumber=$(( ($(date +%s) + RANDOM) + $$ ))
randomPicture="${PICS[$(( randomNumber % ${#PICS[@]} ))]}"
randomChoice="[${#PICS[@]}] Random"

# Rofi command
rofiCommand="rofi -show -dmenu -theme ${themesDir}/wallpaper-select.rasi"

# Execute command according the wallpaper manager and generate pywal colors
executeCommand() {
  # Set the wallpaper based on installed wallpaper manager
  if command -v swww &>/dev/null; then
    swww img "$1" ${SWWW_PARAMS}

  elif command -v swaybg &>/dev/null; then
    swaybg -i "$1" &
  
  else
    echo "Neither swww nor swaybg are installed."
    exit 1
  fi

  # Save current wallpaper path
  ln -sf "$1" "$currentWallpaper"
  
  # Generate color scheme with pywal
  # -n flag to skip setting the wallpaper (we already did that)
  # -q flag for quiet mode
  wal -i "$1" -n -q
  
  echo "Wallpaper set to: $1"
  echo "Colors extracted with pywal."
}

# Show the images
menu() {
  printf "$randomChoice\n"

  for i in "${!PICS[@]}"; do
    # If not *.gif, display
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(basename "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${PICS[$i]}\n"
    else
    # Displaying .gif to indicate animated images
      printf "$(basename "${PICS[$i]}")\n"
    fi
  done
}

# If swww exists, start it
if command -v swww &>/dev/null; then
  swww query || swww init
fi

# Execution
main() {
  choice=$(menu | ${rofiCommand})

  # No choice case
  if [[ -z $choice ]]; then
    exit 0
  fi

  # Random choice case
  if [ "$choice" = "$randomChoice" ]; then
    executeCommand "${randomPicture}"
    return 0
  fi

  # Find the selected file
  for file in "${PICS[@]}"; do
  # Getting the file
    if [[ "$(basename "$file" | cut -d. -f1)" = "$choice" ]]; then
      selectedFile="$file"
      break
    fi
  done

  # Check the file and execute
  if [[ -n "$selectedFile" ]]; then
    executeCommand "${selectedFile}"
    return 0
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main
if pgrep -x "swaync" > /dev/null; then
    killall -q swaync
    sleep 0.5  # Give it time to shut down properly
fi
swaync &
