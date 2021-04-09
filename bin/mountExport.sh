#!/bin/bash
#===================================================================================
# Try to mount the export drive.
#===================================================================================
MOUNT_POINT="/export"

# check whether mount point exists and create if needed
if [ -d "$MOUNT_POINT" ]
then
  echo " Mount point ($MOUNT_POINT) exists."
else
  echo " Mount point ($MOUNT_POINT) does not exists. Creating it now."
  sudo mkdir -p "$MOUNT_POINT"
fi

# Test whether $MOUNT_POINT mounted already"
if [ ".`df -h |grep $MOUNT_POINT`" != "." ]
then
  echo " -> already mounted, exit here!"
  echo ""
  exit 0
fi

# Trying to mount external drive -- start loop
for drive in `sudo fdisk -l| grep ^/dev/sd|cut -c8|sort -u`
do
  test=`sudo fdisk -l /dev/sd${drive} |tr -s ' '|grep dev/sd${drive}1 2> /dev/null`
  echo " -> tested drive: $drive -- result: $test"
  if [ ".$test" == "./dev/sd${drive}1 63 3907029167 3907029105 1.8T 83 Linux" ]
  then
    echo "Try to mount /dev/sd${drive}"
    sudo mount /dev/sd${drive}1 $MOUNT_POINT
    echo ""
    ls -lhrt /export/
    echo ""
    exit 0
  fi
done

exit 0
