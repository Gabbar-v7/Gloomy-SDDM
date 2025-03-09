#!/bin/bash

# Gloomy SDDM Installer made by Gabbar-v7
# Visit https://GitHub.com/Gabbar-v7

# Cool designed header
echo ""
echo "#####################################################"
echo "#                                                   #"
echo "#         GLOOMY-SDDM Theme Installer               #"
echo "#              Made by Gabbar-v7                    #"
echo "#                   Visit                           #"
echo "#     https://github.com/Gabbar-v7/Gloomy-SDDM      #"
echo "#                                                   #"
echo "#####################################################"
echo ""

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
	sudo sed -i '/^\[Theme\]/{N;s/^\[Theme\]\nCurrent=.*/[Theme]\nCurrent='$THEME_NAME'/}' "$SDDM_CONF" ||
		echo -e "\n[Theme]\nCurrent=$THEME_NAME" | sudo tee -a "$SDDM_CONF" >/dev/null
else
	echo -e "[Theme]\nCurrent=$THEME_NAME" | sudo tee "$SDDM_CONF" >/dev/null
fi

# Prompt user to enable NumLock
read -p "Do you want to enable NumLock on SDDM? (y/n): " enable_numlock
if [[ $enable_numlock == "y" || $enable_numlock == "Y" ]]; then
	echo "Enabling NumLock..."
	if grep -q "Numlock=" "$SDDM_CONF"; then
		sudo sed -i 's/^Numlock=.*/Numlock=on/' "$SDDM_CONF"
	else
		echo -e "\n[General]\nNumlock=on" | sudo tee -a "$SDDM_CONF" >/dev/null
	fi
else
	echo "NumLock will not be enabled."
fi

# Wait for user confirmation before restarting SDDM
echo "Theme installed. Press Enter to restart SDDM..."
read

# Restart the SDDM service
echo "Restarting SDDM..."
sudo systemctl restart sddm.service

echo "Done!"
