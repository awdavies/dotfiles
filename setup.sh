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

# The files we'll be (potentially) linking.
FILES=(.vimrc .vim .tmux.conf)

echo "RUNNING SETUP"
# Setup all the files.
for f in ${FILES[@]}
do
  # Just symlink all the files blindly for now.
  ln -s "`pwd`/$f" $HOME
done

# Create vim backup directory.
if [[ ! -e "$HOME/.vim/tmp" ]]
then
  mkdir "$HOME/.vim/tmp"
fi

echo "DONE"