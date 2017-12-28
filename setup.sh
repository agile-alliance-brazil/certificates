#!/usr/bin/env bash
set -e
# set -x # Uncomment for debug

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${MY_DIR}

if [ -z $(command -v curl) ]; then
  echo "Please ensure the command line utility curl is installed and try again" && exit 1
fi

if [ -z $(command -v ruby) ]; then
  echo "Please ensure ruby is installed and try again" && exit 1
fi

if [ -z $( (uname | grep Darwin &> /dev/null) && command -v brew ) ]; then
  echo "Installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [ -z $(command -v inkscape) ]; then
  echo "Installing inkscape..."
  if [ ! -z $(uname | grep Darwin) ]; then
    ((brew --version > /dev/null) && (brew tap caskroom/cask > /dev/null) && (brew cask install xquartz inkscape))
  else
    ((apt-get --version > /dev/null) && (apt-get install inkscape))
  fi
fi

if [ -z $(command -v bundle) ]; then
  gem install bundler
fi

bundle install

if [ ! -f "${MY_DIR}/.env" ]; then
  echo "Creating standard .env file. Please ensure the values in that file make sense before continuing..."
  cp "${MY_DIR}/.env{.example,}"
fi
