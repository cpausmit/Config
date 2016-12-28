#!/bin/bash
#===================================================================================
# Try to mount the export drive.
#===================================================================================

echo ""
echo " Test whether /export mounted already"
echo ""
if [ ".`df -h |grep /export`" != "." ]
then
  echo " -> already mounted, exit here!"
echo ""
  exit 0
fi

echo ""
echo " Trying to mount external drive -- start loop"
echo ""
for drive in b c d
do
  test=`sudo fdisk -l /dev/sd${drive} |tr -s ' '|grep dev/sd${drive}1 2> /dev/null`
  echo " -> tested drive: $drive -- result: $test"
  if [ ".$test" == "./dev/sd${drive}1 63 3907029167 3907029105 1.8T 83 Linux" ]
  then
    echo "Try to mount /dev/sd${drive}"
    sudo mount /dev/sd${drive}1 /export
    echo ""
    exit 0
  fi
done

exit 0
