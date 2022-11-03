#!/bin/sh

# Basic configuration for a freshly installed macOS
# Reference: https://github.com/mathiasbynens/dotfiles/blob/main/.macos

echo "Setting up configuration for macOS"

echo "Closing all open System Preferences panes"
osascript -e 'tell application "System Preferences" to quit'

echo "Checking if user $(whoami) has admin rights. Please authenticate."

if [ "$EUID" = 0 ]; then
  echo "Great, user is already logged in as admin."
else
  sudo -k
  if sudo true; then
    echo "Great, you can run scripts as administrator."
  else
    echo "Wrong password or no admin rights."
    exit 1
  fi
fi

# System settings

echo "System: Disable boot sound"
sudo nvram SystemAudioVolume=" "

echo "System: Require password immediately after sleep or screen saver"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "System: Disable machine sleep while charging"
sudo pmset -c sleep 0

echo "System: Turn off display after 10 minutes"
sudo pmset -a displaysleep 10

echo "System: Store screenshots in subfolder on desktop"
mkdir ~/Desktop/Screenshots
defaults write com.apple.screencapture location ~/Desktop/Screenshots

echo "System: Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "System: Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "System: Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "System: Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "System: Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Input settings

echo "Trackpad: Disable natural scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "Trackpad: Enable tap to click"
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Keyboard: Enable full keyboard accessibility"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# echo "Keyboard: Set keyboard repeat rate to fast"
# defaults write NSGlobalDomain KeyRepeat -int 1
# defaults write NSGlobalDomain InitialKeyRepeat -int 10

echo "Hot corners: Set action for each corner"
# Top left screen corner: Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right screen corner: Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom right screen corner: Put display to sleep
defaults write com.apple.dock wvous-br-corner -int 10
defaults write com.apple.dock wvous-br-modifier -int 0

# Bottom left screen corner: Do nothing
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

# Finder settings

echo "Finder: Set default location to home folder (~/)"
defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

echo "Finder: Show icons for external media and servers on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "Finder: Use current directory as default search scope"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Finder: Show the ~/Library folder"
chflags nohidden ~/Library

# echo "Finder: Show Path bar"
# defaults write com.apple.finder ShowPathbar -bool true

echo "Finder: Show Status bar"
defaults write com.apple.finder ShowStatusBar -bool true

# echo "Finder: Show hidden files by default"
# defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Finder: Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Finder: Disable warning when changing filename extensions"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# App settings

echo "TextEdit: Use plain text mode for new documents"
defaults write com.apple.TextEdit RichText -int 0

echo "TextEdit: Open and save files as UTF-8"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo "Safari: Enable the Develop menu and the Web Inspector"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "Terminal: Use the Pro theme by default"
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

echo "Terminal: Disable line marks"
defaults write com.apple.Terminal ShowLineMarks -int 0

# Dock settings

echo "Dock: Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "Dock: Don't show recent applications"
defaults write com.apple.dock show-recents -bool false

echo "Dock: Remove all default app icons"
defaults write com.apple.dock persistent-apps -array

# Spotlight settings

echo "Spotlight: Set sources where it should search"
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 0;"name" = "FONTS";}' \
	'{"enabled" = 1;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 1;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 1;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 1;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

echo "Please restart your system for some changes to take effect"

# App store settings

echo "App Store: Turn on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true

echo "App Store: Enable the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo "App Store: Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "App Store: Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo "App Store: Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

echo "App Store: Automatically download apps purchased on other Macs"
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
