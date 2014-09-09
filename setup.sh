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
#
# TODO(awdavies) Add in an auto-installation of oh-my-zsh, and copying of your
# own zshrc and zalias files.  This will require running a git clone.

# The files we'll be (potentially) linking.  This will have to manually
# be expanded as dotfiles are added.

#######################
# COLORS
#######################
# Uncomment the color theme you want in Xresource.
# If you make your own, make sure to put it in an Xresources file named
# .Xresources.[theme_name]_colors so as to be detected by the regex.
#
# The file itself should be inside of the same directory as this script.
#
XRESOURCES_THEME="solarized"
#XRESOURCES_THEME="tomorrow_night_eighties_colors"
#XRESOURCES_THEME="some_theme"
XRESOURCES_THEME_FILE=$HOME/.Xresources.$XRESOURCES_THEME
COLOR_REGEX="^#include<$HOME\/\.Xresources\.\w+?colors>$"

#######################
# INSTALL FILES
#######################
FILES=(\
  .vimrc \
  .vim \
  .tmux.conf \
  .Xresources \
  .Xresources.$XRESOURCES_THEME \
)
OHMYZSHURL=https://github.com/awdavies/oh-my-zsh

# YCM Compilation stuff.
YCM_STATUS_FILE=./.ycm_installed
YCM_ROOT_DIR=.vim/bundle/you_complete_me
YCM_OUT=/tmp/ycm_comp_out
YCM_ERR=/tmp/ycm_comp_err

echo "RUNNING SETUP"
git submodule init
git submodule update --init --recursive

# Push and pop util functions.
function _push() {
  pushd $(pwd) 1>/dev/null
}
function _pop() {
  popd 1>/dev/null
}
function soft_link() {
  local f=`basename $1`
  echo -en "[ $f ]"
  if [[ -e "$2/$f" ]]
  then
    echo -e "\t\t\tExists. Ignoring."
  else
    ln -s "$1" "$2" >/dev/null 2>/dev/null
    if [[ $? ]]
    then
      echo -e "\t\t\tLinked Successfully."
    else
      echo -e "\t\t\tLinking Failed."
    fi
  fi
}

# Setup all the files.
for f in ${FILES[@]}
do
  soft_link "`pwd`/$f" $HOME
done

# Create vim backup directory.
if [[ ! -e "$HOME/.vim" || ! -e "$HOME/.vim/tmp" ]]
then
  echo "Creating vim tmp directory. . ."
  mkdir -p "$HOME/.vim/tmp"
fi

# Set up oh-my-zsh.
_push
ZSHDIR=.oh-my-zsh
cd $HOME
if [[ ! -e $ZSHDIR ]]
then
  echo "Creating zsh configuration. . ."
  git clone $OHMYZSHURL $ZSHDIR
fi

if [[ ! -e $HOME/.zshrc && -e $HOME/$ZSHDIR ]]
then
  cp $ZSHDIR/templates/zshrc.zsh-template $HOME/.zshrc
fi
_pop
echo

# Setup herbstluftwm config.
HERB_DIR=.config/herbstluftwm/
_push
cd $HOME
mkdir -p ${HERB_DIR}
_pop
soft_link "`pwd`/autostart" "${HOME}/${HERB_DIR}"

# Add color theme inclusion to Xresources if it doesn't exist.
RES=$(egrep $COLOR_REGEX $HOME/.Xresources)
if [[ ! $RES && -e $XRESOURCES_THEME_FILE ]]
then
  echo "Adding theme [$XRESOURCES_THEME] to Xresources. . ."
  echo "#include<$HOME/.Xresources.$XRESOURCES_THEME>" >> $HOME/.Xresources
fi

# Compile and install you_complete_me for vim.
if [[ ! -e $YCM_STATUS_FILE ]]
then
  WD=$(pwd)
  _push
  echo "Installing You Complete Me for Vim. Run"
  echo
  echo -e "\ttail -f $YCM_OUT"
  echo
  echo "For details. . ."
  cd "$WD/$YCM_ROOT_DIR"
  ./install.sh 1>$YCM_OUT 2>$YCM_ERR
  INSTALL_RES=$?
  _pop
  if [[ ! $INSTALL_RES ]]
  then
    echo "You Complete Me Compilation Failed.  Check $YCM_ERR for details"
  else
    touch $YCM_STATUS_FILE
  fi
  rm -f $YCM_OUT $YCM_ERR
fi

# Run xrdb if necessary.
if [[ -e "$HOME/.Xresources" ]]
then
  echo "Running xrdb. . ."
  xrdb "$HOME/.Xresources"
fi

echo "DONE"
