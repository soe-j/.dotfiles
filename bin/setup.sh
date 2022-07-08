#!/bin/zsh -eu


####
#### options
####
if [ $# = 1 ] && [ $1 = '-f' ]
then
  FORCE_LINK=1
else
  FORCE_LINK=0
fi


####
#### provisioning
####
cd $(dirname $0)/..
SCRIPTS_ROOT=$(pwd)
SOURCE_HOME=$SCRIPTS_ROOT/home


####
#### homebrew
####
if [ $(which brew) ]
then
  echo "brew is already installed."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew doctor
brew bundle

if [ $(which fvm) ]
then
  echo "fvm is already activated"
else
  dart pub global activate fvm
fi

if [ $(which rustup) ]
then
  echo "rustup is already installed."
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

####
#### git settings
####
git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor 'code --wait'

####
#### directories
####
OLDIFS=$IFS
IFS=$'\n'
cat $SCRIPTS_ROOT/directories | while read dir
do
  echo ~/$dir
  if [ -d ~/$dir ]
  then
    echo "~/$dir already exists."
  else
    mkdir ~/$dir
    echo "~/$dir created!"
  fi
done
IFS=$OLDIFS


####
#### dotfiles and setting files
####
find $SOURCE_HOME -type f | while read SOURCE_FILE
do
  TARGET_FILE="${HOME}${SOURCE_FILE#$SOURCE_HOME}"

  if [ $FORCE_LINK = 1 ]
  then
    ln -sf "$SOURCE_FILE" "$TARGET_FILE"
    echo "$TARGET_FILE is force linked!"
  else

    if [ -L "$TARGET_FILE" ]
    then
      echo "$TARGET_FILE is already linked!"
    else
      if [ -f "$TARGET_FILE" ]
      then
        echo "$TARGET_FILE is already exists."
        #### TODO all skipping bug ####
        # read -p "overwrite? (y/N) " yn
        # case "$yn" in y) ;; *) continue ;; esac

        cp -f "$TARGET_FILE" "$SOURCE_FILE"
        ln -sf "$SOURCE_FILE" "$TARGET_FILE"
      else
        ln -s "$SOURCE_FILE" "$TARGET_FILE"
      fi
      echo "$TARGET_FILE is linked!"
    fi
  fi
done

source ~/.zshrc

####
#### os
####
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 128
killall Dock

defaults write com.apple.screencapture location ~/Pictures/Screencapture
defaults write com.apple.screencapture name ""
defaults write com.apple.screencapture disable-shadow -boolean true
defaults write com.apple.screencapture show-thumbnail -bool FALSE
killall SystemUIServer
