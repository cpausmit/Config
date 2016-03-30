#!/bin/bash
PACKAGE="$1"

if [ -d "$PACKAGE" ]
then
  cd $PACKAGE
  git checkout master
  git fetch origin
  git merge origin/master
else
  echo " Package does not exist. EXIT!"
fi
