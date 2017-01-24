#!/bin/bash
#===================================================================================================
# Try to mount the external drive from pausserv.home
#===================================================================================================
MOUNT_POINT="/external"

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
ping -c 2 pausserv.home
if [ ".$?" == ".0"  ]
then
  # computer online, try to mount
  echo " pausserv.home (computer in Papi's office) is online. Let's try to mount (should be quick)!"
  sudo mount pausserv.home:/export -t nfs $MOUNT_POINT
  if [ ".$?" != ".0"  ]
  then
    echo " pausserv.home (computer in Papi's office) is online but not properly configured. Sorry!"
    read -p "press return!" q
    exit 1
  else
    echo " SUCCESS - It worked: "
    ls -lhrt $MOUNT_POINT/ 2> /dev/null
  fi
else
  echo " pausserv.home (computer in Papi's office) is not online, switch on and try one more time!"
  read -p "press return!" q
  exit 1
fi

read -p "press return!" q
exit 0
