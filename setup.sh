#!/bin/bash
#
# This script sets up the dotfiles by moving everything into the
# home directory via symlinks (later I'll add an option to not have
# symlinks for those that don't feel like being able to commit their
# changes to configs, etc).  There'll also be backups, etc.
#
# This script must be run in its containing directory.  Currently
# there are no checks to see which directory we're in or if any of
# the files in question exist.

# The files we'll be (potentially) linking.  This will have to manually
# be expanded as dotfiles are added.
FILES=(.vimrc .vim .tmux.conf .Xresources)


echo "RUNNING SETUP"

git submodule init
git submodule update --init --recursive

# Setup all the files.
for f in ${FILES[@]}
do
  echo -en "[ $f ]"
  if [[ -e "$HOME/$f" ]]
  then
    echo -e "\t\t\tExists. Ignoring."
  else
    # Just symlink all the files blindly for now.
    ln -s "`pwd`/$f" $HOME >/dev/null 2>/dev/null
    if [[ $? ]]
    then
      echo -e "\t\t\tLinked Successfully."
    else
      echo -e "\t\t\tLinking Failed."
    fi
  fi
done

# Create vim backup directory.
if [[ ! -e "$HOME/.vim" || ! -e "$HOME/.vim/tmp" ]]
then
  echo "Creating vim tmp directory. . ."
  mkdir "$HOME/.vim/tmp"
fi

# Run xrdb if necessary
if [[ -e "$HOME/.Xresources" ]]
then
  echo "Running xrdb. . ."
  xrdb "$HOME/.Xresources"
fi

echo "DONE"
