#!/bin/bash

usage=" retrieve_backup.sh <file or directory>"

source XX-BU_BASE-XX/setup.sh

echo " You are user: $USER"

FILE=$1


if [ ".$FILE" == "." ]
then
  echo " ERROR - Specify the desired directory to recover, starting from your user name (i.e $USER/..)"
  echo ""
  echo " Usage: $usage "
  echo ""
fi

cd /tmp/
mkdir -p /tmp/$USER
cd       /tmp/$USER
latest_complete=`ls -1 $BU_BASE/complete/$USER/*.tgz | tail -1`

echo " Checking for last complete version in $latest_complete"
echo "\
    tar fzx $latest_complete $BU_TARGET/$FILE"
    tar fzx $latest_complete $BU_TARGET/$FILE

for file in `ls -1 $BU_BASE/incremental/$USER/*.tgz`
do
  echo " Checking for incremental version in $file"
  echo "\
    tar fzx $file $BU_TARGET/$FILE"
    tar fzx $file $BU_TARGET/$FILE 2> /dev/null
done

echo " Find backup in: /tmp/$USER$BU_TARGET/"

exit 0
