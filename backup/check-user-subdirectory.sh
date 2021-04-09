#!/bin/bash
#
# If a user was not present before the backup ran or the backup runs
# for the first time new directories might need to be created.

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
