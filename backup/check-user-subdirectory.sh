#!/bin/bash

subdir=$1
homedir=$2

if [ -e $subdir ]
then
  if ! [ -d $subdir ]
  then
    # Exists and is not a directory. Get rid of it and make the directory.
    rm -f $subdir
    mkdir $subdir
  fi  
else
  # Doesn't exist. Make it.
  mkdir $subdir
fi

# Make sure that ownership is the same as the home directory.
chown --reference=$homedir $subdir
