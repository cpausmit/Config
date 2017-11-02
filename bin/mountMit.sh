#!/bin/bash
#===================================================================================================
# Try to mount the external drive from t3desk004.mit.edu
#===================================================================================================
MOUNT_SERVER="t3desk004.mit.edu"
MOUNT_DIR="/home"
MOUNT_POINT="/desk004"
MOUNT_USER="paus"

# check whether mount point exists and create if needed
if [ -d "$MOUNT_POINT" ]
then
  echo " Mount point ($MOUNT_POINT) exists."
else
  echo " Mount point ($MOUNT_POINT) does not exists. Creating it now."
  mkdir -p "$MOUNT_POINT"
fi

# check whether external already mounted
test=`df -h| grep $MOUNT_POINT`
if [ ".$test" != "." ]
then
  # external already mounted (fine)
  echo " SUCCESS - it's already mounted!"
  ls -lhrt $MOUNT_POINT/ 2> /dev/null
  read -p "press return!" q
  exit 0
fi

# check whether computer is online
ping -c 2 $MOUNT_SERVER
if [ ".$?" == ".0"  ]
then
  # computer online, try to mount
  echo " $MOUNT_SERVER is online. Let's try to mount (should be quick)!"
  sudo mount $MOUNT_SERVER:$MOUNT_DIR -t nfs $MOUNT_POINT
  if [ ".$?" != ".0"  ]
  then
    echo " $MOUNT_SERVER is online but not properly configured. Sorry!"
    echo " try: ssh root@t3desk004.mit.edu service nfs-server restart"
    read -p "press return!" q
    exit 1
  else
    echo " SUCCESS - It worked: "
    ls -lhrt $MOUNT_POINT/ 2> /dev/null
  fi
else
  echo " $MOUNT_SERVER is not online, switch on and try one more time!"
  read -p "press return!" q
  exit 1
fi

# make sure we are in the home directory
cd
links="Documents text Work"
for link in $links
do
  if ! [ -e "$link" ]
  then
    ln -s $MOUNT_POINT/$MOUNT_USER/$link
  fi
done
ls -lhrt

read -p "press return!" q
exit 0
