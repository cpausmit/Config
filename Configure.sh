#!/bin/bash
#-------------------------------------------------------------------------------
# Install the Config package into your account. The starting point is a
# "git clone" of the Config.
#
#   git clone https://github.com/cpausmit/Config.git
#
#-------------------------------------------------------------------------------
function linkDotFile {
  file="$1"
  echo ""
  echo " Creating a soft link for $file"
  if [ -e "$HOME/$file" ]
  then
    echo ""
    echo " Found an existing dotFile: $file"
    mv $HOME/$file  $HOME/$file.$$    
  fi
  ln -s $HOME/Config/dotFiles/$file $HOME/
}

# First step is to soft link the $HOME/bin directory (safely)

if [ -e "$HOME/bin" ]
then
  echo ""
  echo " Found an existing bin directory. Move it to: $HOME/bin.$$"
  mv $HOME/bin  $HOME/bin.$$
fi

echo ""
echo " Create soft link: ln -s $HOME/Config/bin $HOME/bin"; echo ""
ln -s $HOME/Config/bin $HOME/bin

# Next establish the dot files

linkDotFile ".bashrc"
linkDotFile ".bash_profile"
linkDotFile ".Xdefaults"
linkDotFile ".aliases-cms"

echo ""
echo " -- DONE --"

exit 0

