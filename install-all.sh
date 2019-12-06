#!/bin/sh

# Install basic tools and apps on a fresh copy of Mac OS X
# Reference: https://gist.github.com/millermedeiros/6615994

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
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Checking Homebrew installation"
brew doctor

echo "Setting up Homebrew permissions for local user"
sudo chown -R $(whoami) $(brew --prefix)/*

# Continue on error
set +e

# Disable Homebrew updates temporarily to save time
HOMEBREW_NO_AUTO_UPDATE=1

echo "Installing missing tools with Homebrew"
tools=(
  git
  git-extras
  git-fresh
  git-lfs
  wget
  tree
  htop
  parallel
  watch
  imagemagick
  nmap
  geoip
  jq
  xsv
  node
  r
  python
  elasticsearch
  postgresql
)

brew install ${tools[@]} || true

echo "Installing apps with Homebrew casks"

# Set folder for app installs
# APP_DIR="/Users/$USER/Applications"
APP_DIR="/Applications"

apps=(
  firefox
  google-chrome
  1password
  visual-studio-code
  virtualbox
  docker
  rstudio
  dash
  charles
  the-unarchiver
  google-cloud-sdk
  cyberduck
  owncloud
  imageoptim
  skype-for-business
  slack
  keybase
  signal
  vlc
)

brew cask install --appdir=$APP_DIR ${apps[@]} || true

echo "Cleaning up Homebrew"
brew cleanup

# echo "Installing Oh My ZSH!"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# echo "Setting ZSH als default shell"
# chsh -s /bin/zsh
