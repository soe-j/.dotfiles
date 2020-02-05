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
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew doctor
brew bundle


####
#### git settings
####
git config --global core.excludesfile ~/.gitignore_global


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

source ~/.zsh_profile


####
#### vscode
####
cat $SCRIPTS_ROOT/vscode-extensions | while read extension
do
  if ! [[ $extension =~ ^\#.*$ ]]
  then
    code --install-extension $extension
  fi
done


####
#### os
####
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 128
killall Dock

defaults write com.apple.screencapture location ~/Pictures/Screencapture
defaults write com.apple.screencapture disable-shadow -boolean true
defaults write com.apple.screencapture show-thumbnail -bool FALSE
killall SystemUIServer
