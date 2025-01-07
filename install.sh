#!/bin/bash

# Variables
THEME_NAME="gloomy"
SOURCE_DIR="$(pwd)/$THEME_NAME"
TARGET_DIR="/usr/share/sddm/themes"
SDDM_CONF="/etc/sddm.conf"

# Check if the theme folder exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Theme folder '$THEME_NAME' does not exist in the current directory."
    exit 1
fi

# Move the theme to the SDDM themes directory
echo "Installing theme '$THEME_NAME'..."
sudo mkdir -p "$TARGET_DIR"
sudo cp -r "$SOURCE_DIR" "$TARGET_DIR"

# Edit or create the SDDM configuration file
echo "Updating SDDM configuration..."
if [ -f "$SDDM_CONF" ]; then
    sudo sed -i '/^\[Theme\]/{N;s/^\[Theme\]\nCurrent=.*/[Theme]\nCurrent='$THEME_NAME'/}' "$SDDM_CONF" || \
    echo -e "\n[Theme]\nCurrent=$THEME_NAME" | sudo tee -a "$SDDM_CONF" > /dev/null
else
    echo -e "[Theme]\nCurrent=$THEME_NAME" | sudo tee "$SDDM_CONF" > /dev/null
fi

# Wait for user confirmation before restarting SDDM
echo "Theme installed. Press Enter to restart SDDM..."
read

# Restart the SDDM service
echo "Restarting SDDM..."
sudo systemctl restart sddm.service

echo "Done!"
