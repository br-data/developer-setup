#!/bin/sh

# Install basic tools and apps on a fresh copy of Mac OS X
# Reference: https://gist.github.com/millermedeiros/6615994

echo "Installing software and tools for macOS"

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

if [[ $(xcode-select -p) = *CommandLineTools* ]]; then
  echo "Xcode is already installed."
else
  echo "Installing Xcode utilities"
  xcode-select --install
fi

if [[ $(command -v brew) = *brew* ]]; then
  if [[ -z "${CI}" ]]; then
    echo "Updating Homebrew installation"
    brew update
  fi
else
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Checking Homebrew installation"
brew doctor

# Use with caution! This should not be necessary on most systems 
# if [[ $(brew --prefix) = *homebrew* ]]; then
#   echo "Setting up Homebrew permissions for local user"
#   sudo chown -R $(whoami) $(brew --prefix)/*
# else
#   echo "Can't set Homebrew permissions, because no prefix was found"
# fi

# Continue on error
set +e

# Disable Homebrew updates temporarily to save time
HOMEBREW_NO_AUTO_UPDATE=1

echo "Installing missing tools with Homebrew"
tools=(
  docker
  htop
  imagemagick
  jq
  nmap
  nvm
  parallel
  postgresql
  python
  r
  tree
  watch
  wget
  xsv
  zsh
  android-platform-tools
  google-cloud-sdk
  cocoapods
)

brew install ${tools[@]} || true

echo "Installing apps with Homebrew casks"

# Set folder for app installs
# APP_DIR="/Users/$USER/Applications"
APP_DIR="/Applications"

apps=(
  1password
  citrix-workspace
  firefox
  google-chrome
  google-cloud-sdk
  imageoptim
  insomnia
  microsoft-teams
  postico
  rstudio
  signal
  visual-studio-code
  vlc
  microsoft-excel
  microsoft-word
  android-studio
  microsoft-outlook
  drawio
  displaylink
)

# TODO: Skip if already installed!
brew install --cask --appdir=$APP_DIR ${apps[@]} || true

echo "Cleaning up Homebrew"
brew cleanup

echo "Installing Oh My ZSH!"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Setting ZSH als default shell"
chsh -s /bin/zsh

echo "Setup nvm"
mkdir ~/.nvm
sed -i~ '\nexport NVM_DIR="$HOME/.nvm"\n. "/usr/local/opt/nvm/nvm.sh"' ~/.zshrc

echo "Setup Gcloud"
sed -i~ 'source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"' ~/.zshrc
sed -i~ 'source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"' ~/.zshrc

echo "Installing GCloud utils"
gcloud components install kubectl gke-gcloud-auth-plugin