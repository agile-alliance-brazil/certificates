#!/usr/bin/env bash
set -e
# set -x # Uncomment for debug

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${MY_DIR}

${MY_DIR}/setup.sh

if [ ! -z $(uname | grep Darwin) ] && [ -z $(which terminal-notifier) ]; then
  if [ ! -z $(which brew) ]; then
    echo "Installing terminal-notifier via brew..."
    brew install terminal-notifier
  else
    echo "Please ensure terminal-notifier is in your path or, at least, brew is in your path."
    echo "Proceeding since terminal-notifier is only optional."
  fi
fi

bundle exec guard
